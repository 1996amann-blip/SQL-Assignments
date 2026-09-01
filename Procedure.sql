create database company_db;
use company_db;

create table employees
(
emp_id int primary key auto_increment,
emp_name varchar(100),
department varchar(50),
salary decimal(10,2),
hire_date date
);

create table orders
(
order_id int primary key auto_increment,
customer_name varchar(100),
order_amount decimal(10,2),
order_date date
);

#1
delimiter ^^
create procedure emp_record()
begin
	select * from employees;
end ^^ delimiter ;

insert into employees (emp_name, department, salary, hire_date)
values
('Shikhar','IT',60000,'2026-01-31'),
('Rohan','Finance',75000,'2025-06-24'),
('Parul','HR',50000,'2025-02-12'),
('Raghu','IT',40000,'2026-08-31'),
('Sheetal','HR',80000,'2024-05-03');

call emp_record();

#2
delimiter !!
create procedure get_employees_by_department(in dept_name varchar(50))
begin
	select * from employees where department = dept_name;
end !! delimiter ;

call get_employees_by_department('HR');

#3
delimiter //
create procedure get_employees_by_id(in emp_id int)
begin
	select * from employees e where emp_id = e.emp_id;
end // delimiter ;

call get_employees_by_id(1);

#4
delimiter <<
create procedure insert_employee(in e_name varchar(100), in e_department varchar(50), in e_salary decimal(10,2), in e_hire_date date)
begin
	insert into employees (emp_name, department, salary, hire_date)
	value (e_name, e_department, e_salary, e_hire_date);
end << delimiter ;

select * from employees;

call insert_employee('Naresh','Finance',68000,'2025-05-06');

#5
delimiter %%
create procedure increase_salary(in e_id int, in percentage int)
begin
	update employees set salary = (salary + (salary * percentage/100))
    where emp_id = e_id;
end %% delimiter ;

select * from employees;

call increase_salary(1,10);

#6
delimiter ::
create procedure get_employee_count(out total int)
begin
	select count(emp_id) into total from employees;
end :: delimiter ;

call get_employee_count(@total);
select @total;

#7
delimiter ||
create procedure get_avg_salary_by_department(in dept_name varchar(100), out avg_salary decimal(10,2))
begin
	select avg(salary) into avg_salary from employees
    where department = dept_name
    group by department ;
end || delimiter ;

call get_avg_salary_by_department('HR',@avg_salary);
select @avg_salary;

select * from employees;

#8
delimiter ??
create procedure check_salary_category(in e_id int, out s_type varchar(50))
begin
	select
		case 
			when salary < 30000 then "Low Salary"
            when salary >= 30000 and salary <= 60000 then "Medium Salary"
            when salary > 60000 then "High Salary"
		end into s_type
	from employees
    where emp_id = e_id;
end ?? delimiter ;

call check_salary_category(4,@s_type);
select @s_type;

#9
delimiter >>
create procedure insert_dummy_employees()
begin
	declare i int default 1;
    dummy_loop : loop
		insert into employees (emp_name, department, salary, hire_date) 
        value
        (concat('Dummy',i), 'IT','45000',current_date());
        set i = i+1;
        if 
			i > 5 then
            leave dummy_loop;
            end if;
        end loop dummy_loop;
end >> delimiter ;

call insert_dummy_employees();

select * from employees;

#10
