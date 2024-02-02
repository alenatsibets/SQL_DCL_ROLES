1. 
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';
ALTER USER rentaluser WITH LOGIN;
REVOKE ALL PRIVILEGES ON DATABASE dvdrental FROM rentaluser;
GRANT CONNECT ON DATABASE dvdrental TO rentaluser;

2.
GRANT SELECT ON TABLE customer TO rentaluser;

SET ROLE rentaluser;
SELECT * FROM customer;
RESET ROLE;

3.
CREATE GROUP rental;
GRANT rental TO rentaluser;

4. 
GRANT INSERT, UPDATE, SELECT ON TABLE rental TO rental;
GRANT USAGE, SELECT ON SEQUENCE rental_rental_id_seq TO rental;

SET ROLE rental;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES ('2024-01-30', 1, 1, NULL, 1);

UPDATE rental
SET return_date = '2024-02-15'
WHERE rental_id = 2;

RESET ROLE;

5.
REVOKE INSERT ON TABLE rental FROM rental;

SET ROLE rental;
INSERT INTO public.rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES ('2024-02-01', 1, 2, NULL, 2);
RESET ROLE;

6.
CREATE ROLE client_PATRICIA_JOHNSON;
ALTER ROLE client_PATRICIA_JOHNSON LOGIN PASSWORD 'PATRICIA_JOHNSON_password';
GRANT SELECT ON TABLE customer TO client_PATRICIA_JOHNSON;

GRANT SELECT ON TABLE rental TO client_PATRICIA_JOHNSON;
ALTER TABLE rental ENABLE ROW LEVEL SECURITY;
CREATE POLICY PATRICIA_JOHNSON_rental_policy ON rental
  FOR SELECT
  TO client_PATRICIA_JOHNSON
  USING (customer_id = (SELECT customer_id FROM customer WHERE first_name = 'PATRICIA' AND last_name = 'JOHNSON'));

GRANT SELECT ON TABLE payment TO client_PATRICIA_JOHNSON;
ALTER TABLE payment ENABLE ROW LEVEL SECURITY;
CREATE POLICY PATRICIA_JOHNSON_payment_policy ON payment
	FOR SELECT
	TO client_PATRICIA_JOHNSON
	USING (customer_id = (SELECT customer_id FROM customer WHERE first_name = 'PATRICIA' AND last_name = 'JOHNSON'));
  
SET ROLE client_PATRICIA_JOHNSON;

SELECT * FROM rental;
SELECT * FROM payment;

RESET ROLE;