CREATE TABLE trades (
    trade_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),  -- Reference to the order
    executed_quantity NUMERIC(10,2) CHECK (executed_quantity > 0),  -- Actual number of shares executed
    executed_price_per_share NUMERIC(10, 2),  -- Actual price per share at execution
    order_direction VARCHAR(10),
    fees JSON,  -- JSON field to capture actual fees applied during execution
    equity_currency VARCHAR(3),
    transaction_currency VARCHAR(3),
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);