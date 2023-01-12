
---------------------------------------------------Test with Insert query---------------------------------
INSERT INTO public.transactions(
	 hash, "timestamp", description, value_in_usd, fee, comments, gas_used, gas_price, block_number, token, operation, blockchain, platform, from_account_id, to_account_id, quantity, unidentified_from_account, unidentified_to_account, trade_id, gas_price_in_usd, protocol, error, created_at, updated_at)
	VALUES ( 'dummy', 12345, 'dummy', null, 0.5, null, null, 10000, null, 740, null, 9, null, 322, 2, 0.3456, null, null, null, null, null, null, CURRENT_DATE, CURRENT_DATE);
	

	
	SELECT id, hash, "timestamp", description, value_in_usd, fee, comments, gas_used, gas_price, block_number, token, operation, blockchain, platform, from_account_id, to_account_id, quantity, unidentified_from_account, unidentified_to_account, trade_id, gas_price_in_usd, protocol, error, created_at, updated_at
	FROM public.transactions where hash ='dummy';
	
	
-- 	delete from transactions where hash='dummy' and timestamp = 12345;	

---------------------------------------------------Test with Insert query---------------------------------

-- 	SELECT tgname FROM pg_trigger
----------------------------------------------------------------------------------------------------------------


-- SELECT id, avg_cost_buy, avg_cost_sold, short, estimated_apy, quantity, "long", account, token, estimated_apr, blockchain, created_at, updated_at, value_in_usd, portfolio_id
-- 	FROM public.positions where account=2 or account=322 order by created_at desc;
	
	
-- 	delete from positions where account=2 or account=322



-- SELECT id, account_id, transaction_id, transaction_type, value, "position"
-- 	FROM public.ledger;
	
	
-- 	delete from ledger

	
	
	
	