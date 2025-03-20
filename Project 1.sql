-- SOL Retail Sales Analysis - p1
CREATE DATABASE project_1;

USE project_1;

-- Create Table
CREATE TABLE retail_sales (
         transactions_id	INT PRIMARY KEY,
         sale_date	DATE,
         sale_time  TIME,
         customer_id	INT,
         gender	  VARCHAR(10),
         age	INT,
         category	VARCHAR(15),
         quantiy	INT,
         price_per_unit	FLOAT,
         cogs	FLOAT,
         total_sale FLOAT
);

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
     OR
	 sale_time IS NULL
     OR
	 customer_id IS NULL
     OR
	 gender IS NULL
     OR
	 age IS NULL
     OR
	 category IS NULL
     OR
	 quantiy IS NULL
     OR
	 price_per_unit IS NULL
     OR
	 cogs IS NULL
     OR
	 total_sale IS NULL;


DELETE FROM retail_sales
WHERE  
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
     OR
	 sale_time IS NULL
     OR
	 customer_id IS NULL
     OR
	 gender IS NULL
     OR
	 age IS NULL
     OR
	 category IS NULL
     OR
	 quantiy IS NULL
     OR
	 price_per_unit IS NULL
     OR
	 cogs IS NULL
     OR
	 total_sale IS NULL;


-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many unique customes we have?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;

-- How many unique category we have?
SELECT COUNT(DISTINCT category) AS total_sale FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales .
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17).




-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing' 
    AND
    quantiy > 3
	AND
    sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
     category,
     SUM(total_sale) as net_sale,
     COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;    


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE TOTAL_SALE > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,
	   gender,
	   count(*) as total_trans
FROM retail_sales
GROUP BY 
      Category, 
      gender
ORDER BY category ;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
    year,
    month,
    avg_sale
FROM 
(
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS pos
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE pos = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales .   
 
SELECT 
     customer_id,
     SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id  
ORDER BY total_sales DESC  
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT(customer_id)) as cnt_unique_cs
FROM retail_sales
GROUP BY category;
     

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

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
GROUP BY shift;

-- END

