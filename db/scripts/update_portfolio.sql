-- decide which approach to take for handling reserved funds calculation

-- current AAPL price = $222.38
-- reserved_amount = quantity * AAPL_price + fees 


-- how to determine reserved_amount?

-- buffer_percentage = 1.01 -- 2% standard to account for major price shifts - in future have this determined per-transaction based 
-- on wider macroeconomic conditions, e.g., market volatility/VIX, liquidity, other typical indicators

-- check order_direction ...
-- check order_type ...

-- scenario 1 (outlined below):
-- IF order_direction = 'BUY' AND order_type = 'MARKET' AND equity_currency = transaction_currency:
-- ...
-- reserved_amount = (market_price * buffer_percentage) -- no fees

-- IF order_direction = 'BUY' AND order_type = 'MARKET' AND equity_currency = transaction_currency:

CREATE OR REPLACE FUNCTION update_portfolio ( -- prototype function for this specific MARKET BUY USD_user, USD_instrument scenario
	i_portfolio_id INT,
	market_price DECIMAL(10,2),
	quantity DECIMAL(10,2),
	buffer_multiplier DECIMAL(8,2) DEFAULT 1.02 -- 2% standard to account for major price shifts - in future have this determined per-transaction based 
	-- on wider macroeconomic conditions, e.g., market volatility/VIX, liquidity, other typical indicators
) 
RETURNS VOID
AS $$
DECLARE
	reserved_amount DECIMAL(10,2);
BEGIN
	reserved_amount := (market_price * buffer_multiplier) * quantity; -- no fees
	RAISE NOTICE 'Reserved Amount: %', reserved_amount;

	UPDATE portfolios
	SET 
	cash_value = cash_value - reserved_amount,
	reserved_value = reserved_value + reserved_amount -- needs to go after reserved_amount
	WHERE portfolio_id = i_portfolio_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM portfolios;

SELECT * FROM orders;

-- CREATE OR REPLACE FUNCTION future_reserve_amount_for_different_orders (
-- 	i_user_id INT,
-- 	i_portfolio_id INT,
-- 	i_instrument_id INT,
-- 	i_order_direction VARCHAR(10),
-- 	i_order_type VARCHAR(20),
-- 	i_quantity NUMERIC(10,2),
-- 	i_price NUMERIC(10,2),
-- 	i_status VARCHAR(20),
-- 	i_fees JSON DEFAULT NULL,
-- 	i_order_metadata JSON DEFAULT NULL
-- 	buffer_multiplier DECIMAL(8,2) DEFAULT 1.02 -- 2% standard to account for major price shifts - in future have this determined per-transaction based 
-- 	-- on wider macroeconomic conditions, e.g., market volatility/VIX, liquidity, other typical indicators
-- 	)
-- RETURNS VOID
-- AS $$
-- DECLARE
-- 	v_reserved_amount NUMERIC(10,2);
-- BEGIN
-- 	IF i_order_direction = 'BUY' AND i_order_type = 'MARKET' THEN
-- 		IF i_fees IS NULL THEN
-- 		-- check i_fees (no need to check i_order_metadata since this is a `MARKET BUY` order)
-- 			reserved_amount := (market_price * buffer_multiplier) * quantity; -- no fees
-- 			RAISE NOTICE 'Reserved Amount: '
-- 	END IF;
-- END;
-- $$ LANGUAGE plpgsql;
	