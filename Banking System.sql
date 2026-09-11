create database banking_db;
use banking_db;

create table customers(
customer_id int primary key auto_increment,
name varchar(100),
email varchar(100) unique
);

create table accounts(
account_id int primary key auto_increment,
customer_id int,
balance decimal(12,2),
account_type varchar(20),
foreign key (customer_id) references customers (customer_id)
);

create table transactions(
transaction_id int primary key auto_increment,
account_id int,
type varchar(10),
amount decimal(10,2),
transaction_date date,
foreign key (account_id) references accounts (account_id)
);

create table loans(
loan_id int primary key auto_increment,
customer_id int,
loan_amount decimal(12,2),
interest_rate decimal(10,2),
foreign key (customer_id) references customers (customer_id)
);

insert into customers (name, email)
values
('Rahul Sharma', 'rahul@gmail.com'),
('Priya Verma', 'priya@gmail.com'),
('Amit Singh', 'amit@gmail.com'),
('Neha Gupta', 'neha@gmail.com'),
('Rohan Mehta', 'rohan@gmail.com'),
('Sneha Kapoor', 'sneha@gmail.com'),
('Vikas Yadav', 'vikas@gmail.com'),
('Anjali Mishra', 'anjali@gmail.com');

insert into accounts 
(customer_id, balance, account_type)
values
(1, 75000.00, 'Savings'),
(1, 25000.00, 'Current'),

(2, 120000.00, 'Savings'),

(3, 45000.00, 'Savings'),
(3, 80000.00, 'Current'),

(4, 95000.00, 'Savings'),

(5, 30000.00, 'Savings'),

(6, 150000.00, 'Savings'),
(6, 50000.00, 'Current'),

(7, 65000.00, 'Savings'),

(8, 20000.00, 'Savings');

insert into transactions
(account_id, type, amount, transaction_date)
values
-- Rahul - Account 1
(1, 'Deposit', 50000.00, '2026-01-05'),
(1, 'Withdraw', 10000.00, '2026-01-10'),
(1, 'Deposit', 25000.00, '2026-02-15'),
(1, 'Withdraw', 5000.00, '2026-03-01'),

-- Rahul - Account 2
(2, 'Deposit', 25000.00, '2026-01-20'),
(2, 'Withdraw', 8000.00, '2026-02-05'),

-- Priya - Account 3
(3, 'Deposit', 100000.00, '2026-01-08'),
(3, 'Withdraw', 20000.00, '2026-02-12'),
(3, 'Deposit', 40000.00, '2026-03-10'),

-- Amit - Account 4
(4, 'Deposit', 50000.00, '2026-01-15'),
(4, 'Withdraw', 5000.00, '2026-02-20'),

-- Amit - Account 5
(5, 'Deposit', 100000.00, '2026-01-25'),
(5, 'Withdraw', 20000.00, '2026-02-25'),

-- Neha - Account 6
(6, 'Deposit', 75000.00, '2026-01-12'),
(6, 'Withdraw', 10000.00, '2026-02-10'),
(6, 'Deposit', 50000.00, '2026-03-05'),

-- Rohan - Account 7
(7, 'Deposit', 30000.00, '2026-02-01'),
(7, 'Withdraw', 5000.00, '2026-02-18'),

-- Sneha - Account 8
(8, 'Deposit', 150000.00, '2026-01-05'),
(8, 'Withdraw', 25000.00, '2026-02-15'),

-- Sneha - Account 9
(9, 'Deposit', 50000.00, '2026-01-20'),
(9, 'Withdraw', 10000.00, '2026-03-01'),

-- Vikas - Account 10
(10, 'Deposit', 65000.00, '2026-02-10');

insert into loans
(customer_id, loan_amount, interest_rate)
values
(1, 500000.00, 8.50),
(2, 800000.00, 7.75),
(3, 300000.00, 9.25),
(4, 1000000.00, 8.00),
(5, 250000.00, 10.50),
(6, 600000.00, 7.50),
(6, 200000.00, 9.00),
(7, 400000.00, 8.75);

#1
select * from customers;

#2
select * from accounts
where account_type = 'Savings';

#3
select * from customers;
select * from accounts;

select a.customer_id, c.name, sum(a.balance) as total_balance
from accounts a join customers c 
on a.customer_id=c.customer_id
group by a.customer_id, c.name;

#4
select * from transactions
where account_id = 2;