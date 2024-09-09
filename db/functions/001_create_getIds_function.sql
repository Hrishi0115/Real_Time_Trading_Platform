-- create a Composite Type

CREATE TYPE id_record AS (
	user_id INTEGER,
	portfolio_id INTEGER
);

DROP FUNCTION getIds;

CREATE FUNCTION getIds(i_username VARCHAR(50), i_portfolio_name VARCHAR(100))
RETURNS id_record -- returns defined composite type
AS $$
	DECLARE
		var_user_id INTEGER;
		var_portfolio_id INTEGER;
	BEGIN
		SELECT u.user_id, portfolio_id
		INTO var_user_id, var_portfolio_id
		FROM users u INNER JOIN portfolios p ON u.user_id = p.user_id 
		WHERE u.username = i_username AND p.portfolio_name = i_portfolio_name;

		RETURN (var_user_id, var_portfolio_id);

	END;
$$ LANGUAGE plpgsql;

SELECT user_id FROM getIds('hrishiUS', 'Main Portfolio');