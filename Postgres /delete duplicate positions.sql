SELECT id, avg_cost_buy, avg_cost_sold, short, estimated_apy, quantity, "long", account, token, estimated_apr, portfolio_id, blockchain, created_at, updated_at
	FROM public.positions where account =3120 and token =546 order by created_at desc;
	
	
delete FROM positions
WHERE id IN
	(SELECT id
    FROM 
        (SELECT *,
         ROW_NUMBER() OVER( PARTITION BY account, token 
        ORDER BY  created_at desc ) AS row_num
        FROM positions ) t
        WHERE t.row_num > 1 ) ;
		
		
		
-- 		select account,token,count(*)
-- from positions
-- group by account,token
-- having count(*) > 1;