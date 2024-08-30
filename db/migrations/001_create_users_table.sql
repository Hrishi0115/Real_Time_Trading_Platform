-- Entity: User
-- Purpose: Stores user information and credentials
-- Table Name: `users`
-- Attributes: user_id, username, ...

CREATE TABLE users (
	user_id SERIAL PRIMARY KEY, -- unique identifier for each user
	-- SERIAL keyword is used to create an auto-incrementing integer column
	username VARCHAR(50) NOT NULL UNIQUE, -- user's display name
	password_hash VARCHAR(255) NOT NULL, -- encrypted password for authentication
	email VARCHAR(100) NOT NULL UNIQUE, -- user's email address
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- timestamp when the user account was created
	-- setting default value for `created_at` to the current date and time whenever a new row is inserted
	last_login TIMESTAMP, -- timestamp of the user's last login
	role VARCHAR(20) NOT NULL -- user role (e.g., trader, admin)
);



