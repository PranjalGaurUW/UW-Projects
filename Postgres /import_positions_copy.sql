INSERT INTO public.positions(
	 avg_cost_buy, avg_cost_sold, short, estimated_apy, quantity, "long", account, token, estimated_apr, blockchain, created_at, updated_at
	)
	
	
	select
	avg_cost_buy, avg_cost_sold, short, estimated_apy, quantity, "long",
	(Select accounts.id from accounts where Lower(account_hash) = Lower(tx."account")),
	(Select tokens.id from tokens where Lower(token_symbol) = Lower(tx."token") order by token_name limit 1),
	estimated_apr,
	(Select blockchains.id from blockchains where Lower(blockchain_name) = Lower(tx."blockchain")),
	tx.created_at, 
	tx.updated_at
	
	from positions_mock tx;	
	