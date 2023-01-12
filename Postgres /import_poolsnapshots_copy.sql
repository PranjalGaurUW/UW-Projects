INSERT INTO public.pool_snapshots(
	id, address, blockchain, created_at, value_usd, token0, poolshare, protocol, reserves0, reserves1, staked_token, tvl, updated_at, token1)
	
	
	select tx."id",
	(Select accounts.id from accounts where Lower(account_hash) = Lower(tx."address")),
	(Select blockchains.id from blockchains where Lower(blockchain_name) = Lower(tx."blockchain")),
	created_at, value_usd, 
	(Select tokens.id from tokens where Lower(token_symbol) = Lower(tx."token0") order by token_symbol limit 1), 
	poolshare, 
	(Select protocol.id from protocol where Lower(protocol."name") = Lower(tx."protocol")), 
	reserves0, reserves1, staked_token, tvl, updated_at,
	(Select tokens.id from tokens where Lower(token_symbol) = Lower(tx."token1") order by token_symbol limit 1) 
	
	from pool_snapshots_mock tx;	
	
	--update pool_snapshots set token0 = (select id from tokens where token_name = )
-- 	update pool_snapshots as tx set unidentified_token1 = tm.token1 from pool_snapshots_mock as tm where tx.id = tm.id and tx.token1 is null;
	
--  	delete from pool_snapshots;