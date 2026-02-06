use sql_project_p1;

SELECT TOP (1000) [transactions_id]
      ,[sale_date]
      ,[sale_time]
      ,[customer_id]
      ,[gender]
      ,[age]
      ,[category]
      ,[quantiy]
      ,[price_per_unit]
      ,[cogs]
      ,[total_sale]
  FROM [sql_project_p1].[dbo].[retail_table]


  select * from retail_table;

  select count(*) from retail_table;

  select * from retail_table
  where transactions_id is null;

   select * from retail_table
  where 
            transactions_id is null
			or 
			sale_date is null
			or 
			sale_time is null
			or 
			customer_id is null
			or 
			gender is null
			or
			category is null
			or 
			quantiy is null
			or 
			price_per_unit is null
			or 
			cogs is null
			or 
			total_sale is null;

-----DATA CLEANING----

Delete  from retail_table
  where 
            transactions_id is null
			or 
			sale_date is null
			or 
			sale_time is null
			or 
			customer_id is null
			or 
			gender is null
			or
			category is null
			or 
			quantiy is null
			or 
			price_per_unit is null
			or 
			cogs is null
			or 
			total_sale is null;


----DATA EXPLORATION---

--How many sales we have?---
select count(*) as total_sales  from retail_table;

----how many unique customer we have?---
select count (distinct customer_id) from retail_table;

---How many unique category we have?---
select distinct category from retail_table;

----Data Analysis &Business problem---

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


 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

 select * from retail_table
 where sale_date='2022-11-05';

 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

 select * from retail_table 
 where category='clothing'
 and quantiy>=4
 and   sale_date BETWEEN '2022-11-01' AND '2022-11-30';


 -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
 select category,sum(total_sale)  sum_for_category
 from
 retail_table
 group by category;
 
 -- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
 select avg(age)
 from(select * from retail_table where 
      category='Beauty') as t;


SELECT AVG(age) AS avg_customer_age
FROM retail_table
WHERE category = 'Beauty';

--- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_table
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_table
GROUP BY category, gender
order by 1;

---- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year--

SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    AVG(total_sale) AS avg_monthly_sale
FROM retail_table
GROUP BY YEAR(sale_date), MONTH(sale_date);

WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total_sale) AS total_monthly_sale
    FROM retail_table
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    year,
    month,
    total_monthly_sale
FROM (
    SELECT 
        year,
        month,
        total_monthly_sale,
        RANK() OVER (PARTITION BY year ORDER BY total_monthly_sale DESC) AS rnk
    FROM monthly_sales
) t
WHERE rnk = 1;


SELECT * FROM
	   (SELECT 
		DATEPART(YEAR, sale_date) AS sale_year,
		DATEPART(MONTH, sale_date) AS sale_month,
		CAST(AVG(total_sale) AS INT) AS avg_sale,
		RANK() OVER (
			PARTITION BY DATEPART(YEAR, sale_date)
			ORDER BY AVG(total_sale) DESC
		) AS rnk
	FROM retail_table
	GROUP BY 
		DATEPART(YEAR, sale_date),
		DATEPART(MONTH, sale_date)
	) as t1
where rnk=1
	
	
	--ORDER BY sale_year,
		---avg_sale 
		---DESC;
	
------- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_table
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select distinct count(customer_id) as cnt_unique_cs,
category
from retail_table 
group by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH HOURLY_SALE
AS
(
SELECT *,
       CASE
           WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
           WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS shift
FROM retail_table

)
SELECT SHIFT,COUNT(*) AS TOTAL_ORDERS
FROM HOURLY_SALE
GROUP BY SHIFT;
      
	  
----END OF PROJECT---