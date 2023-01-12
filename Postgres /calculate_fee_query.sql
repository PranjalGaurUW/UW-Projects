SELECT id, value_in_usd, tx_id
	FROM public.transaction_fee;
	
	
	
	--taking the most recent price just before the transaction happened
	update transaction_fee
	set value_in_usd = tx.fee*(select matic from token_prices_mock where createdAt <= tx.created_at order by createdAt desc limit 1)
	from transactions tx
	where tx.blockchain =4;
	
-- 	select matic from token_prices_mock tp
-- 	inner join transactions tx
-- 	on tp.createdAt = tx.created_at
	
	with tx as (select * from transactions where blockchain =4) 
	select * from tx;
	
	--insert into transaction_fee (tx_id)  (select id from transactions)
	
	
	
	--select matic from token_prices_mock where createdAt <= '2022-09-28 13:15:25.576-04' order by createdAt desc limit 1
	
	
	
	
	
	
	
	
	