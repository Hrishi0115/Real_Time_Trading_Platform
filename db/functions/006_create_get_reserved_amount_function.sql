SELECT * FROM orders;

CREATE OR REPLACE FUNCTION get_reserved_amount(i_order_id INT)
	RETURNS NUMERIC(10,2) AS $$
		DECLARE v_reserved_amount NUMERIC;
		v_fees JSONB;
		v_total_fees NUMERIC;
		fee_type TEXT;
		fee_val NUMERIC;
		v_price NUMERIC;
		v_quantity NUMERIC;
		v_buffer_multiplier NUMERIC DEFAULT 1.02;
	
		BEGIN
		SELECT price, quantity, fees
			INTO v_price, v_quantity, v_fees
			FROM orders WHERE order_id = i_order_id;
			
		IF v_fees IS NULL THEN
			v_reserved_amount := (v_price * v_buffer_multiplier) * v_quantity; -- no fees - see if we can make this solution simplier
			
		ELSE
			v_total_fees := 0;
			FOR fee_type, fee_val IN
				SELECT key, value::NUMERIC FROM jsonb_each(v_fees)
			LOOP
				v_total_fees := v_total_fees + fee_val;
				RAISE NOTICE '%: %', fee_type, fee_val;
			END LOOP;
			v_reserved_amount := (v_price * v_buffer_multiplier) * v_quantity + v_total_fees;
		END IF;
	RETURN v_reserved_amount;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_reserved_amount(3);














