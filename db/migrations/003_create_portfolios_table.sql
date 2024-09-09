-- represents each user's portfolio holistically
-- each row corresponds to a single portfolio tied to a user
-- includes aggregated and summary information
-- application automatically assigns a default portfolio to new users upon account creation with a default
-- name, for example "Main Portfolio"

-- benefits of this approach (having portfolios and positions as separate tables)
-- users can manage their investments in one or multiple portfolios (users can create different portfolios
-- for different use cases, long-term investing, day trading)
-- holistic view: portfolios provides an aggregated view, making it easier to display summary information
-- like total portfolio value, asset allocation, etc.
-- detailed tracking: positions allows for granular tracking of individual holdings, facilitating 
-- detailed analytics and performance management

CREATE TABLE portfolios (
    portfolio_id SERIAL PRIMARY KEY, -- unique identifier for each portfolio
    user_id INT NOT NULL REFERENCES users(user_id), -- foreign key linking to the user who owns the portfolio
    portfolio_name VARCHAR(100) NOT NULL, -- name of portfolio (e.g., long term, day trading)
    cash_value NUMERIC(15,2) DEFAULT 0, -- current cash balance in the portfolio
    reserved_value NUMERIC(15,2) DEFAULT 0, -- cash reserved for pending orders
    base_currency VARCHAR(3) NOT NULL, -- Currency in which the portfolio is denominated (e.g., 'USD', 'GBP') 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- timestamp when the portfolio was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- timestamp when the portfolio was last updated
    status VARCHAR(20) DEFAULT 'active', -- status of the portfolio; active, inactive
    risk_profile VARCHAR(20) NULL, -- optional risk profile (e.g., conservative, aggressive)
    description TEXT NULL -- optional description or notes about the portfolio
);

