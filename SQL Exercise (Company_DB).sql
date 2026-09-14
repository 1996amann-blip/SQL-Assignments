create database company__db;
use company__db;

create table departments
(
department_id int primary key auto_increment,
department_name varchar(100) not null
);

create table employees
(
employee_id int primary key auto_increment,
employee_name varchar(100) not null,
department_id int,
salary decimal (10,2),
status varchar (20) default 'Active',
joining_date date,
foreign key (department_id) references departments (department_id)
);

create table employee_salary_log
(
log_id int primary key auto_increment,
employee_id int,
old_salary decimal(10,2),
new_salary decimal(10,2),
changed_at datetime
);

insert into departments (department_name)
values ('IT'),
('HR'),
('Sales'),
('Finance');

insert into employees
(employee_name, department_id, salary, status, joining_date)
values
('Aman', 1, 50000, 'ACTIVE', '2024-01-10'),
('Riya', 2, 42000, 'ACTIVE', '2023-06-15'),
('Rahul', 1, 65000, 'ACTIVE', '2022-09-20'),
('Sneha', 3, 38000, 'INACTIVE', '2024-03-12'),
('Karan', 4, 55000, 'ACTIVE', '2021-11-05');

#1
create view active_employees as
(
select employee_id, employee_name, status from employees
where status = 'ACTIVE'
);

select * from active_employees;

#2
create view employee_department_view as 
(
select e.employee_id, e.employee_name, d.department_name, e.salary, e.status from employees e
join departments d on e.department_id = d.department_id
);

select * from employee_department_view;

#3
create view high_salary_employees as
(
select * from employees
where salary > 50000
);

select * from high_salary_employees;

#4
create view department_salary_summary as
(
select d.department_name, count(e.employee_id) as number_of_employees, 
avg(e.salary) as average_salary, 
max(e.salary) as maximum_salary, 
min(e.salary) as minimum_salary
from departments d left join employees e on d.department_id = e.department_id
group by d.department_name, d.department_id
);

select * from department_salary_summary;

#5
select * from employee_department_view
where department_name = 'IT';

#6
select * from high_salary_employees
order by salary desc;

#7
create or replace view active_employees as
(
select employee_id, employee_name, status, joining_date from employees
where status = 'ACTIVE'
); 

select * from active_employees;

#8
show create view employee_department_view;

#9
drop view high_salary_employees;

#10