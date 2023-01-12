-- SELECT * FROM public.transactions where operation is not null;

-- SELECT * FROM public.transactions_mock where operation is not null;

with cte as (SELECT 
  id, hash, "timestamp", description, value_in_usd, fee, comments, gas_used, gas_price, block_number, token,
			 UNNEST(STRING_TO_ARRAY(operation, ','))::character varying AS operation,
			 blockchain, platform, from_account_id, to_account_id, quantity, unidentified_from_account, unidentified_to_account,
			 trade_id, gas_price_in_usd, protocol, error, created_at, updated_at
	
FROM transactions_mock where id in (SELECT id FROM public.transactions where operation >6))

Insert into transactions_mock2 (hash, "timestamp", description, value_in_usd, fee, comments, gas_used, gas_price, block_number, token,
			 operation,
			 blockchain, platform, from_account_id, to_account_id, quantity, unidentified_from_account, unidentified_to_account,
			 trade_id, gas_price_in_usd, protocol, error, created_at, updated_at)
SELECT  hash, "timestamp", description, value_in_usd, fee, comments, gas_used, gas_price, block_number, token,
			 operation,
			 blockchain, platform, from_account_id, to_account_id, quantity, unidentified_from_account, unidentified_to_account,
			 trade_id, gas_price_in_usd, protocol, error, created_at, updated_at
FROM cte;
-- where id in (select id from cte);


SELECT * FROM public.transactions_mock2 where id in (SELECT id FROM public.transactions where operation >6)

SELECT distinct(operation) FROM public.transactions_mock2
SELECT distinct(operation) FROM public.transactions_mock
-- SELECT distinct(operation) FROM public.transactions_mock where id in ( SELECT id FROM public.transactions where operation <7)

-- SELECT 
--   *,
--   UNNEST(STRING_TO_ARRAY(operation, ',')) AS operation_split
-- FROM transactions_mock where id in (SELECT id FROM public.transactions where operation >6);

-- delete from transactions_mock2

-- with id_to_replace as (SELECT id FROM public.transactions where operation >6),
-- update transactions_mock 


-- Insert into transactions_mock2 SELECT * FROM public.transactions_mock where id in (SELECT id FROM public.transactions where operation >6)







-- select distinct(operation) from transactions
-- select id from transaction_operations inner join subq on subq.operation = transaction_operations.operation_name
