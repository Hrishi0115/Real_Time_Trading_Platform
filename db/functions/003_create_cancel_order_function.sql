-- Cancel order

CREATE OR REPLACE FUNCTION cancel_order(i_order_id INT)
	RETURNS VOID
AS $$
BEGIN
	UPDATE orders
	SET
		status = 'CANCELED' -- American English, better for development, against it morally
	WHERE order_id = i_order_id;

	INSERT INTO order_history (order_id, action)
		VALUES (i_order_id, 'CANCELED');
END;
$$ LANGUAGE plpgsql;


-- PERFORM cancel_order(2); -- only runs inside a PL/pgSQL block - DO $$ BEGIN ... END; $$;

SELECT cancel_order(1);

SELECT * FROM orders;
SELECT * FROM order_history;