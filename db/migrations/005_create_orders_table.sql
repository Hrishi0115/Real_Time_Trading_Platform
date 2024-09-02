-- The `orders` table stores information about orders placed by users on the trading platform. It captures user intent (such as buying or selling securities)
-- and specific conditions associated with different order types (e.g., market, limit, stop). This table serves as a record of all active and historical orders
-- initiated by users.

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY, -- unique identifier for each order
    user_id INT REFERENCES users(user_id), -- identifier of the user placing the order; references the `users` table
    portfolio_id INT NOT NULL REFERENCES portfolios(portfolio_id), -- foreign key linking to the portfolio from which funds are reserved
    instrument_id INT REFERENCES instruments(instrument_id), -- identifier of the security being traded; references the 'securities` table
    order_direction VARCHAR(10),  -- direction of the order; Buy, Sell, Short, Cover
    order_type VARCHAR(20),  -- specifies the type of order; Market, Limit, Stop, Stop-Limit, etc.
    quantity NUMERIC(10, 2),  -- Number of shares users intends to buy or sell; for market orders where an amount is specified, this represents 
    -- the estimated maximum quantity based on the current market price
    amount NUMERIC(15, 2),  -- maximum of amount the user is willing to spend; optional
    price NUMERIC(10, 2),  -- estimated or indicative price per share at the time of order placement for market orders, for limit orders equal to the 'limit_price'
    -- in the order_metadata field, still an estimate (different to final price at execution/price in the trades table)
    -- because the actual price the instrument was purchased at can be better, and thus not equal to, the limit price specified
    fees JSON,  -- JSON field to capture any fees associated with the order (UK stamp duty, FX fees, etc.)
    equity_currency VARCHAR(3), -- the currency in which the instrument is denominated
    transaction_currency VARCHAR(3), -- the currency in which the user is transacting
    status VARCHAR(20),  -- Pending, Partially Filled, Filled, Canceled
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- date and time when order was placed, default to current timestamp
    settled_at TIMESTAMP NULL, -- date and time when the order is settled, if applicable
    order_metadata JSON  -- JSON column to store order-specific details like stop prices for stop orders, limit prices for limit orders, etc.
);

