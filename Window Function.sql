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
with recursive employee_sales as (
    
    select
        sale_id,
        employee,
        sale_date,
        sale_amount,
        sale_amount as cumulative_sales
    from sales
    where sale_id in (
        select min(sale_id)
        from sales
        group by employee
    )

    union all
    
    select
        s.sale_id,
        s.employee,
        s.sale_date,
        s.sale_amount,
        es.cumulative_sales + s.sale_amount
    from employee_sales es
    join sales s
        on s.employee = es.employee
       and s.sale_date > es.sale_date
    where s.sale_date = (
        select min(s2.sale_date)
        from sales s2
        where s2.employee = es.employee
		and s2.sale_date > es.sale_date
    )
)

select *
from employee_sales
order by employee, sale_date;

#17
with average_sales as 
(
	select employee, avg(sale_amount) as average_sale from sales
    group by employee
),

sales_above_avg as 
(
	select s.employee, sale_date, s.sale_amount, average_sale from sales s
    join average_sales ag on s.employee = ag.employee
    where sale_amount > average_sale
)
select * from sales_above_avg
order by employee, sale_date;

#18
with ordered_sales as 
(
	select *, row_number() 
	over(order by sale_amount desc) as sale_rank 
	from sales
),
top_3 as
(
select * from ordered_sales
where sale_rank <=3
)

select * from top_3;

INSERT INTO sales VALUES
(10, 'John', 'North', 1000, '2024-02-02'),
(11, 'Emma', 'South', 1200, '2024-02-10'),
(12, 'Mike', 'East', 600, '2024-02-15'),

(13, 'John', 'North', 1500, '2024-03-03'),
(14, 'Emma', 'South', 800, '2024-03-08'),
(15, 'Mike', 'East', 700, '2024-03-20'),

(16, 'John', 'North', 900, '2024-04-05'),
(17, 'Emma', 'South', 1800, '2024-04-12'),
(18, 'Mike', 'East', 500, '2024-04-25');

select date_format(sale_date, '%Y-%m') as months,
sum(sale_amount) as sale from sales
group by months;

#19
with monthly_sales as 
(
	select date_format(sale_date, '%Y-%m') as months,
	sum(sale_amount) as sale from sales
	group by months
),
monthly_top as
(
	select * from monthly_sales
    order by sale desc
    limit 1
)

select * from monthly_top;

