-- FUNCTION: public.fetch_token_prices_in_usd()

-- DROP FUNCTION IF EXISTS public.fetch_token_prices_in_usd();

CREATE OR REPLACE FUNCTION public.fetch_token_prices_in_usd()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE blockchain_currency character varying;
DECLARE currency_price_usd numeric;
DECLARE token_type character varying;
DECLARE value_usd numeric;
DECLARE txn_date timestamp with time zone;
DECLARE rows_count integer;
begin

    -- fetch token info from transaction 
     select token_symbol from tokens where id in (select "token" from transactions where id=New.id) into token_type;
	 
 	 --fetch transaction date
	select created_at from transactions where id =New.id into txn_date;
	
	--fetch blockchain currency info
	select token_symbol from tokens where id=(SELECT currency from blockchains where id in (select "blockchain" from transactions where id=New.id)) into blockchain_currency;
	
	--fetch currency price
	select close_price from cex_prices cp 
				inner join symbols sm 
				on Lower(cp.symbol) = Lower(sm.symbol)
				where Lower(sm.base_currency) = blockchain_currency
				and cp.datetime::timestamp with time zone <= txn_date order by cp.datetime desc limit 1 into currency_price_usd;
	
	
	--Insert txn fee in usd into fee table

	INSERT INTO public.transaction_fee(
	value_in_usd, tx_id)
	VALUES (currency_price_usd*New.fee, New.id);
	
	
	 IF token_type IS NOT NULL
	 THEN
		 
		 -- fetch token price
				select close_price from cex_prices cp 
				inner join symbols sm 
				on Lower(cp.symbol) = Lower(sm.symbol)
				where Lower(sm.base_currency) = token_type
				and cp.datetime::timestamp with time zone <= txn_date order by cp.datetime desc limit 1 into value_usd;

				-- update the txn table with value in usd and gas price
				update transactions 
				set gas_price_in_usd = currency_price_usd * New.gas_price,
				value_in_usd = value_usd * New.quantity
				where id = New.id;
		 
	 ELSE
	 
	 	-- update the txn table with value in usd for asset txns (without tokens) and gas price
				update transactions 
				set gas_price_in_usd = currency_price_usd * New.gas_price, 
				value_in_usd = currency_price_usd*New.quantity				
				where id = New.id;
				
	 END IF;
	
	RETURN NEW;
end;
$BODY$;

ALTER FUNCTION public.fetch_token_prices_in_usd()
    OWNER TO postgres;
