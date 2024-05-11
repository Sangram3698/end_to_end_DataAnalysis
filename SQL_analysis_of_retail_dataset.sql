--find top 10 highest revenue generating products
select top 10 product_id,sum(sales_price) as sales
from df_orders
group by product_id
order by sales desc;

--find the top 5 highest selling products in each region
with cte as(
select region,product_id,sum(sales_price) as sales
from df_orders
group by region,product_id)
select * from(
select *
,ROW_NUMBER() over(partition by region order by cte.sales desc) as rn
from cte) A
where rn<=5;


--find month over month growth comparision between 2022 and 2023 : i.e jan 2022 vs jan 2023

with cte as(
select year(order_date) as order_year,month(order_date) as order_month
,sum(sales_price) as sales
from df_orders
group by year(order_date),month(order_date))

select order_month,
sum(case when order_year=2022 then sales else 0 end) as sales_2022,
sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month;


--for each category which months has the highest sales
with cte as(
select category,format(order_date,'yyyyMM') as order_year_month,
sum(sales_price) as sales
from df_orders
group by category,format(order_date,'yyyyMM'))

select * from (
select *,
ROW_NUMBER() over(partition by category order by sales desc) as rn
from cte) a
where rn=1;


--which sub category has the highest growth by profit in 2023 compared to 2022


