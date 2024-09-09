CREATE OR REPLACE FUNCTION place_order (
	i_user_id INT,
	i_portfolio_id INT,
	i_instrument_id INT,
	i_order_direction VARCHAR(10),
	i_order_type VARCHAR(20),
	i_quantity NUMERIC(10,2),
	i_price NUMERIC(10,2),
	i_fees JSON DEFAULT NULL,
	i_order_metadata JSON DEFAULT NULL
	)
RETURNS VOID
AS $$
DECLARE
	v_order_id INT; -- variable to store the returned order_id
BEGIN
	-- create order in the `orders` table
	INSERT INTO orders (user_id, portfolio_id, instrument_id, order_direction, order_type, quantity,
		price, equity_currency, transaction_currency, status, fees, order_metadata)
	VALUES
	(
		i_user_id,
		i_portfolio_id,
		i_instrument_id,
		i_order_direction,
		i_order_type,
		i_quantity,
		i_price,
		(SELECT currency FROM instruments WHERE instrument_id = i_instrument_id),
		(SELECT base_currency FROM portfolios WHERE portfolio_id = i_portfolio_id),
		'PENDING',
		i_fees,
		i_order_metadata
	)
	RETURNING order_id INTO v_order_id; -- capture the order_id

	-- create `ORDER CREATED` entry in `order_history`
	INSERT INTO order_history (order_id, action)
		VALUES (v_order_id, 'CREATED');
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM instruments;
-- SELECT * FROM users;
-- SELECT * FROM portfolios;

-- SELECT * FROM place_order(
-- 	(SELECT user_id FROM getIds('hrishiUS','Main Portfolio')),
-- 		(SELECT portfolio_id FROM getIds('hrishiUS', 'Main Portfolio')),
-- 		(SELECT instrument_id FROM instruments WHERE symbol = 'AAPL'),
-- 		'BUY',
-- 		'MARKET',
-- 		5.0,
-- 		220.14
-- );

-- SELECT * FROM orders;
-- SELECT * FROM order_history;