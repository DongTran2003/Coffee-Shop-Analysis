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

*Coffee* appeared to be the largest source of revenue for the shop, with $269,591 in sales, followed by *Tea* and *Bakery*. *Packed Chocolate*, on the other hand, was the smallest category, with only $4,408 in revenue.

<img src="Assets/Revenue-per-store.png" width="550" >

Overall, the performance of the 3 stores was fairly consistent, with each store contributed around 33% of the total revenue for the cafe. Hell's Kitchen (store 8) stood out compared to others with $236,029 in sales (33.85% of total).

### 2. How have Maven Roasters sales trended over time?

To answer the question, let's first look at the store's revenue at each month:

![Bar chart: revenue per month](Assets/Revenue-per-month.png)

The revenue tended to increase over time, except for Feb, which might partly due to a lack of 3 days compared to Jan (as Feb 2023 had only 28 days, while Jan had 31 days).

Next, I dived in to identify which week days had the highest in sales using a line chart:

![Line chart: revenue per month](Assets/Revenue-per-weekday.png)

Looking at the chart, it is worth noticing that sales in Mondays and Fridays were the highest, while that figures of Saturdays and Sundays totally adversed. This might indicate that high sales days are usually the start and end of work days (Mons and Fri), while low sales days are the weekends.  


