SELECT * FROM positions;

CREATE OR REPLACE FUNCTION update_portfolio(i_order_id INT, i_current_price NUMERIC(10,2))
RETURNS VOID
	AS $$
	DECLARE
		v_portfolio_id INT;
		v_quantity NUMERIC(10,2);
		v_fees JSON;
		v_total_fees NUMERIC(10,2);
		v_reserved_amount NUMERIC(10,2);
		-- v_status VARCHAR(20); -- in future only update portfolio if status = 'PENDING'
		v_buffer_multiplier NUMERIC(5,2) DEFAULT 1.02; -- 2% standard to account for major price shifts - in future have this determined per-transaction based 
		-- on wider macroeconomic conditions, e.g., market volatility/VIX, liquidity, other typical indicators
		fee_type TEXT;
		fee_val NUMERIC;
	BEGIN
		SELECT portfolio_id, quantity, fees
			INTO v_portfolio_id, v_quantity, v_fees
			FROM orders WHERE order_id = i_order_id;

		IF v_fees IS NULL THEN
			v_reserved_amount := (i_current_price * v_buffer_multiplier) * v_quantity; -- no fees - see if we can make this solution simplier
			
		ELSE
			v_total_fees := 0;
			FOR fee_type, fee_val IN
				SELECT * FROM json_each_text(v_fees)
			LOOP
				-- check if fee_val is NUMERIC
				fee_val := fee_val::numeric;
				v_total_fees := v_total_fees + fee_val;
				RAISE NOTICE '%: %', fee_type, fee_val;
			END LOOP;
			v_reserved_amount := (i_current_price * v_buffer_multiplier) * v_quantity + v_total_fees;
		END IF;

		RAISE NOTICE 'Reserved Amount: %', v_reserved_amount;

		UPDATE portfolios
		SET 
		cash_value = cash_value - v_reserved_amount,
		reserved_value = reserved_value + v_reserved_amount -- needs to go after reserved_amount
		WHERE portfolio_id = v_portfolio_id;

		
	END;
	$$ LANGUAGE plpgsql;

-- ** redo portfolios table - remove total and position value - handle this dynamically on the backend, not in database
	
SELECT * FROM orders;
SELECT * FROM portfolios;
SELECT * FROM order_history;
SELECT * FROM positions;

BEGIN;

SELECT * FROM update_portfolio(3, 221.08); -- should the price just be the price at time of order (for MARKET) and limit_order for LIMIT orders

SELECT * FROM portfolios;

SELECT * FROM orders;

ROLLBACK;

SELECT fees FROM orders where order_id = 2;

SELECT portfolio_id, quantity, fees
	FROM orders WHERE order_id = 3;

SELECT * FROM user_portfolios; 

