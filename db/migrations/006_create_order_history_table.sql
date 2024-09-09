-- `order_history` table

-- ** UPDATE JSON to JSONB in all tables (check for each specific scenario)

-- What is the difference between `orders` and `order_history` table?

-- 1. `orders` Table (Current State of Each Order)
-- Purpose: The `orders` table stores the CURRENT STATE of each order. It contains one row per order and is updated as the order progresses through its
-- lifecycle (from `CREATED` to `PARTIALLY_FILLED`, `FILLED`, `CANCELED`).
-- Updates: As actions are taken on the order (such as partial fills or cancellations), the relevant fields in the `orders` table are updated to reflect
-- the most recent state of the order.
-- Key Role: The `orders` table provides a current view of each order, which is crucial for things like displaying live data in a trading application,
-- calculating real-time metrics, or determining which orders still need to be executed.

-- On the other hand ...
-- 2. `order_history` Table (Tracking Actions Taken on Orders)
-- Purpose: 
-- the `order_history` table stores a detailed log of every significant action taken on each order, such as when it was created, partially filled, fully filled,
-- or canceled. It acts as an immutable (unchangable) audit trail for order activity.
-- Immutability: the `order_history` table is APPEND-ONLY - new rows are added for every action, but existing rows are never modified. This ensures a complete,
-- reliable record of what happened with each order at every step.
-- Key Role: the `order_history` table allows for detailed historical reporting, auditing, and tracking how orders have evolved over time. It provides context
-- to the actions and decisions made during the lifecycle of an order.

-- useful because:
-- 1. Audit Trail: record of all actions taken on an order (creation, cancellation, partial fills, full fills, etc.) - crucial for both auditing
-- and future analysis

-- 2. Immutable Records: storing historical data prevents accidental changes to past orders, ensuring data integrity

-- 3. Reporting: generate reports based on historical data (e.g., user order activity, order statuses over time)

CREATE TABLE order_history (
	history_id SERIAL PRIMARY KEY,
	order_id INT REFERENCES orders(order_id) NOT NULL,
	action VARCHAR(50) NOT NULL, -- e.g., CREATED, FILLED, PARTIALLY_FILLED, CANCELED
	action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	quantity_filled DECIMAL(10,2) NULL, -- OPTIONAL, for partially filled or filled actions
	additional_info JSONB NULL -- To store any extra details, like reasons for cancellation or fill price
)
	
SELECT * FROM order_history;
SELECT * FROM user_portfolios;
