create database walmartsales;

use walmartsales;

create table walsales( 
invoice_id varchar(30) not null primary key, 
branch varchar(5) not null, 
city varchar(30) not null ,
 customer_type varchar (30) not null,
 gender varchar (10) not null,
 product_line varchar (100) not null,
 unit_price decimal(10, 2) not null, 
 quantity int not null,
 VAT float (6, 4) not null, 
 total decimal (12, 4)not null, 
 date date not null,
 time time not null, 
payment_method varchar (15) not null, 
cogs decimal (10, 2) not null,
 gross_margin_percentage float(11, 9),
 gross_income  decimal (10, 2) not null, 
 rating float (2, 1)  
 );

select*from walsales;

-- Feature Engineering--


-- adding time_of_day--

alter table walsales add column time_of_day varchar(15);

select time
(case 
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "evening"
end
) as time_of_day
from walsales;

set sql_safe_updates=0;

update walsales 
set time_of_day = ( 
case
 when time between "00:00:00" and "12:00:00" then "Morning"
 when time between "12:01:00" and "16:00:00" then "Afternoon"
else "evening"
end
);

update walsales 
set time_of_day = "Evening"
where time_of_day = "evening";

-- adding day_name --


alter table walsales 
add column day_name varchar(10);

select 
date, dayname(date)
from walsales;

update walsales
set day_name = dayname(date);

-- month_name --


alter table walsales
add column month_name varchar(10);

select 
date, monthname(date)
from walsales;

update walsales 
set month_name = monthname(date);

-- generic -- 
-- How many unique cities does the data have?

select distinct city from walsales;

-- In which city is each branch?

select distinct city, branch from walsales;

-- --------------------------------------------------------------------- product ----------------------------------------------------------------------
-- How many unique product lines does the data have?

select count(distinct product_line)
 from walsales;

-- What is the most common payment method?

select payment_method, count(payment_method)as count
from walsales
group by payment_method 
order by count desc
;

-- What is the most selling product line?

select product_line,count( product_line) as prdcount
from walsales
group by product_line 
order by prdcount desc;

-- What is the total revenue by month?
select 
month_name,
sum(total) as total_rev
from walsales
group by month_name 
order by total_rev desc;



-- What month had the largest COGS?

select month_name,
sum(cogs) as cogs
from walsales
group by month_name;

-- What product line had the largest revenue?

select product_line,
sum(total) as total_rev
from walsales
group by product_line
order by total_rev desc;

-- What is the city with the largest revenue?

select city, branch,
sum(total) as total_rev
from walsales
group by city, branch
order by total_rev desc;

-- What product line had the largest VAT?

select product_line, 
avg(vat) as avg_tax
from walsales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
    product_line,
    CASE 
        WHEN sales > avg_sales THEN 'Good'
        ELSE 'Bad'
    END AS sales_quality
FROM (
    SELECT 
        product_line,
        SUM(Quantity) AS sales,
        (SELECT AVG(SUM(Quantity)) FROM walsales GROUP BY product_line) AS avg_sales
    FROM 
        walsales
    GROUP BY 
        product_line
) AS sales_data;

-- Which branch sold more products than average product sold?

select avg(quantity) 
from walsales;

select branch, sum(quantity) as avg_quant
from walsales
group by branch
having sum(quantity) > (select avg(quantity) from walsales);

-- What is the most common product line by gender?

select gender, product_line,
count(gender) as total_gen
from walsales
group by gender, product_line
order by total_gen desc;

-- What is the average rating of each product line?

select
round( avg (rating), 2)  as avg_rating,
 product_line
 from walsales
 group by product_line 
 order by avg_rating desc;
 
  -- --------------------------------------------------------------- sales ------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday

select
 time_of_day,
count(*) as total_sales 
from walsales
where day_name = "monday"
group by time_of_day
order by total_sales desc;

select
 time_of_day,
count(*) as total_sales 
from walsales
where day_name = "tuesday"
group by time_of_day
order by total_sales desc;

select
 time_of_day,
count(*) as total_sales 
from walsales
where day_name = "wednesday"
group by time_of_day
order by total_sales desc;

select
 time_of_day,
count(*) as total_sales 
from walsales
where day_name = "thursday"
group by time_of_day
order by total_sales desc;

select
 time_of_day,
count(*) as total_sales 
from walsales
where day_name = "friday"
group by time_of_day
order by total_sales desc;

-- Which of the customer types brings the most revenue?

select
customer_type,
sum(total) as total_rev
from walsales
group by customer_type 
order by total_rev desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select 
city, avg(vat) as avg_vat
from walsales
group by city 
order by avg_vat desc;

-- Which customer type pays the most in VAT?

select customer_type,
avg(vat) as vat_type
from walsales
group by customer_type
order by vat_type desc;

-- ------------------------------------------------------------------------------------------ customer------------------------------------------------

-- How many unique customer types does the data have?

select distinct
customer_type
from walsales;

-- How many unique payment methods does the data have?

select distinct 
Payment_method
from walsales;

-- What is the most common customer type?

select customer_type,
 count(customer_type) as cust_type
from walsales
group by customer_type
order by cust_type desc;

-- What is the most common customer type?

select customer_type,
count(*) as cusmt_count
from walsales
group by customer_type;

-- What is the gender of most of the customers?

select gender,
 count(gender) as gen_type
from walsales
group by gender
order by gen_type desc;

-- What is the gender distribution per branch?

select gender,
 count(gender) as gen_type
from walsales
where branch = "A"
group by gender
order by gen_type desc;

select gender,
 count(gender) as gen_type
from walsales
where branch = "B"
group by gender
order by gen_type desc;

select gender,
 count(gender) as gen_type
from walsales
where branch = "C"
group by gender
order by gen_type desc;

-- Which time of the day do customers give most ratings?

select
 time_of_day, 
 avg(rating) as avg_cus_rate
 from walsales
 group by time_of_day
 order by avg_cus_rate;

-- Which time of the day do customers give most ratings per branch?

select
 time_of_day, 
ROUND (avg(rating),2) as avg_cus_rate
 from walsales
 where branch = "A"
 group by time_of_day
 order by avg_cus_rate;

select
 time_of_day, 
ROUND (avg(rating),2) as avg_cus_rate
 from walsales
 where branch = "B"
 group by time_of_day
 order by avg_cus_rate;
 
 select
 time_of_day, 
ROUND (avg(rating),2) as avg_cus_rate
 from walsales
 where branch = "C"
 group by time_of_day
 order by avg_cus_rate;
 
 -- Which day fo the week has the best avg ratings?
 
  select
day_name, 
ROUND (avg(rating),2) as avg_cus_rate
 from walsales
 group by day_name
 ;

 select day_name from walsales;
 
 -- Which day of the week has the best average ratings per branch?
 
select day_name,
avg(rating) as avg_rate 
from walsales
where branch = "A"
group by day_name 
order by avg_rate desc;


