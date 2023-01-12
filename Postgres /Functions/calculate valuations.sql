-- FUNCTION: public.calculate_valuations(integer, numeric)

--DROP FUNCTION IF EXISTS public.calculate_valuations(integer, numeric);

CREATE OR REPLACE FUNCTION public.calculate_valuations(
	position_id integer,
	compunding_period numeric,
	OUT cost_basis numeric,
	OUT valuation numeric,
	OUT unrealized_pnl numeric,
	OUT apr numeric,
	OUT apy numeric)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE blockchain_currency character varying;
DECLARE token_type character varying;
DECLARE current_value_usd numeric;
begin

   -- fetch token info from transaction 
     select token_symbol from tokens where id in (select "token" from positions where id=position_id) into token_type;	 
	
	--fetch blockchain currency info
	select token_symbol from tokens where id=(SELECT currency from blockchains where id in (select "blockchain" from positions where id=position_id)) into blockchain_currency;
	
	 IF token_type IS NOT NULL
	 THEN
		 
		 -- fetch token price
				select close_price from cex_prices cp 
				inner join symbols sm 
				on Lower(cp.symbol) = Lower(sm.symbol)
				where Lower(sm.base_currency) = token_type
				and cp.datetime::timestamp with time zone <= NOW() order by cp.datetime desc limit 1 into current_value_usd;
	ELSE
	
		--fetch currency price
				select close_price from cex_prices cp 
				inner join symbols sm 
				on Lower(cp.symbol) = Lower(sm.symbol)
				where Lower(sm.base_currency) = blockchain_currency
				and cp.datetime::timestamp with time zone <= NOW() order by cp.datetime desc limit 1 into current_value_usd;
	END IF;	
	
	
    -- calculating cost basis
    select positions.avg_cost_buy * positions.quantity from positions where id = position_id into cost_basis;

	-- calculating valuation
    select current_value_usd * positions.quantity from positions where id = position_id into valuation;
	
	-- calculating unrealized_p&l
    select valuation - cost_basis into unrealized_pnl;
	
	--calculating apr
	select 365 * ((unrealized_pnl - cost_basis) /cost_basis) into apr;
	
	--calculating apy
	select POWER((1+(apr/compunding_period)),compunding_period) - 1 into apy;
	
end;
$BODY$;

	
	
	
	SELECT * FROM calculate_valuations(68,2) ;
	
