create table retail_sales 
				(
					transactions_id INT,
					sale_date DATE ,
					sale_time TIME,
					customer_id	INT,
					gender VARCHAR(15),
					age	INT,
					category varchar(15),
					quantity	int,
					price_per_unit FLOAT,
					cogs FLOAT,
					total_sale FLOAT
				)
				
-- DATA CLEANING
SELECT * FROM retail_sales 
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
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is NULL


DELETE FROM retail_sales 
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
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

--DATA EXPLORATION
-- total sales
SELECT COUNT(*) AS TOTAL_SALES FROM RETAIL_SALES

-- total customer
SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS FROM RETAIL_SALES

--total category
SELECT DISTINCT CATEGORY FROM RETAIL_SALES

--DATA ANALYSIS
-- retrieving all columns of sales made on 05-11-2022
select * from retail_sales where sale_date = '05-11-2022'

--retrieving all columns on the basis of multiple conditions
select * from retail_sales
where
	category = 'Clothing' and
	quantity >= 4 and
	sale_date between '2022-11-1' and '2022-11-30' 
group by category

-- retrieving total sales for each category
select 
	category,
	sum(total_sale) as total_sales, 
	count(*) as total_orders
from retail_sales
group  by category

-- retrieving average age of customers who bought item from 'beauty' category

select 
	round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty'


-- retrieving all transaction where total_sales is over 1000
select * from retail_sales
where total_sale > 1000


-- retrieving the sum of transactions made by each gender
select
	category,
	gender,
	count(transactions_id) as total_transactions 
from retail_sales
group by gender , category

-- retrieve average sale by each month and best selling month in each year
select
	year,
	month,
	avg_sale
from 
(
select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	round(avg(total_sale)) as avg_sale,
	rank() over(partition by extract(year from sale_date) order by round(avg(total_sale)) desc)
from retail_sales
group by 1, 2
--order by 1, 2, 3
) as t1
where rank = 1

-- top 5 customers based on highest total sale
select 
	customer_id,
	sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 DESC
limit 5

--unique customers who bought from each category
select
	category,
	count(distinct customer_id) as unq_cust
from retail_sales
group by 1

-- Making shifts (Morning= 6 to 12, Afternoon= 12 to 17, Evening= 17 to 21, Night= 22 to 5)

select *,
	case
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 6 AND 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 17 AND 21 THEN 'Evening'
		ELSE 'Night'
	END AS Shift
FROM retail_sales

-- Seeing which shift has the highest orders
WITH Hourly_sales
AS
(
select *,
	case
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 6 AND 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 17 AND 21 THEN 'Evening'
		ELSE 'Night'
	END AS Shift
FROM retail_sales
)
SELECT 
	Shift,
	Count(*) AS Total_Orders
FROM Hourly_sales
GROUP BY Shift

--END OF PROJECT


