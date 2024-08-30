-- the transactions table is useful for keeping track of all financial transactions, such as deposits (interest/dividend payments), withdrawals,
-- and fees. This table can help manage cash flow within each portfolio and provide a detailed audit trail for users and compliance.

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY, -- unique identifier for each transaction
    user_id INT NOT NULL REFERENCES users(user_id), -- foreign key linking to the user performing the transaction
    portfolio_id INT REFERENCES portfolios(portfolio_id), -- foreign key linking to the associated portfolio, optional, for example, management fee would
    -- not be associated with a particular portfolio
    transaction_type VARCHAR(20) NOT NULL, -- type of transaction, e.g., 'deposit', 'withdrawal' 'fee', 'dividend', 'interest'
    amount NUMERIC(15,2) NOT NULL, -- amount of the transaction; positive for deposits, negative for withdrawls
    currency VARCHAR(3) NOT NULL, -- currency in which the transaction is denominated
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- timestamp when the transaction was executed
    description TEXT -- optional description/notes about the transaction
)

