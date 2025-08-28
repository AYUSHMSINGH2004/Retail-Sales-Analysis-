-- SQL Retail Sales Analysis 
CREATE DATABASE Retail_Sales_Analysis ;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transaction_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
--

DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales



SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Q.11 Find the category with the highest average price per unit.
-- Q.12 What is the most common age of a customer?
-- Q.13 Calculate the profit margin for each transaction. Profit = total_sale - cogs
-- Q.14 Find the total number of male and female customers.
-- Q.15 What is the average quantity of items sold per transaction?
-- Q.16 Identify the top 3 best-selling products (categories) by quantity sold.
-- Q.17 Find the month with the highest total sales for 'Electronics'.
-- Q.18 Calculate the total sales for each year.
-- Q.19 What is the average profit margin for each category?
-- Q.20 Find all transactions that occurred on a weekend (Saturday or Sunday).
-- Q.21 What is the most common time for sales?
-- Q.22 Find the customer with the most number of unique categories purchased.
-- Q.23 Identify the product with the highest profit.
-- Q.24 What is the average price per unit for each gender and category?
-- Q.25 Find the total number of transactions in 2023.



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'
    AND
    quantity >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- ORDER BY 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- Q.11 Find the category with the highest average price per unit.

SELECT category, AVG(price_per_unit) AS avg_price
FROM retail_sales
GROUP BY category
ORDER BY avg_price DESC
LIMIT 1;

-- Q.12 What is the most common age of a customer?

SELECT age, COUNT(*) AS age_count
FROM retail_sales
GROUP BY age
ORDER BY age_count DESC
LIMIT 1;

-- Q.13 Calculate the profit margin for each transaction. Profit = total_sale - cogs

SELECT
    transaction_id,
    total_sale,
    cogs,
    (total_sale - cogs) AS profit,
    ((total_sale - cogs) / total_sale) * 100 AS profit_margin
FROM retail_sales;

-- Q.14 Find the total number of male and female customers.

SELECT gender, COUNT(DISTINCT customer_id) AS unique_customer_count
FROM retail_sales
GROUP BY gender;

-- Q.15 What is the average quantity of items sold per transaction?

SELECT AVG(quantiy) AS average_quantity_sold
FROM retail_sales;

-- Q.16 Identify the top 3 best-selling products (categories) by quantity sold.

SELECT category, SUM(quantiy) AS total_quantity_sold
FROM retail_sales
GROUP BY category
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Q.17 Find the month with the highest total sales for 'Electronics'.

SELECT TO_CHAR(sale_date, 'YYYY-MM') AS sale_month, SUM(total_sale) AS total_sales
FROM retail_sales
WHERE category = 'Electronics'
GROUP BY sale_month
ORDER BY total_sales DESC
LIMIT 1;

-- Q.18 Calculate the total sales for each year.

SELECT EXTRACT(YEAR FROM sale_date) AS sale_year, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY sale_year
ORDER BY sale_year;

-- Q.19 What is the average profit margin for each category?

SELECT
    category,
    AVG(((total_sale - cogs) / total_sale) * 100) AS avg_profit_margin
FROM retail_sales
GROUP BY category;

-- Q.20 Find all transactions that occurred on a weekend (Saturday or Sunday).

SELECT *
FROM retail_sales
WHERE EXTRACT(DOW FROM sale_date) IN (0, 6);

-- Q.21 What is the most common time for sales?

SELECT EXTRACT(HOUR FROM sale_time) AS sale_hour, COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY sale_hour
ORDER BY transaction_count DESC
LIMIT 1;

-- Q.22 Find the customer with the most number of unique categories purchased.

SELECT customer_id, COUNT(DISTINCT category) AS unique_categories
FROM retail_sales
GROUP BY customer_id
ORDER BY unique_categories DESC
LIMIT 1;

-- Q.23 Identify the product with the highest profit.

SELECT transactions_id, category, (total_sale - cogs) AS profit
FROM retail_sales
ORDER BY profit DESC
LIMIT 1;

-- Q.24 What is the average price per unit for each gender and category?

SELECT gender, category, AVG(price_per_unit) AS avg_price_per_unit
FROM retail_sales
GROUP BY gender, category
ORDER BY gender, category;

-- Q.25 Find the total number of transactions in 2023.

SELECT COUNT(*) AS total_transactions_2023
FROM retail_sales
WHERE EXTRACT(YEAR FROM sale_date) = 2023;



-- End of project

