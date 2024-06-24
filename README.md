# Introduction

This **SQL** and **Tableau** project analyzes and gives insights about sales trends and patterns over time for a fictitious coffee shop called Maven Roasters, which is operated out of three NYC locations. The project is believed to help the owner in decision-making with its in-depth analysis and recommendations.

# About the data

The dataset under scrutiny comprises over 148,000 records (after data cleaning process) spanning from the first 6 months of 2023. 

With the application of **SQL** and **Tableau**, insights from the dataset will help identify the following three questions:

- Which category and store location offered the largest source of revenue?
- How have Maven Roasters sales trended over time (revenue per days of the week, time of the day, etc.)?
- How often did customers purchase certain products together?

The SQL queries addressing the problem: [click here](sql_code)

The dataset hails from Kaggle:  [Coffee Shop Sales](https://www.kaggle.com/datasets/ahmedabbas757/coffee-sales/data)

Link to Tableau public for visualizations: 

# Tools and techniques

In order to fully explore the sales trend for the coffee shop, I utilised the following important tools and techniques:

- **SQL**: for querying, cleaning, transforming, and analyzing of sales data.
- **Tableau**: for visualizations of findings and insights.
- **Market Basket Analysis**: a data mining technique that analyzes patterns of co-occurrence, helping the retailers know about the products frequently bought together (Kaur & Kang, 2016). The technique will be applied both in Tableau and SQL.
- **PostgreSQL**: database management system.

# Data exploration

Data cleaning is an important step prior to analysis. This section identifies any duplicates and null values in the dataset.

First, let's identify duplicates using ROW_NUMBER() function in combination with a PARTITION BY clause for all columns:

```sql
WITH duplicate AS
	(
	SELECT *,
		ROW_NUMBER() OVER(
            PARTITION BY 
            transaction_date, 
            transaction_time, 
            transaction_qty, 
            store_id, 
            store_location, 
            product_id, 
            unit_price, 
            product_category, 
            product_type, 
            product_detail) AS row_num
	FROM transactions
	)
SELECT * FROM duplicate
WHERE row_num > 1;
```
The *WHERE* clause identifies records that are repeated more than twice, which are duplicates in this context. 

Once we have a table of duplicates, we just need to delete all of them in our dataset (refer to: *[duplicate_handling.sql](sql_code\Duplicate_handling.sql)*).

Once we have removed all duplicates, it's now time to check for *NULL* values. Following the query in *[Null_handling.sql](sql_code\Null_handling.sql)*, the result does not contain any null or missing values.

# Findings

### 1. Which category and store location offered the largest source of revenue?

<img src="Assets/Revenue-per-category.png" >

*Treemap chart: revenue per category*

Looking at the chart above, **Coffee** appeared to be the largest* source of revenue for the shop, with $269,591 in sales, followed by **Tea** and **Bakery**. **Packed Chocolate**, on the other hand, was the smallest category, with only $4,408 in revenue.

Overall, the performance of the 3 stores was fairly consistent, with each store contributed around 33% of the total revenue for the cafe. Hell's Kitchen (store 8) stood out compared to others with $236,029 in sales (33.85% of total).

<img src="Assets/Revenue-per-store.png" width="550" >


### 2. How have Maven Roasters sales trended over time?

To answer the question, let's first look at the store's revenue at each month:

<img src="Assets/Revenue-per-month.png" width="550" >

The revenue tended to increase over time, except for Feb, which might partly due to a lack of 3 days compared to Jan (as Feb 2023 had only 28 days, while Jan had 31 days).

Next, I dived in to identify which weekdays had the highest in sales using a line chart:

<img src="Assets/Revenue-per-weekday.png" width="550" >

Looking at the chart, it is worth noticing that sales in Mondays and Fridays were the highest, while that figures of Saturdays and Sundays totally adversed. This might indicate that high sales days are usually the start and end of work days (Mon and Fri), while low sales days are the weekends.  

It's also important for the shop's manager to know which time of the day usually had the highest in sales, also known as peak hours:

<img src="Assets/Revenue-per-time.png" width="350" >

As the shop got busy right at its opening time, which is 6 a.m., it soon reached its peak hour at 10 in the morning, with the total revenue recorded at this time was $88,302. It then formed a ... after a significant downtrend in sales and finally plummeted to the lowest revenue point of the day - 8 p.m. or at closing time.

To have a better view of the analysis, let's look at which product categories were demanded the most during different time points of the day:

<img src="Assets/Revenue-per-time-category.png" width="550" >

From the visualization, **Coffee** was still the leader, with $33,258 in revenue at peak hour (10 a.m.), compared to that of **Tea** - the second highest in revenue, with  $22,950 in sales at the same time of the day. It's interesting to see that the majority of all categories had the same trend in sales when they all reached the highest points in revenue at 10 a.m., except for **Drinking Chocolate** and **Branded** categories.

### 3. How often did customers purchase certain products together?

Now, it's getting more interesting to see which products are most frequently bought together. As mentioned in the ***Tools and Techniques***, a data mining method called 'Market Basket Analysis' will be applied to help us identify the number of times that each pair of different products were purchased together. 

This analysis offers a vast amount of benefits for retailers, or our cafe shop owner in this case study. The insights from this analysis might help understanding customer behaviour, efficiency inventory management, sales and promotions, menu development, and strategic decisions (Kaur & Kang, 2016).

To do this, we first need to identify all the orders from customers for the given period of time. Once all orders are identified with a unique ```order_id```, we can then see what products are purchased in 1 order.

Although the given dataset has a ```transaction_id``` column, it does not indicate the id of each order, but instead the id of each item bought. For instance, 3 different transaction_id(s) were queried in the image below, but they refered to the same transaction date and time. This means the 3 records are actually in the same order with different items purchased. 

<img src="Assets/multiple-transactions-example.png" width="550" >

Therefore, I created a column in the given dataset called ```order_id``` and tried to identify which records belong to which orders and assigned these records with specific order_id. For all the records to be considered in the same order, they must have the same ```transaction_date``` and ```transaction_time```. This can be done with the ```DENSE_RANK() OVER()``` function, order by transaction_date and transaction_time. 

The new table called 'basket' will be used to store of the updated data:

```sql
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
```

