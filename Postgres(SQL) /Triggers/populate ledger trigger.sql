

-- CREATE TRIGGER populate_ledger_trigger
-- AFTER UPDATE ON transactions
-- FOR EACH ROW
-- WHEN (OLD.value_in_usd IS DISTINCT FROM NEW.value_in_usd
--    OR OLD.quantity IS DISTINCT FROM NEW.quantity) 
-- EXECUTE PROCEDURE populate_ledger();












