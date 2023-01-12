INSERT INTO public.transactions(
	 id, hash, "timestamp", description, value_in_usd, fee, comments, gas_used, gas_price, block_number, 
	token, operation, blockchain, from_account_id, to_account_id, quantity, 
	unidentified_from_account, unidentified_to_account, gas_price_in_usd, error, created_at, updated_at)
	
	
	select tx."id", hash, "timestamp", description, value_in_usd, fee, comments, gas_used, gas_price, block_number, 
	(Select tokens.id from tokens where token_name = tx."token"), 
	(Select transaction_operations.id from transaction_operations where operation_name = tx."operation"), 
	(Select blockchains.id from blockchains where blockchains.blockchain_name = tx."blockchain"),
	(Select accounts.id from accounts where Lower(accounts.account_hash) = Lower(tx."from_account_id")), 
	(Select accounts.id from accounts where Lower(accounts.account_hash)= Lower(tx."to_account_id")), 
	quantity, 
	unidentified_from_account, unidentified_to_account, gas_price_in_usd, error, created_at, updated_at
	
	from transactions_mock tx;
	
	select * from transactions;	
	
	
	
	
		
-- update transactions as tx set unidentified_from_account = tm.from_account_id from transactions_mock as tm where tx.id = tm.id and tx.from_account_id is null;

	
-- 	delete from transactions 
	
	
-- 	delete from transactions;