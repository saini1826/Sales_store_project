drop database if exists sales_store;
create database sales_store;
use sales_store;

create table sales (
       transaction_id varchar(50),
       customer_id varchar(50),
       customer_name varchar(50),
       customer_age int,
       gender varchar(15),
       product_id varchar(50),
       product_name varchar(50),
       product_category varchar(50),
       quantiy int,
       prce float,
       payment_mode varchar(50),
       purchase_date date,
       time_of_purchase date,
       status varchar(50)
       );
       
-- import data

select * from sales;

-- Data cleaning

-- step 1:- To check for duplicate

select transaction_id,count(*)
from sales
group by transaction_id
having count(transaction_id) >1;

with cte as (
select *,
    row_number() over (partition by transaction_id order by transaction_id ) as Row_Num
from sales
)
select * from cte
where Row_Num > 1;

-- Data Analysis

-- 1. What are the top 5 most selling products by quantity?

select product_name, sum(quantiy) as total_quantity
from sales
group by product_name
order by total_quantity desc
limit 5;

-- Business Problem: We don't know which products are most in demand.

-- Business Impact: Helps prioritize stock and boost sales through targeted promotions.

-----------------------------------------------------------------------------------------------------------

-- 2. Which products are most frequently cancelled?

select product_name, count(*) as total_cancelled
from sales
where status = "cancelled"
group by product_name
order by total_cancelled desc
limit 5;

-- Business Problem: Frequent cancellations affect revenue and customer trust.

-- Business Impact: Identify poor-performing products to improve quality or remove from catalog.

 -----------------------------------------------------------------------------------------------------------

-- 3. Who are the top 5 highest spending customers?

select customer_name, sum(prce*quantiy) as total_spend
from sales
group by customer_name
order by total_spend 
limit 5;

-- Business Problem Solved: Identify VIP customers.

-- Business Impact: Personalized offers, loyalty rewards, and retention.

-----------------------------------------------------------------------------------------------------------

-- 5. Which product categories generate the highest revenue?

select product_category, sum(prce*quantiy) as revenue
from sales
group by product_category
order by revenue desc
limit 5;

-- Business Problem Solved: Identify top-performing product categories.

-- Business Impact: Refine product strategy, supply chain, and promotions.
-- allowing the business to invest more in high-margin or high-demand categories.

-----------------------------------------------------------------------------------------------------------

-- 6. What is the return/cancellation rate per product category?

select product_category,
	count(case when status="cancelled" then 1 end)*100.0/count(*) as cancelled_percent
from sales
group by product_category
order by cancelled_percent desc;

-- Business Problem Solved: Monitor dissatisfaction trends per category.


-- Business Impact: Reduce returns, improve product descriptions/expectations.
-- Helps identify and fix product or logistics issues.

-----------------------------------------------------------------------------------------------------------
-- 7. What is the most preferred payment mode?

select payment_mode, count(payment_mode) as total_count
from sales
group by payment_mode
order by total_count desc;

-- Business Problem Solved: Know which payment options customers prefer.

-- Business Impact: Streamline payment processing, prioritize popular modes.

-----------------------------------------------------------------------------------------------------------

-- 8. What's the monthly sales trend?

select
     format(purchase_date,"yyyy-mm") as Month_Year,
     sum(prce*quantiy) as total_sales,
     sum(quantiy) as total_quantiy
from sales
group by format(purchase_date,"yyyy-mm");

-- Business Problem: Sales fluctuations go unnoticed.

-- Business Impact: Plan inventory and marketing according to seasonal trends.

-------------------------------------------------------------------------------------------------------------

-- 9. Are certain genders buying more specific product categories?

select gender, product_category, count(product_category) as total_purchace
from sales
group by gender, product_category
order by gender;

-- Business Probles: Gender-based product preference.

-- Business Impact: personlized ads, gender-focused campaigns.