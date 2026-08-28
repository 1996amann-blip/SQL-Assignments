create database Retail;
use Retail;
create table Sales (
 sale_id int primary key,
 employee varchar(50),
 region varchar(20),
 sale_amount int,
 sale_date date
);
insert into sales values
(1, 'John', 'North', 500, '2024-01-01'),
(2, 'John', 'North', 800, '2024-01-05'),
(3, 'John', 'North', 300, '2024-01-10'),
(4, 'Emma', 'South', 700, '2024-01-03'),
(5, 'Emma', 'South', 400, '2024-01-06'),
(6, 'Emma', 'South', 600, '2024-01-12'),
(7, 'Mike', 'East', 900, '2024-01-04'),
(8, 'Mike', 'East', 200, '2024-01-08'),
(9, 'Mike', 'East', 300, '2024-01-14');

#1
select employee, sale_date, sale_amount, sum(sale_amount) 
over(partition by employee order by sale_date) 
as 'Cumulative Sale' from Sales;

#2
select employee, region, sale_amount, 
dense_rank() 
over(partition by region order by sale_amount desc) as 'Sale Rank' 
from sales;

#3
select *, max(sale_amount) 
over(partition by employee) as 'Highest Sale' 
from sales;

#4
select *, lag(sale_amount,1) over(partition by employee order by sale_date) as 'Previous Sale' from sales;

#5
select *, lead(sale_amount,1) over(partition by employee order by sale_date) as 'Next Sale' from sales;

#6
select *, sum(sale_amount) over(partition by region) from sales;

#7
select * from(
	select employee, region, sale_amount, 
	dense_rank() 
	over(partition by region order by sale_amount desc) as 'Sale Rank' 
	from sales
) as `Top 2 Sales` where `Sale Rank`< 3;

#8
select *, concat(round(sale_amount / SUM(sale_amount) 
OVER (PARTITION BY employee) * 100,2),' %') as 'Percentage Contribution' from sales;

#9
select *, sale_amount - LAG(sale_amount) 
OVER (partition by employee order by sale_date) 
as 'Deviation from previous sale' from sales;

#10
with Totals as(
	select employee, sum(sale_amount) as 'Total Sales' from sales
    group by employee
) select * from Totals;

#11
with Totals as(
	select employee, sum(sale_amount) as 'Total Sales' from sales
    group by employee
) select * from Totals where `Total Sales` > 1500;

#12
with Region_Average as(
	select region, round(avg(sale_amount),2) as 'Average Sales' from sales
    group by region
),
Overall_Average as(
	select round(avg(sale_amount),2) as 'Overall Avg' from sales
) select r.region, r.`Average Sales`, o.`Overall Avg` 
from Region_Average r, Overall_Average o 
where r.`Average Sales` > o.`Overall Avg`;

#13
with Ranked_Sales as(
	select *, row_number() 
	over(partition by employee order by sale_amount desc) as rn 
	from sales
)
select * from Ranked_Sales where rn = 1;

#14
with recursive numbers as (
select 1 as 'No.'

union all

select `No.`+1
from numbers
where `No.`<10
)
select * from numbers;

#15
with recursive calender as (
select date('2024-01-01') as Dates

union all

select date_add(Dates, interval 1 day)
from calender
where Dates < ('2024-01-10')
)
select * from calender;

#16
