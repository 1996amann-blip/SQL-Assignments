create database ecommerce__db;
use ecommerce__db;

create table users
(
user_id int primary key auto_increment,
name varchar(100),
email varchar(100) unique
);

create table categories
(
category_id int primary key auto_increment,
category_name varchar(100)
);

create table products
(
product_id int primary key auto_increment,
name varchar(100),
category_id int,
price decimal(10,2),
stock int,
foreign key (category_id) references categories (category_id)
);

create table orders
(
order_id int primary key auto_increment,
user_id int,
order_date date,
status varchar(20),
foreign key (user_id) references users (user_id)
);

create table order_items
(
order_item_id int primary key auto_increment,
order_id int,
product_id int,
quantity int,
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products(product_id)
);

create table payments
(
payment_id int primary key auto_increment,
order_id int,
amount decimal(10,2),
payment_status varchar(20),
foreign key (order_id) references orders (order_id)
);

insert into users (name, email) values
('Rahul Sharma', 'rahul@gmail.com'),
('Priya Verma', 'priya@gmail.com'),
('Amit Singh', 'amit@gmail.com'),
('Neha Gupta', 'neha@gmail.com'),
('Rohan Mehta', 'rohan@gmail.com'),
('Sneha Kapoor', 'sneha@gmail.com'),
('Vikas Yadav', 'vikas@gmail.com'),
('Anjali Mishra', 'anjali@gmail.com'),
('Karan Malhotra', 'karan@gmail.com'),
('Pooja Agarwal', 'pooja@gmail.com');

insert into categories (category_name) values
('Electronics'),
('Clothing'),
('Home & Kitchen'),
('Books'),
('Sports');

insert into products 
(name, category_id, price, stock) values
('Wireless Headphones', 1, 2499.00, 25),
('Mechanical Keyboard', 1, 3499.00, 8),
('Smart Watch', 1, 5999.00, 5),
('USB-C Charger', 1, 999.00, 40),

('Men T-Shirt', 2, 799.00, 30),
('Denim Jeans', 2, 1999.00, 7),
('Hoodie', 2, 1499.00, 12),

('Non-Stick Pan', 3, 1299.00, 15),
('Electric Kettle', 3, 1799.00, 6),
('Dinner Set', 3, 2499.00, 20),

('Atomic Habits', 4, 499.00, 50),
('The Psychology of Money', 4, 599.00, 4),
('Clean Code', 4, 899.00, 10),

('Running Shoes', 5, 2999.00, 9),
('Yoga Mat', 5, 799.00, 18),
('Football', 5, 999.00, 14);

insert into orders 
(user_id, order_date, status) values
(1, '2026-08-01', 'Completed'),
(2, '2026-08-02', 'Completed'),
(3, '2026-08-03', 'Shipped'),
(1, '2026-08-05', 'Completed'),
(4, '2026-08-06', 'Pending'),
(5, '2026-08-07', 'Completed'),
(6, '2026-08-08', 'Cancelled'),
(7, '2026-08-10', 'Completed'),
(8, '2026-08-11', 'Shipped'),
(2, '2026-08-12', 'Completed');

insert into order_items
(order_id, product_id, quantity) values

-- Order 1 - Rahul
(1, 1, 2),
(1, 5, 3),

-- Order 2 - Priya
(2, 3, 1),
(2, 11, 2),

-- Order 3 - Amit
(3, 2, 1),
(3, 14, 1),

-- Order 4 - Rahul
(4, 1, 1),
(4, 3, 1),
(4, 4, 2),

-- Order 5 - Neha
(5, 8, 2),
(5, 9, 1),

-- Order 6 - Rohan
(6, 6, 2),
(6, 12, 1),

-- Order 7 - Sneha
(7, 15, 2),

-- Order 8 - Vikas
(8, 14, 2),
(8, 16, 1),

-- Order 9 - Anjali
(9, 7, 1),
(9, 10, 1),

-- Order 10 - Priya
(10, 1, 3),
(10, 2, 1);


insert into payments
(order_id, amount, payment_status) values
(1, 7397.00, 'Paid'),
(2, 6997.00, 'Paid'),
(3, 6498.00, 'Paid'),
(4, 8497.00, 'Paid'),
(5, 4397.00, 'Pending'),
(6, 4597.00, 'Paid'),
(7, 1598.00, 'Failed'),
(8, 6997.00, 'Paid'),
(9, 3298.00, 'Paid'),
(10, 10997.00, 'Paid');

#1
select * from products;

#2
select * from products
where stock < 10;

#3
select o.order_id, u.name as customer_name, o.order_date, p.name as product_name, 
p.price, oi.quantity, p.price*oi.quantity as item_total, o.status from users u 
right join orders o on o.user_id = u.user_id 
left join order_items oi on o.order_id = oi.order_id
left join products p on oi.product_id = p.product_id;

#4
with order_summary as
(
	select o.order_id, u.name as customer_name, o.order_date, p.name as product_name, 
	p.price, oi.quantity, p.price*oi.quantity as item_total, o.status from users u 
	right join orders o on o.user_id = u.user_id 
	left join order_items oi on o.order_id = oi.order_id
	left join products p on oi.product_id = p.product_id
)
select *, sum(item_total) 
over(partition by o.order_id, customer_name) 
as order_total from order_summary; 

#5
select p.product_id, p.name, sum(oi.quantity) as quantity_sold
from products p join order_items oi on p.product_id = oi.product_id
group by product_id
order by quantity_sold desc
limit 1;