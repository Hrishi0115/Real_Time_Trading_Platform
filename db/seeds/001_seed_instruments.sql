BEGIN;

INSERT INTO instruments (name, symbol, type, exchange, currency, isin, sector, status)
VALUES 
    ('Apple Inc.', 'AAPL', 'stock', 'NASDAQ', 'USD', 'US0378331005', 'Technology', 'active'),
    ('Tesla Inc.', 'TSLA', 'stock', 'NASDAQ', 'USD', 'US88160R1014', 'Automobile', 'active'),
    ('Bitcoin', 'BTC', 'crypto', 'Coinbase', 'USD', NULL, 'Cryptocurrency', 'active'),
    ('Ethereum', 'ETH', 'crypto', 'Coinbase', 'USD', NULL, 'Cryptocurrency', 'active'),
    ('Amazon.com Inc.', 'AMZN', 'stock', 'NASDAQ', 'USD', 'US0231351067', 'E-Commerce', 'active'),
    ('Alphabet Inc. (Google)', 'GOOGL', 'stock', 'NASDAQ', 'USD', 'US02079K3059', 'Technology', 'active');

COMMIT;

-- ROLLBACK;

-- check currency for cryptocurrency - is there not separate instruments like BTC/USD and BTC/GBP - I'm unsure, research

