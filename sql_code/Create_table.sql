CREATE TABLE coffee_shop_sales (
    transaction_id SERIAL PRIMARY KEY,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INT,
    store_id INT,
    store_location VARCHAR(255),
    product_id INT,
    unit_price NUMERIC(10, 2),
    product_category VARCHAR(255),
    product_type VARCHAR(255),
    product_detail VARCHAR(255)
);