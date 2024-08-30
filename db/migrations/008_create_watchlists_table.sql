-- allows users to track their favourite instruments

CREATE TABLE watchlists (
    watchlist_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    watchlist_name VARCHAR(100) NOT NULL, -- name of watchlist, e.g., technology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
)