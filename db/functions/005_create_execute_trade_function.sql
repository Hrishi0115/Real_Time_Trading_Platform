-- order is fulfilled? what needs to happen

-- trades ✓
-- transactions ✓
-- portfolios ✓
-- positions ✓
-- orders ✓
-- order_history ✓

-- recommended approach

-- orders: update order status 
-- order_history: record the order event
-- trades: log the trade exectuion
-- positions: update the user's position in the instrument
-- portfolios: adjust the portfolio's cash balance/reserved balance
-- transactions: record the cash flow associated with the trade

-- find out which order 

-- 1. Trade is executed

-- simulated backend here --> order is fulfilled, trade is executed and order_id is returned
-- order_id = 3;

SELECT * FROM trades;
SELECT * FROM transactions;
SELECT * FROM portfolios;
select * from positions;
SELECT * FROM orders;
SELECT * FROM order_history;

BEGIN;
SELECT * FROM orders;
SELECT * FROM execute_trade(3, 10.0,220.9, (SELECT fees FROM orders WHERE order_id = 3)); -- assuming fees did not change from order to trade execution for simplicity

COMMIT;
ROLLBACK;

-- ** This function execute either BUY or SELL trades and not COVER, SHORT - this requires more complex logic, not neccessary for data flow simulation - backend problem

CREATE OR REPLACE FUNCTION execute_trade(i_order_id INT, i_executed_quantity NUMERIC(10,2), i_executed_price_per_share NUMERIC(10,2), i_fees JSONB)
	-- all other inputs except for order_id are determined at time of trade execution, therefore, must be inputs for a trade execution
	RETURNS VOID
AS $$
	DECLARE
		-- reorder these correctly
		v_user_id INT;
		v_portfolio_id INT;
		v_order_direction VARCHAR(10);
		v_equity_currency VARCHAR(3);
		v_transaction_currency VARCHAR(3);
		v_trade_id INT;
		v_amount NUMERIC(10,2);
		v_total_fees NUMERIC(10,2);
		fee_type TEXT;
		fee_val NUMERIC;
		v_reserved_amount NUMERIC; -- find out if I should specify NUMERIC(X,Y)
		v_over_reserved_amount NUMERIC;
		v_instrument_id INT;
		v_existing_quantity NUMERIC;
		v_new_quantity NUMERIC;
		v_ordered_quantity NUMERIC;
		v_new_status VARCHAR(20);

	BEGIN
		SELECT user_id, portfolio_id, instrument_id, order_direction, quantity, equity_currency, transaction_currency
		INTO v_user_id, v_portfolio_id, v_instrument_id, v_order_direction, v_ordered_quantity, v_equity_currency, v_transaction_currency
		FROM orders
		WHERE order_id = i_order_id;

		IF i_fees IS NULL THEN v_amount := (i_executed_quantity * i_executed_price_per_share);
		ELSE
			v_total_fees := 0;
			FOR fee_type, fee_val IN 
				SELECT key, value::NUMERIC(10,2)
				FROM jsonb_each(i_fees)
			LOOP
				v_total_fees := v_total_fees + fee_val;
			END LOOP;
			v_amount := (i_executed_quantity * i_executed_price_per_share) + v_total_fees;
		END IF;

	RAISE NOTICE 'v_amount: %', v_amount;

-- if v_amount > reserved_amount, (VERY UNLIKELY, unless a huge price slip occurs (MARKET) / fee increase (LIMIT)) then DO NOT execute trade
	-- very simple logic, in production backend implement PARTIAL FILLS
	-- important to prevent spending CASH which user does not have
	-- in the case that multiple orders have access to the same reserved_value, the order which executes first is filled - though not ideal,
	-- logic is complete
	IF v_amount > (SELECT reserved_value FROM portfolios WHERE portfolio_id = v_portfolio_id) THEN
		RAISE NOTICE 'Insufficient funds';
		RETURN;
	END IF;
	-- ** I think this logic will be handled more in the backend? -- check docummentation on this *.md

-- trades table
INSERT INTO trades (order_id, portfolio_id, executed_quantity, executed_price_per_share, order_direction, fees, equity_currency, transaction_currency)
	VALUES 
	(
		i_order_id,
		v_portfolio_id,
		i_executed_quantity,
		i_executed_price_per_share,
		V_order_direction,
		i_fees,
		v_equity_currency,
		v_transaction_currency
	) RETURNING trade_id INTO v_trade_id;

	-- transactions table
	INSERT INTO transactions (user_id, portfolio_id, trade_id, transaction_type, amount, currency, direction)
		VALUES (
		v_user_id,
		v_portfolio_id,
		v_trade_id,
		v_order_direction,
		v_amount,
		v_transaction_currency,
		CASE
			WHEN v_order_direction = 'BUY' THEN 'DECREASE'::direction_enum
			WHEN v_order_direction = 'SELL' THEN 'INCREASE'::direction_enum
			ELSE NULL
		END
		);

	-- portfolios table
	-- v_amount = 2239.0, reserved_amount = 2285.02, v_over_reserved_amount = 2285.02 - 2239 = 46.02
	-- amount reserved for this specific order

-- again this is the case when order is BUY

	v_reserved_amount := (SELECT * FROM get_reserved_amount(i_order_id));
	v_over_reserved_amount := v_reserved_amount - v_amount;

	UPDATE portfolios
		SET
		reserved_value = reserved_value - v_reserved_amount, -- removes reserved amount for this trade
		cash_value = cash_value + v_over_reserved_amount
		WHERE portfolio_id = v_portfolio_id;

	-- positions table
-- check if the position already exists
SELECT quantity INTO v_existing_quantity
	FROM positions
	WHERE portfolio_id = v_portfolio_id AND instrument_id = v_instrument_id
	FOR UPDATE;
	
	-- in PL/pgSQL, FOUND is a Boolean variable that is set automatically after SELECT INTO, INSERT, UPDATE or DELETE
	-- if the position exists, update it
	IF FOUND THEN
		-- Logic for BUY or SELL
		IF v_order_direction = 'BUY' THEN
		-- Update quantity for BUY
		v_new_quantity := v_existing_quantity + i_executed_quantity;
		UPDATE positions
			SET
			quantity = v_new_quantity,
			average_price = ((average_price * v_existing_quantity) + (i_executed_price * i_executed_quantity)) / v_new_quantity,
			updated_at = CURRENT_TIMESTAMP
			WHERE portfolio_id = v_portfolio_id AND instrument_id = v_instrument_id;

		ELSEIF v_order_direction = 'SELL' THEN -- ** handle condition where v_order_direction = 'SHORT', 'COVER', implement their logic in future
			IF v_existing_quantity >= i_executed_quantity THEN
			v_new_quantity := v_existing_quantity - i_executed_quantity;
			UPDATE positions
				SET
				quantity = v_new_quantity,
				updated_at = CURRENT_TIMESTAMP
				-- selling doesn't affect average_price
				WHERE portfolio_id = v_portfolio_id AND instrument_id = v_instrument_id;
			ELSE
				RAISE EXCEPTION 'NOT ENOUGH SHARES TO SELL IN PORTFOLIO_ID % FOR INSTRUMENT ID %', v_portfolio_id, v_instrument_id;
			END IF;
		END IF;
	ELSE
		-- case where portfolio does not hold instrument
		IF v_order_direction = 'BUY' THEN
		INSERT INTO positions (portfolio_id, instrument_id, quantity, average_price)
		VALUES (v_portfolio_id, v_instrument_id, i_executed_quantity, i_executed_price_per_share);
		ELSEIF v_order_direction = 'SELL' THEN
			RAISE EXCEPTION 'CANNOT SELL SHARES OF INSTRUMENT_ID % THAT DO NOT EXIST IN PORTFOLIO_ID %', v_instrument_id, v_portfolio_id;
		END IF;
	END IF;

-- orders table
-- change status to FILLED, PARTIALLY_FILLED, update quantity_filled, settled_at, 
-- what defines FILLED, PARTIALLY_FILLED for both BUY/SELL orders?
-- if all shares that were ordered to be bought/sold (BUY or SELL) were bought/sold (during trade)
-- first check what status should be
IF i_executed_quantity = v_ordered_quantity THEN
	v_new_status = 'FILLED';
ELSEIF i_executed_quantity < v_ordered_quantity THEN
	v_new_status = 'PARTIALLY_FILLED';
END IF;

UPDATE orders
	SET
	status = v_new_status,
	quantity_filled = i_executed_quantity,
	settled_at = CURRENT_TIMESTAMP
	WHERE order_id = i_order_id;

-- order_history table
INSERT INTO order_history (order_id, action, quantity_filled)
	VALUES (i_order_id, v_new_status, i_executed_quantity);

	END;
$$ LANGUAGE plpgsql;


SELECT * FROM positions;

ALTER TABLE positions
	ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

SELECT * FROM transactions;
SELECT * FROM orders;
SELECT * FROM trades;
SELECT * FROM positions;

SELECT * FROM portfolios;
SELECT * FROM order_history;

SELECT * FROM get_reserved_amount(3);




















