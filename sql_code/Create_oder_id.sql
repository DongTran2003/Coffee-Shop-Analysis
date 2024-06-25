-- Step 1: Create the new table
CREATE TABLE basket (
	transaction_id INT,
    order_id INT,
    transaction_date DATE,
    transaction_time TIME,
	transaction_qty INT,
	product_id INT
);

-- Step 2: Insert data into the new table with dense rank
INSERT INTO basket (transaction_id, order_id, transaction_date, transaction_time, transaction_qty, product_id)
SELECT 
    transaction_id,
	DENSE_RANK() OVER (ORDER BY transaction_date, transaction_time) AS order_id,
    transaction_date,
    transaction_time,
	transaction_qty,
	product_id
FROM transactions;