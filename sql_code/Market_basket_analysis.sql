-- Count number of times products are buy together
SELECT t1.product_id, t2.product_id, COUNT(*) AS times_bought_together
FROM basket t1
JOIN basket t2 ON t1.order_id = t2.order_id
WHERE t1.product_id <> t2.product_id AND -- Exclude all rows that combine only 1 product as a pair
	t1.product_id < t2.product_id -- a pair of 2 products will be listed in 2 records since order matters. We only need one of them
GROUP BY t1.product_id, t2.product_id
ORDER BY times_bought_together DESC 
LIMIT 10

-- Convert product_id to its corresponding product_detail
WITH pro_type AS 
	(
	SELECT DISTINCT product_id, product_detail FROM transactions ORDER BY product_id DESC
	)
SELECT pt1.product_detail, pt2.product_detail, COUNT(*) AS times_bought_together
FROM basket t1
JOIN basket t2 ON t1.order_id = t2.order_id
JOIN pro_type pt1 ON pt1.product_id = t1.product_id
JOIN pro_type pt2 ON pt2.product_id = t2.product_id
WHERE t1.product_id <> t2.product_id AND 
	t1.product_id < t2.product_id 
GROUP BY t1.product_id, t2.product_id, pt1.product_detail, pt2.product_detail
ORDER BY times_bought_together DESC
LIMIT 10
