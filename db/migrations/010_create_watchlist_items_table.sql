CREATE TABLE watchlist_items (
    item_id SERIAL PRIMARY KEY,
    watchlist_id INT NOT NULL REFERENCES watchlists(watchlist_id),
    instrument_id INT NOT NULL REFERENCES instruments(instrument_id),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

