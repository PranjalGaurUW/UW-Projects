-- FUNCTION: public.populate_ledger()

-- DROP FUNCTION IF EXISTS public.populate_ledger();

CREATE OR REPLACE FUNCTION public.populate_ledger()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE from_acc integer;
DECLARE pos_id integer;
DECLARE to_acc integer;
DECLARE tx_fee numeric;
begin

	IF New.from_account_id IS NOT NULL AND New.to_account_id IS NOT NULL 
	THEN
    	 SELECT New.from_account_id into from_acc;
		 SELECT New.to_account_id into to_acc;
		 SELECT value_in_usd from transaction_fee where tx_id = New.id into tx_fee;
	
	-- insert into position for sender 
    INSERT INTO public.positions(
	quantity, account, token, blockchain, created_at, updated_at, value_in_usd, portfolio_id,sold_qty, avg_cost_sold, buy_qty, avg_cost_buy)
	VALUES (-1*New.quantity, from_acc, New.token, New.blockchain, New.created_at, New.updated_at, -1*New.value_in_usd, 1, New.quantity, (New.value_in_usd+tx_fee)/New.quantity,0,0)
	
	ON CONFLICT (account, token) DO
	
	UPDATE
	set quantity = positions.quantity - New.quantity,
	avg_cost_sold = ((positions.avg_cost_sold*positions.sold_qty)+(New.value_in_usd+tx_fee))/(positions.sold_qty + New.quantity),
	sold_qty = positions.sold_qty + New.quantity,
	value_in_usd = positions.value_in_usd - New.value_in_usd
	where positions.account = from_acc and positions.token = New.token;
	
	
	-- insert into position for receiver
	INSERT INTO public.positions(
	quantity, account, token, blockchain, created_at, updated_at, value_in_usd, portfolio_id, buy_qty, avg_cost_buy,sold_qty, avg_cost_sold)
	VALUES (New.quantity, to_acc, New.token, New.blockchain, New.created_at, New.updated_at, New.value_in_usd, 1, New.quantity, (New.value_in_usd+tx_fee)/New.quantity,0,0)
	
	ON CONFLICT (account, token) DO
	
	UPDATE
	set quantity = positions.quantity + New.quantity,
	avg_cost_buy = ((positions.avg_cost_buy*positions.buy_qty)+(New.value_in_usd+tx_fee))/(positions.buy_qty + New.quantity),
	buy_qty = positions.buy_qty + New.quantity,
	value_in_usd = positions.value_in_usd + New.value_in_usd
	where positions.account = to_acc and positions.token = New.token;
	
	
	
	--insert into ledger for new transaction and position inserted
	select id from positions where positions.account = from_acc and positions.token =New.token into pos_id;
	
	INSERT INTO public.ledger(
	account_id, transaction_id, transaction_type, value, "position")
	VALUES (from_acc, New.id, 'Debit', New.value_in_usd, pos_id);
	
	select id from positions where positions.account = to_acc and positions.token = New.token into pos_id;
	
	INSERT INTO public.ledger(
	account_id, transaction_id, transaction_type, value, "position")
	VALUES (to_acc, New.id, 'Credit', New.value_in_usd, pos_id);	
	
  	END IF;
	RETURN NEW;
	
end;
$BODY$;

ALTER FUNCTION public.populate_ledger()
    OWNER TO postgres;
