-- 1. User places an order
-- When a user places a new order, we need to:
    -- insert a new entry into the `orders` table
    -- reserve the funds needed for the order in the `portfolios` table

-- scenario parameters (UI scenario/experience)
-- this scenario will assume a US buyer for simplicity sake - next example will be UK buyer

-- instrument symbol: AAPL
-- time: CURRENT_TIMESTAMP
-- market_price (at time of order placement): $225.22
-- username: hrishiUS
-- portfolio: `Main Portfolio` (default)
-- quantity (user specifies wants to purchase 5 shares (buying in quantity and not money))
-- BUY
-- market order

-- what do we need?
-- user_id, portfolio_id

SELECT instrument_id FROM instruments WHERE symbol = 'AAPL';
SELECT * FROM instruments;

-- Part 1: Placing an order

-- 1a: create new order
BEGIN; 
INSERT INTO orders (user_id, portfolio_id, instrument_id, order_direction, order_type, quantity,
	price, equity_currency, transaction_currency, status)
VALUES
	(
		(SELECT user_id FROM getIds('hrishiUS',S 'Main Portfolio')),
		(SELECT portfolio_id FROM getIds('hrishiUS', 'Main Portfolio')),
		(SELECT instrument_id FROM instruments WHERE symbol = 'AAPL'),
		'BUY',
		'MARKET',
		5.0,
		225.22,
		'USD', -- same as below but with the instrument's currency in the `instruments` table
		'USD', -- enquire to whether transacting currency is required (since it has to be the same as the portfolio's base_currency)
		-- added unneccessary data redudancy for no reason (or valid because for better querying)
		'PENDING'
	)
COMMIT;
ROLLBACK;

SELECT * FROM orders;
-- no fees (US individual buying a US stock) or order_metadata (simple market buy order)
-- TODO: research how country purchases work?	

-- what data is affected after an order is placed
-- `trades` table is only changed AFTER an order is executed

-- `portfolios` - reserve neccesary funds 

-- 1b: Reserve funds in the portfolio (for all types of orders including `MARKET` orders)
	

	
SELECT * FROM users;
SELECT * FROM portfolios;
SELECT * FROM instruments;
SELECT * FROM user_portfolios;
SELECT * FROM transactions;

SELECT * FROM orders;

SELECT table_schema, table_name FROM information_schema.views WHERE table_schema = 'public';

