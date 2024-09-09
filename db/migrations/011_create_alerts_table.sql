-- types of alerts in a typical trading platform

CREATE TABLE alerts (
    alert_id SERIAL PRIMARY KEY,  -- Unique identifier for each alert
    user_id INT NOT NULL REFERENCES users(user_id),  -- Foreign key linking to the user who set the alert
    instrument_id INT REFERENCES instruments(instrument_id),  -- Foreign key linking to the instrument for the alert, if applicable
    alert_type VARCHAR(20) NOT NULL,  -- Type of alert (e.g., 'Price', 'Volume', 'Percent Change', 'Moving Average', 'News', 'Earnings')
    condition JSONB NOT NULL,  -- JSONB field to store alert conditions (e.g., { "threshold": 50000, "direction": "Above" })
    status VARCHAR(20) DEFAULT 'active',  -- Status of the alert; 'active', 'triggered', 'inactive'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp when the alert was created
    last_triggered_at TIMESTAMP NULL,  -- Timestamp of when the alert was last triggered
    notification_method VARCHAR(20) DEFAULT 'in-app',  -- Method of notification; 'email', 'SMS', 'in-app'
    message TEXT  -- Custom message or notes about the alert
);