CREATE VIEW user_portfolios AS
SELECT 
u.user_id, u.username, p.portfolio_id, p.portfolio_name,
p.total_value, p.cash_value, p.reserved_value, p.position_value,
p.base_currency, p.status
FROM users u
JOIN portfolios p
ON u.user_id = p.user_id;