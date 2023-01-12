INSERT INTO public.events(
	id, address, blockchain, created_at, amount, amount_in, authority, blocknumber, fixed_from_coin, "from", hash, 
	instruction, max_coin_amount, max_pc_amount, min_amount_out, "timestamp", "to", type, token_name, portfolio_id, protocol, updated_at
	)
	
	
	select tx."id",
	(Select accounts.id from accounts where Lower(account_hash) = Lower(tx."address")),
	(Select blockchains.id from blockchains where Lower(blockchain_name) = Lower(tx."blockchain")),
	created_at, amount, amount_in, authority, blocknumber, fixed_from_coin,
	(Select accounts.id from accounts where Lower(account_hash) = Lower(tx."from")),
	hash,instruction, max_coin_amount, max_pc_amount, min_amount_out, "timestamp", 
	(Select accounts.id from accounts where Lower(account_hash) = Lower(tx."to")), 
	(Select event_types.id from event_types where Lower(event_types."type") = Lower(tx."type")), 
	(Select tokens.id from tokens where Lower(token_name) = Lower(tx."token_name")),	
	 (select id from portfolios),	
	(Select protocol.id from protocol where Lower(protocol."name") = Lower(tx."protocol")),
	updated_at
	
	from events_mock tx;	
	
	--update pool_snapshots set token0 = (select id from tokens where token_name = )
	
-- 	update events as tx set unrecognized_from_account = tm.from from events_mock as tm where tx.id = tm.id and tx.from is null;
	
--  	delete from pool_snapshots;