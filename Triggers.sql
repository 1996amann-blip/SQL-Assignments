create database ORG;
use ORG;

create table employees
(
emp_id int primary key auto_increment,
ename varchar(100),
salary decimal(10,2),
department varchar(50)
);

create table salary_log
(
log_id int primary key auto_increment,
emp_id int,
old_salary decimal(10,2),
new_salary decimal(10,2),
changed_at timestamp default current_timestamp
);



#1
delimiter ^^
create trigger update_entry
after update on employees
for each row
begin
	if new.salary != old.salary then
		insert into salary_log(emp_id, old_salary, new_salary)
		value(new.emp_id, old.salary, new.salary);
	end if;
end ^^ delimiter ;

insert into employees (ename, salary, department)
values('Rohan', 25000, 'Finance'),
('Vineet', 40000, 'HR');

update employees set salary = 35000 where ename = 'Rohan';

select * from salary_log;

create table Accounts
(
acc_id int primary key auto_increment,
holder_name varchar(100),
balance decimal(10,2)
);

#2
delimiter ??
create trigger negative_bal
after update on Accounts
for each row
begin
	if new.balance < 0 then
		signal sqlstate '45000'
		set message_text = "Balance can't be negative..";
	end if;
end ?? delimiter ;

insert into Accounts (holder_name, balance)
value ('Naman',20000);

select * from Accounts;

update Accounts set balance = -76.00 where holder_name = 'Naman';

#3
create table Orders
(
order_id int primary key auto_increment,
total_amount decimal(10,2) default 0
);

create table order_items
(
item_id int primary key auto_increment,
order_id int,
quantity int,
price decimal(10,2)
);

delimiter //
create trigger order_total
after insert on order_items
for each row
begin
	if exists(
		select 1 from orders
        where order_id = new.order_id
	)
	then	
		update Orders
		set total_amount = total_amount + (new.quantity * new.price)
		where order_id = new.order_id;
	else
		insert into orders (order_id, total_amount)
        value (new.order_id, new.quantity*new.price);
	end if;
end // delimiter ;


insert into order_items (order_id, quantity, price) 
value(1,2,150);

select * from orders;

insert into order_items (order_id, quantity, price)
values
(2,5,50),
(1,1,100),
(3,10,20);

#4
create table products
(
product_id int primary key auto_increment,
p_name varchar(100),
price decimal(10.2)
);

create table deleted_products
(
product_id int,
p_name varchar(100),
price decimal(10,2),
deleted_at timestamp default current_timestamp
);

delimiter --
create trigger del_products
before delete on  products
for each row
begin
	insert into deleted_products (product_id, p_name, price)
    value(old.product_id, old.p_name, old.price);
end -- delimiter ;

insert into products (p_name, price)
values
('Books',150),
('Pen','10'),
('Copy','80'),
('Calculator','580');

delete from products where p_name='Pen';

select * from products;

select * from deleted_products;

#5
create table users
(
user_id int primary key auto_increment,
u_name varchar(100),
email varchar(100)
);

delimiter ::
create trigger duplicate_id
before insert on users
for each row
begin
	if exists
    (
		select 1 from users
        where email = new.email
    ) then
		signal sqlstate '45000'
        set message_text = 'Email Id already Exists..';
	end if;
end :: delimiter ;

insert into users (u_name, email)
values
('Naman','naman123@gmail.com'),
('Rahul','rsingh@hotmail.com'),
('Nihal','nihals1990@gmail.com'),
('Ravi','rsingh1@hotmail.com');

select * from users;

#6
create table students
(
student_id int primary key auto_increment,
s_name varchar(100),
marks int
);

create table student_audit
(
audit_id int primary key auto_increment,
student_id int,
old_marks int,
new_marks int,
updated_at timestamp default current_timestamp
);

delimiter %%
create trigger stu_marks_log
after update on students
for each row
begin
	insert into student_audit (student_id, old_marks, new_marks)
    value (new.student_id, old.marks, new.marks);
end %% delimiter ;

insert into students (s_name, marks)
values
('Rohan','88'),
('Vineet','68'),
('Ravi','58'),
('Mahesh','75'),
('Uday','68'),
('Harsh','80');

update students
set marks = '75'
where s_name='Ravi';

select * from student_audit;

#7
create table posts
(
post_id int primary key auto_increment,
title varchar(200),
content text,
updated_at timestamp
);

delimiter !!
create trigger post_update
before update on posts
for each row
begin
    set new.updated_at = current_timestamp();
end !! delimiter ;

insert into posts (title, content)
values
('My First Post', 'This is my first post.'),
('SQL Practice', 'Learning SQL triggers.'),
('Data Science', 'Learning Python and SQL.');

select * from posts;

update posts
set title = 'My Updated Post'
where post_id = 1;