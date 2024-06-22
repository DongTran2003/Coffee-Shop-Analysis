SELECT *
FROM transactions
WHERE transaction_date IS NULL
   OR transaction_time IS NULL
   OR transaction_qty IS NULL
   OR store_id IS NULL
   OR store_location IS NULL
   OR product_id IS NULL
   OR unit_price IS NULL
   OR product_category IS NULL
   OR product_type IS NULL
   OR product_detail IS NULL;