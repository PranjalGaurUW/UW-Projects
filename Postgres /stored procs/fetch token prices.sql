create or replace procedure fetch_token_prices_in_usd(
   txn_id character varying
)
language plpgsql    
as $$
DECLARE token_type character varying;
DECLARE value_usd numeric;
DECLARE txn_date timestamp with time zone;
DECLARE rows_count integer;
begin
    -- fetch token info from transaction 
     select token_symbol from tokens where id in (select "token" from transactions where id=txn_id::uuid) into token_type;
	
	--fetch transaction date
	select created_at from transactions where id =txn_id::uuid into txn_date;
	
	-- fetch token price
	select close_price from cex_prices cp 
	inner join symbols sm 
	on Lower(cp.symbol) = Lower(sm.symbol)
	where Lower(sm.base_currency) = token_type
	and cp.datetime::timestamp with time zone <= txn_date order by cp.datetime desc limit 1 into value_usd;
	
    -- update the txn table with value in usd
    update transactions 
    set value_in_usd = value_usd 
    where id = txn_id::uuid;
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    commit;
	
	RAISE NOTICE 'The rows affected =% ', rows_count ;
end;$$





-- call fetch_token_prices_in_usd('0bdc8507-7989-45de-9cda-57dfae3e2d49');




