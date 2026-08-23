create database Company;
use Company;
create table Departments(
dept_id INT,
dept_name VARCHAR(50),
dept_location VARCHAR(50)
);

create table Employees(
 emp_id INT,
 emp_name VARCHAR(50),
 salary DECIMAL(10,2),
 dept_id INT
);

create table projects(
 project_id INT,
 project_name VARCHAR(100),
 budget DECIMAL(12,2)
);

create table employee_projects(
 emp_id INT,
 project_id INT,
 assigned_date DATE
);

insert into departments values
(1, 'HR', 'Delhi'),
(2, 'IT', 'Noida'),
(3, 'Finance', 'Mumbai'),
(4, 'Marketing', 'Pune');

insert into employees values
(101, 'Amit', 50000, 2),
(102, 'Neha', 60000, 2),
(103, 'Raj', 45000, 1),
(104, 'Priya', 70000, 3),
(105, 'Karan', 55000, NULL),
(106, 'Simran', 52000, 5);

insert into projects values
(201, 'Website Development', 200000),
(202, 'Payroll System', 150000),
(203, 'Mobile App', 300000),
(204, 'CRM Software', 250000);

insert into employee_projects values
(101, 201, '2024-01-10'),
(101, 203, '2024-02-15'),
(102, 201, '2024-01-20'),
(103, 202, '2024-03-01'),
(104, 203, '2024-02-01'),
(107, 204, '2024-04-01');

#1
select e.emp_name, d.dept_name from Employees e
join Departments d on e.dept_id=d.dept_id;

#2
select e.emp_name, d.dept_name from Employees e
join Departments d on e.dept_id=d.dept_id where d.dept_name='IT';

#3
select e.emp_name, d.dept_location from Employees e
join Departments d on e.dept_id=d.dept_id;

#4
select e.emp_name, d.dept_name from Employees e
left join Departments d on e.dept_id=d.dept_id;

#5
select e.emp_name, d.dept_name from Employees e
left join Departments d on e.dept_id=d.dept_id where e.dept_id is null;

#6
select e.emp_name, d.dept_name from Employees e
left join Departments d on e.dept_id=d.dept_id where d.dept_id is null and e.dept_id is not null;

#7
select d.dept_name, e.emp_name from Employees e
right join Departments d on e.dept_id=d.dept_id;

#8
select e.emp_name, p.project_name, assigned_date from employees e
join employee_projects ep using (emp_id)
join projects p on ep.project_id=p.project_id;

#9
select e.emp_name, p.project_name, assigned_date from employees e
join employee_projects ep using (emp_id)
join projects p on ep.project_id=p.project_id where p.project_name='Mobile App';

#10
select emp_id, e.emp_name, e.dept_id from Employees e
left join Departments d on e.dept_id=d.dept_id where d.dept_id is null and e.dept_id is not null;

#11
select ep.project_id, p.project_name from employees e
right join employee_projects ep on ep.emp_id=e.emp_id
join projects p on ep.project_id=p.project_id 
where e.emp_id is null and ep.emp_id is not null;

#12
# No employees assigned
select p.project_name, ep.emp_id from projects p
left join employee_projects ep using(project_id) where ep.emp_id is null;

# No valid employees assigned
select p.project_name, ep.emp_id from projects p
left join employee_projects ep using(project_id)
left join employees e using(emp_id) where p.emp_id is null;

#13
select d.dept_name, sum(e.salary) as 'Total Salary' from departments d
left join employees e using(dept_id)
group by d.dept_name; 

#14
# Only valid employees
select p.project_name , count(ep.emp_id) from projects p
left join employee_projects ep using(project_id)
join employees e using(emp_id)
group by p.project_name;

# Including invalid employees
select p.project_name , count(ep.emp_id) from projects p
left join employee_projects ep using(project_id)
group by p.project_name;

#15
select d.dept_name, avg(e.salary) as 'Total Salary' from departments d
left join employees e using(dept_id)
group by d.dept_name
order by avg(e.salary) desc
limit 1;