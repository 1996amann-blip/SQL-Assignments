create database companyx;
use companyx;

create table employees (
emp_id int auto_increment primary key,
`name` varchar(100),
department varchar(100),
salary int(15),
age smallint(3),
city varchar(80)
);

insert into employees (`name`, department, salary, age, city) values 
('Rahul', 'IT', 60000, 28, 'Delhi'),
('Neha', 'HR', 45000, 32, 'Mumbai'),
('Amit', 'IT', 80000, 35, 'Delhi'),
('Priya', 'Finance', 70000, 29, 'Pune'),
('Karan', 'HR', 40000, 25, 'Delhi');

#1
select * from employees
where department = 'IT';

#2
select * from employees
where salary > 50000;

#3
select * from employees
where city = 'Delhi';

#4
select * from employees
where age < 30;

#5
select * from employees
where salary > 60000 and salary < 80000;

#6
select * from employees
where salary > 70000 and department = 'IT';

#7
select * from employees
where department = 'HR' or department = 'Finance';

#8
select * from employees
where age > 30 and city = 'Delhi';

#9
select * from employees
where salary < 50000 or age < 28;

#10
select * from employees
where department = 'IT' and city = 'Delhi' and salary > 50000;

#11
select * from employees
order by salary;

#12
select * from employees
order by salary desc;

#13
select * from employees
order by age;

#14
select * from employees
order by department, salary desc;

#15
select * from employees
where city = 'Delhi'
order by salary desc;

#16
select department, count(emp_id) as `No. of employees` from employees
group by department;

#17
select department, avg(salary) as `Avg Salary` from employees
group by department;

#18
select city, count(emp_id) from employees
group by city;

#19
select department, max(salary) from employees
group by department;

#20
select city, min(salary) from employees
group by city;

#21
select department, avg(salary) as `Avg Salary` from employees
group by department having avg(salary) > 60000;

#22
select city, count(emp_id) as 'No. of employees' from employees
group by city having count(emp_id) > 1;

#23
select department, max(salary) as `Max Salary` from employees
group by department having max(salary) > 70000;

#24
select city, cast(avg(age) as unsigned) as `Avg Age` from employees
group by city having avg(age) > 30;

#25
select department, sum(salary) as `Total Salary` from employees
group by department having sum(salary) > 100000;

#26
select * from employees
order by salary desc limit 3;

#27
select * from employees
limit 2;

#28
select * from employees
order by salary desc limit 1;

#29
select * from employees
where department = 'HR'
limit 2;

#30
select * from employees
order by salary limit 3;