-- -----creating a database-----

CREATE DATABASE IF NOT EXISTS salesdatawalmart;
use salesdatawalmart;

-- --- creating table under the database which contains all the attributes

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    vat float (6,4) not null,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


-- -------------feature engineering --------------------------------------------------------
-- time_of_day ----
select 
	time,
		(case
			when `time` between "00:00:00" and "12:00:00" then "morning"
            when `time` between "12:01:00" and "16:00:00" then "afternoon"
            else "evening"
        end
        ) as time_of_day
from sales;

alter table sales
add  column time_of_day varchar(20);

update sales
set time_of_day = (
case
		when `time` between "00:00:00" and "12:00:00" then "morning"
		when `time` between "12:01:00" and "16:00:00" then "afternoon"
		else "evening"
end);

-- day_name ------
select date,
	dayname(date)
from sales;

alter table sales
add column day_name  varchar (10);

update sales
set day_name = dayname(date);

-- month name ----
select date,
monthname(date)
from sales;

alter table sales
add column month_name varchar(20);

update sales
set month_name = monthname(date);

-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- ---------------------------Generic questions -----------------------------------

-- how many unique cities does the data have 
select distinct city 
from sales ;

-- in which city is each branch

select distinct city, branch 
from sales;

-- ----------------------------- Product questions ---------------------------------
-- How many unique product lines does the data have?
select count(distinct product_line) from sales;

-- what is the most common payment method?
select payment , count(payment) as cnt
from sales 
group by payment
order by cnt desc;

-- what is the most selling product line
select product_line , count(product_line) as cnt
from sales
group by product_line 
order by cnt desc;
-- top 1
select product_line , count(product_line) as cnt
from sales
group by product_line 
order by cnt desc
limit 1;

-- what is the total revenue by month
select month_name , sum(total) as revenue
from sales
group by  month_name
order by revenue desc;

-- what month has the largest cogs?
select month_name as month, sum(cogs) as cogs
from sales
group by month_name 
order by cogs desc;

-- what product line has the largest revenue
select product_line, sum(total) as revenue
from sales
group by product_line
order by revenue desc;

-- city with the largest revenue
select branch, city , sum(total) as revenue
from sales
group by city, branch
order by revenue desc;

-- product line that had the largest VAT
SELECT PRODUCT_LINE , AVG(VAT) AS AVG_TAX
FROM sales
GROUP BY PRODUCT_LINE
ORDER BY AVG_TAX DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;


SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- which branch sold more products than average product sold
select branch, sum(quantity) as qty
from sales
group by branch
having sum(quality) > (select avg(quantity) from sales);

-- what is the most common product line by gender
select gender , product_line, count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- what is the average rating of each product line?
select avg(rating) as rating , product_line
from sales
group by product_line
order by rating desc;

-- --------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------- sales ----------------------------------------------------------------------


-- number of sales made in each time of the day per weekday
select time_of_day , count(*) as totaL_sales
from sales
where day_name = "sunday" -- we can change the day of the week to any day that we want
group by time_of_day
order by total_sales desc;

-- which of the customer type bring the most revenue
select customer_type , sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc;

-- which city has the largest tax percent/ vat ?
select city , avg(vat) as vat
from sales
group by city
order by vat desc;

-- which customer type pays the most vat
select customer_type, avg(vat) as vat
from sales
group by customer_type
order by vat desc;


-- ---------------------------------------------------------------------------------------------------------------------
-- ------------------------- Customer ---------------------------------------------------------------------------------


-- how many unique customer types does the data have
select distinct customer_type
from sales;

-- how many unique payment methods does the data have
select distinct payment
from sales;

-- what is the most common customer type
select count(*) as cnt , customer_type 
from sales
group by customer_type
order by cnt desc;


-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;

-- what is the gender of most of the customers
select gender , count(*) as gen_cnt
from sales
group by gender
order by gen_cnt desc;

-- what is the gender distribution per branch
select gender , count(*) as gen_cnt
from sales
where branch = "a" 
group by gender
order by gen_cnt desc;

select gender , count(*) as gen_cnt
from sales
where branch = "b" 
group by gender
order by gen_cnt desc;

select gender , count(*) as gen_cnt
from sales
where branch = "c" 
group by gender
order by gen_cnt desc;

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- which time of the day do customers give most rating per branch
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
where branch = "a"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- which day of the week has the best avg rating
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP by day_name
ORDER BY avg_rating DESC;


-- which day of the week has the best avg rating per branch
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
where branch = "a"
GROUP by day_name
ORDER BY avg_rating DESC;