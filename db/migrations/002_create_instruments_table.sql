-- Entity: Instrument
-- Purpose: Stores information about trading instruments
-- Table Name: `instruments`
-- Attributes: instrument_id, ...

CREATE TABLE instruments (
    instrument_id SERIAL PRIMARY KEY,  -- Unique identifier for each trading instrument
    name VARCHAR(100) NOT NULL,  -- Name of the instrument (e.g., Apple Inc., Bitcoin)
    symbol VARCHAR(20) NOT NULL UNIQUE,  -- Trading symbol (e.g., AAPL, BTC/USD)
    type VARCHAR(20) NOT NULL,  -- Type of instrument (e.g., stock, forex, crypto)
    exchange VARCHAR(50) NOT NULL,  -- Exchange or market where the instrument is traded
    currency VARCHAR(3) NOT NULL,  -- Currency in which the instrument is denominated (e.g., USD, EUR, BTC)
    isin VARCHAR(12),  -- International Securities Identification Number, optional
    sector VARCHAR(50) NOT NULL,  -- Sector of the instrument, e.g., Technology, Healthcare
    status VARCHAR(20) DEFAULT 'active',  -- Status of the instrument; 'active', 'inactive'
    description TEXT,  -- Description or notes about the instrument
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp when the instrument was added to the platform
);

