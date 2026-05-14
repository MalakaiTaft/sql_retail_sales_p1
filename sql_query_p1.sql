-- 1. Database Setup

-- Database Creation: The project starts by creating a database named p1_retail_db.
-- Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
-- 2. Data Exploration & Cleaning

-- Record Count: Determine the total number of records in the dataset.

SELECT COUNT(*) FROM retail_sales;

-- Customer Count: Find out how many unique customers are in the dataset.

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- Category Count: Identify all unique product categories in the dataset.

SELECT DISTINCT category FROM retail_sales;

-- Null Value Check: Check for any null values in the dataset and delete records with missing data.

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
-- 3. Data Analysis & Findings

-- The following SQL queries were developed to answer specific business questions:

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP 
	BY 
	gender,
	category
ORDER BY 1

-- Q.7 Write a SQL query to calculate the average sale for each month(PART 1). Find out best selling month in each year:

-- PART 1

SELECT 
	EXTRACT(YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC

-- ORDER BY 1, 3 DESC

-- PART 2

SELECT
	*
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

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

-- Option 2 From Video

SELECT 
	customer_id,
	SUM(total_sale) as total_sales_per_customer
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Option 2 From ME and Chat GPT
SELECT
	customer_id,
	SUM(total_sale) as total_sales_per_customer,
	RANK() OVER (
		ORDER BY SUM(total_sale) DESC
	) as rank
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales_per_customer DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
	category,
	COUNT(DISTINCT customer_id) as  count_unique_customers
FROM retail_sales
GROUP BY 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

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

-- END OF PROJECT