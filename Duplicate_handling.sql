--Check if there is any duplicate using CTE and ROW_NUMBER OVER() function
WITH duplicate AS
	(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY transaction_date, transaction_time, transaction_qty, store_id, store_location, product_id, unit_price, product_category, product_type, product_detail) row_num
	FROM transactions
	)
SELECT * FROM duplicate
WHERE row_num > 1;

-- Delete all duplicated rows 
WITH duplicate AS
	(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY transaction_date, transaction_time, transaction_qty, store_id, store_location, product_id, unit_price, product_category, product_type, product_detail) row_num
	FROM transactions
	)
DELETE FROM transactions
WHERE transaction_id IN
	(
	SELECT transaction_id
	FROM duplicate
	WHERE row_num > 1
	);
	