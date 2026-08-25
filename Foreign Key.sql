create database ecommerce_db;
use ecommerce_db;

# Customers (Parent Table)
create table customers(
customer_id int primary key,
customer_name varchar(100),
email varchar(100),
city varchar(50)
);

# Products (Parent Table)
create table products (
 product_id int primary key,
 product_name varchar(100),
 price decimal(10,2)
);

# Orders (Child of Customers)
create table orders(
 order_id int primary key,
 order_date date,
 customer_id int,
 foreign key (customer_id)
 references customers(customer_id)
 on delete cascade
);

# Order_Items (Child of Orders and Products)
create table order_items(
 order_id int,
 product_id int,
 quantity int,
 primary key (order_id, product_id),
 foreign key (order_id)
 references orders(order_id)
 on delete cascade,
 foreign key (product_id)
 references products(product_id)
);

# 1
insert into customers values
(1,'Mohan','mohan23@yahoo.com','Mumbai'),
(2,'Rahul','rahul1992@gmail.com','Pune'),
(3,'Sunil','sunilsingh123@gmail.com','Noida'),
(4,'Mahesh','mahesh29@hotmail.com','Goa'),
(5,'Rohan','rohanbornvita@gmail.com','Kasoli');

insert into products values
(1,'Pant',750.99),
(2,'Shirt',900),
(3,'Tie',350.75),
(4,'Socks',99),
(5,'Belt',800.5);

insert into orders values
(101, '2026-01-15', 1),
(102, '2026-02-20', 2),
(103, '2026-03-10', 1),
(104, '2026-04-05', 4),
(105, '2026-05-18', 5);

insert into order_items values
(101, 2, 1),
(101, 4, 3),
(102, 1, 2),
(102, 5, 1),
(103, 3, 2),
(103, 5, 1),
(104, 1, 1),
(105, 2, 2),
(105, 3, 1);

# 2
insert into orders value (105,'2026-7-16',8);
# Deos not allow to insert order for customer_id that does not exist.

# 3
insert into order_items value (102,'10',5);
# Deos not allow to insert order_item for product_id that does not exist.

#4
select * from orders;
delete from customers where customer_id=4;
# Order for customer_id 4 deleted as well.

#5
select * from order_items;
delete from orders where order_id=101;
# Order_items entry for order_id 101 deleted as well.

#6
delete from products where product_id=5;
# Don't need to modify as product id is already a foreign key in order_items table.

#7
SHOW CREATE TABLE orders;
alter table orders
drop foreign key orders_ibfk_1;

alter table orders
add foreign key (customer_id)
references customers (customer_id)
on delete cascade
on update cascade;

#8
show create table order_items;
alter table order_items
drop foreign key order_items_ibfk_1;

alter table order_items
drop foreign key order_items_ibfk_2;

alter table order_items
add foreign key (order_id)
references orders(order_id)
on delete cascade,
add foreign key (product_id)
references products(product_id);

#9
select customer_name, order_date from customers c join
orders o using(customer_id);

#10
select customer_name, product_name from customers 
left join orders o using(customer_id)
left join order_items oi using (order_id)
left join products p using (product_id);

#11
select o.order_id, c.customer_name from orders o
left join customers c using(customer_id);

#12
select o.order_id, p.product_name, oi.quantity from orders o
inner join order_items oi using(order_id)
inner join products p using(product_id);

#13
select c.customer_name, p.product_name from customers c
join orders o using(customer_id)
join order_items oi using (order_id)
join products p using (product_id) where customer_name = 'Mohan';

#14
INSERT INTO orders
VALUES (106, '2026-08-20', 1);

select customer_name, count(order_id) as `No. of Orders` from customers c
join orders o using (customer_id)
group by c.customer_name, c.customer_id;

#15
select customer_name, count(order_id) as `No. of Orders` from customers c
left join orders o using (customer_id)
group by c.customer_name, c.customer_id having count(order_id) = 0;

#16
select c.customer_name, o.order_date, p.product_name, oi.quantity from customers c
join orders o using(customer_id)
join order_items oi using(order_id)
join products p using(product_id);

#17
select product_name,sum(quantity) as Sold from order_items oi
join products p using(product_id)
group by p.product_name, p.product_id;

#18
select c.customer_name, sum(p.price*oi.quantity) as Amt from customers c
left join orders o using(customer_id)
left join order_items oi using(order_id)
left join products p using(product_id)
group by customer_id;

#19
select order_id, sum(p.price*oi.quantity) as `Amt/Order` from orders o
join order_items oi using (order_id)
join products p using (product_id)
group by order_id;

#20
select c.customer_name, sum(p.price*oi.quantity) as Amt from customers c
left join orders o using(customer_id)
left join order_items oi using(order_id)
left join products p using(product_id)
group by customer_id
order by Amt desc 
limit 1;

#21
select customer_name, count(order_id) as `No. of Orders` from customers c
left join orders o using(customer_id)
group by c.customer_id; 

#22
select customer_name, count(order_id) as `No. of Orders` from customers c
left join orders o using(customer_id)
group by c.customer_id having count(order_id) > 1; 

#23
select avg(`Amt/Order`) as `Avg Amt` from(
	select order_id, sum(p.price*oi.quantity) as `Amt/Order` from orders o
	join order_items oi using (order_id)
	join products p using (product_id)
	group by order_id
) as `Order Total`;

#24
select product_name, sum(p.price*oi.quantity) as Revenue from products p
left join order_items oi using (product_id)
group by p.product_id
order by Revenue desc
limit 1;

#25
select c.customer_name, sum(p.price*oi.quantity) as Amt from customers c
left join orders o using(customer_id)
left join order_items oi using(order_id)
left join products p using(product_id)
group by customer_id
order by Amt desc 
limit 3;

#26
select c.customer_name, o.order_id, count(distinct oi.product_id) as `No. of Products` from customers c
left join orders o using(customer_id)
left join order_items oi using(order_id)
group by c.customer_id, o.order_id
having `No. of Products` > 1;

#27
select product_name, sum(oi.quantity) as `Quantity Ordered` from products p
left join order_items oi using(product_id)
group by p.product_id
having `Quantity Ordered` is null;

select product_name from products p
left join order_items oi using(product_id)
group by p.product_id
having sum(oi.quantity) is null;

#28
select o.order_id, count(oi.product_id) as `No. of Products` from orders o
left join order_items oi using(order_id)
group by o.order_id
having `No. of Products` > 1;

#29
select o.order_id, o.customer_id
from orders o
left join customers c using(customer_id)
where c.customer_id is null;

select oi.order_id, oi.product_id
from order_items oi
left join orders o using(order_id)
where o.order_id is null;

select oi.order_id, oi.product_id
from order_items oi
left join products p using(product_id)
where p.product_id is null;

#30
select * from customers c
inner join orders using(customer_id);
# Doesn't print the details for customer with no order.

select * from customers c
left join orders using(customer_id);
# Print's the details for customer with no order as well.