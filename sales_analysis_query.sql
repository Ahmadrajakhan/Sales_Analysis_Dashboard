# first created the database

create database Sales_project;

# use the database

use Sales_project;

# show the all tables present in my database

show tables;

# show the all column / data / retrive from table

select * from cleaned_sales_data;

# total sales 

select sum(sales)as total_sales from Cleaned_sales_data;

# average sales

select avg(sales) as average_sales from Cleaned_sales_data;

# maximum salse

select max(sales) as maximum_sales from Cleaned_sales_data;

# minimum sales

select min(sales) as minimum_sales from Cleaned_sales_data;

# Region wise sales

select region,sum(sales) as total_sales from Cleaned_sales_data
group by 1;

# top 10 products         ( in this data columnname with space then we use ``(backtick) example Product Name  then use `Product Name` )

select * from (
select `Product Name`,sum(sales) as total_sales,
dense_rank() over(order by sum(sales) desc) as ranking
from Cleaned_sales_data 
group by `Product Name`) as rank_products 
where ranking <=10;

# Region Wise Product Ranking top (10)

with cte as (
select  region,`Product Name` ,sum(sales) as total_salse,
dense_rank() over(partition by region order by sum(sales) desc) as ranking
from Cleaned_sales_data 
group by region,`Product Name`)
select * from cte
where ranking <=10;

# Running Total (Cumulative Sum)

select year,month,sum(sales) as month_vise_sales,
sum(sum(sales)) over(order by year,month) as running_total
from Cleaned_sales_data group by 1,2;

# Previous Month Sales  LAG()

with monthly_sales as (
select month,sum(sales) as total_sales
from Cleaned_Sales_data 
group by 1)
select month,total_sales,lag(total_sales)
over(order by month) as previous_month_sales
from monthly_sales;

# Next Month Sales LEAD()

with monthly_sales as (
select month,sum(sales) as total_sales
from Cleaned_Sales_data 
group by 1)
select month,total_sales,lead(total_sales)
over(order by month) as next_month_sales
from monthly_sales;

# First values()

select Region,`Product Name`,Sales,
first_value(Sales) over(partition by Region order by Sales desc) as highest_sales
from cleaned_sales_data;

# Last value()

WITH lowest_sales AS
(
    SELECT Region,
           `Product Name`,
           Sales,
           ROW_NUMBER() OVER(
               PARTITION BY Region
               ORDER BY Sales ASC
           ) AS rn
    FROM cleaned_sales_data
)

SELECT *
FROM lowest_sales
WHERE rn = 1;

# Ntile()

select `customer name`,sales,
ntile(4) over(order by sales desc) as customer_group
from cleaned_sales_data;

