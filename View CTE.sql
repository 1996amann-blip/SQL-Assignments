create database company_practice;
use company_practice;

create table Departments
(
dept_id int primary key,
dept_name varchar(50) not null,
location varchar(50)
);

create table employees
(
emp_id int primary key,
emp_name varchar(50) not null,
salary decimal(10,2),
dept_id int,
manager_id int,
hire_date date,
foreign key (dept_id) references Departments (dept_id)
);

insert into Departments values
(1, 'HR', 'Delhi'),
(2, 'IT', 'Noida'),
(3, 'Sales', 'Mumbai'),
(4, 'Finance', 'Bangalore');

insert into employees values
(101, 'Amit', 50000, 1, NULL, '2020-01-15'),
(102, 'Neha', 75000, 2, 101, '2019-03-10'),
(103, 'Raj', 60000, 2, 102, '2021-06-20'),
(104, 'Simran', 45000, 3, 101, '2022-02-11'),
(105, 'Karan', 80000, 2, 102, '2018-07-05'),
(106, 'Priya', 55000, 4, 101, '2023-01-25');

#1
create view v_employee_salary as 
select emp_name, salary from employees;

select * from V_employee_salary;

#2
create view v_employee_department as
select emp_name, dept_name from employees e
join Departments d on e.dept_id = d.dept_id ;

select * from v_employee_department;

#3
create view v_high_salary as 
select emp_name, salary from employees
where salary > 60000;

select * from V_high_salary;

#4
create view v_dept_total_salary as
select d.dept_name, sum(e.salary) as total_salary from departments d
join employees e on d.dept_id = e.dept_id
group by d.dept_name;

select * from v_dept_total_salary;

#5
create view emp_info as 
select emp_id, emp_name, dept_name from employees e
join departments d on e.dept_id = d.dept_id; 

select * from emp_info;

#6
update v_employee_salary set salary = 65000
where emp_name='Amit';

select * from v_employee_salary;

#7
drop view if exists v_high_salary;

show full tables
where table_type = 'VIEW';

#8
with avg_salary as
(
select avg(salary) as average_salary from employees
)

select e.emp_id, e.emp_name, e.salary, ags.average_salary from employees e
join avg_salary ags 
where e.salary > ags.average_salary;

#9
with dept_avg as 
(
select dept_id, avg(salary) as dept_avg_salary from employees
group by dept_id
)
select d.dept_name, da.dept_avg_salary from departments d
join dept_avg da on d.dept_id = da.dept_id;

#10
with dept_max as 
(
select dept_id, max(salary) as highest_salary from employees
group by dept_id
)
select d.dept_name, da.highest_salary from departments d
join dept_max da on d.dept_id = da.dept_id;

#11
with dept_it as 
(
select e.emp_id, e.emp_name, d.dept_name from employees e
join departments d on e.dept_id = d.dept_id
where d.dept_name = 'IT'
)
,
high_salary as 
(
select emp_id, emp_name, salary from employees
where salary > 70000
)

select di.emp_id, di.emp_name, hs.salary, di.dept_name from dept_it di
join high_salary hs on di.emp_id = hs.emp_id;

#12
with ranked_sal as 
(
select emp_id, emp_name, salary, row_number() over(order by salary desc) as 'Ranked Salary' from employees
)
select * from ranked_sal;

#13
with ranked_sal as 
(
select e.emp_id, e.emp_name, e.salary, d.dept_name, 
row_number() over(partition by e.dept_id order by e.salary desc) as 'Ranked Salary' 
from employees e
join departments d on e.dept_id = d.dept_id
)
select * from ranked_sal  
where `Ranked Salary` <=2
order by dept_name;

#14
with diff as 
(
select max(salary) as 'Highest Salary', 
min(salary) 'Lowest Salary', 
max(salary) - min(salary) as 'Salary Difference' 
from employees
)
select * from diff;