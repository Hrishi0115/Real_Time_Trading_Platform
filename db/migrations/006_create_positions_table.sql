-- tracks individual positions within each portfolio
-- each row represents a specific holding of an instrument within a particular portfolio
-- contains details such as the number of shares/units held, average price paid, relevant timestamps

CREATE TABLE positions (
    position_id SERIAL PRIMARY KEY, -- unique identifier for each position
    portfolio_id INT NOT NULL REFERENCES portfolio(portfolio_id), -- foreign key linking to the portfolio
    instrument_id INT NOT NULL REFERENCES instruments(instrument_id), -- foreign key linking to the instrument being held
    quantity NUMERIC(15, 6) NOT NULL, -- number of shares/units held; positive for long positions and negative for short positions
    average_price NUMERIC(15, 6) NOT NULL CHECK (average_price > 0), -- average price paid per unit; must be greater than 0
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- timestamp when the position entry was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- timestamp when the position entry was last updated
)