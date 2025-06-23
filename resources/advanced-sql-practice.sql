create table customers (
 id int primary key auto_increment,
 first_name varchar(50),
 last_name varchar(50)
);

create table orders (
 id int primary key,
 customer_id int null,
 order_date date,
 total_amount decimal(10, 2),
 foreign key (customer_id) references customers(id)
);

insert into customers (id, first_name, last_name) values
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Smith'),
(4, 'Bob', 'Brown');

insert into orders (id, customer_id, order_date, total_amount) values
(1, 1,'2023-01-01', 100.00),
(2, 1, '2023-02-01', 150.00),
(3, 2, '2023-01-01', 200.00),
(4, 3, '2023-04-01', 250.00),
(5, 3, '2023-04-01', 300.00),
(6, NULL, '2023-04-01', 100.00);

SELECT * FROM customers;

SELECT * FROM orders;

-- query will return total amount spent by each customer.
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- will return set the shows total ammount spent on each order DATE.
SELECT customer_id, order_date, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id, order_date;

-- will return a result set that shows the total amount spent by each customer, but will only include customers who have spent more than $200 in total.
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 200;

-- will return a result set that shows all the orders, but will also include the customer's first and last name.
-- The INNER JOIN clause specifies that we want to join the orders table with the customers table on the customer_id column
-- in the orders table and the id column in the customers table.
SELECT orders.id, customers.first_name, customers.last_name, orders.order_date, orders.total_amount
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id;

-- includes all the rows from the first table, even if there is no matching row in the second table.
--  A LEFT JOIN is useful when you want to include all the rows from the first table, even if there is no matching row in the second table.
--  This is a common scenario when you want to include optional data from another table.
SELECT orders.id, customers.first_name, customers.last_name, orders.order_date, orders.total_amount
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.id;

-- Scalar Subqueries will return all orders where the total_amount is greater than or equal to the average total_amount of all orders.
-- The subquery (SELECT AVG(total_amount) FROM orders) calculates the average total_amount of all orders, and the main query filters
-- the results to only include orders where the total_amount is greater than or equal to the average.
SELECT id, order_date, total_amount
FROM orders
WHERE total_amount >= (SELECT AVG(total_amount) FROM orders);

-- will return all orders where the customer_id is in the list of id values of customers with the last name 'Smith'.
-- The subquery (SELECT id FROM customers WHERE last_name = 'Smith') returns a list of id values of customers with the last name
-- 'Smith', and the main query filters the results to only include orders where the customer_id is in that list.
SELECT id, order_date, total_amount, customer_id
FROM orders
WHERE customer_id IN (SELECT id FROM customers WHERE last_name = 'Smith');

-- will return all the order_date values from the orders table.  The subquery (SELECT id, order_date, total_amount FROM orders) returns all
-- the columns from the orders table, and the main query selects only the order_date column from the subquery.
SELECT order_date
FROM (SELECT id, order_date, total_amount FROM orders) AS order_summary;

-- You will:
-- ● Use JOIN statements to combine data from multiple tables
-- ● Write GROUP BY queries with aggregate functions like SUM and COUNT
-- ● Apply WHERE and HAVING clauses to filter data
-- ● Practice using SubQueries to create dynamic filters


-- Using INNER JOIN to display orders, customer last name, date of purchase and total spent
SELECT orders.id, customers.last_name, orders.order_date, orders.total_amount
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id;

-- includes the information of NULL
SELECT orders.id, customers.last_name, orders.order_date, orders.total_amount
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.id;

-- GROUP BY, This is often used with aggregate functions like COUNT, SUM, AVG, MAX, and MIN that create a
-- calculated field that combines values from the grouped rows into a single value.
SELECT customer_id, COUNT(customer_id) AS customer_count
FROM orders
GROUP BY customer_id;

-- HAVING it is applied after the GROUP BY clause to filter aggregate columns. This means that it will filter
-- the rows after the aggregation takes place. This only shows the customers that placed 2 or more orders.
SELECT customer_id, COUNT(customer_id) AS customer_count
FROM orders
GROUP BY customer_id
HAVING customer_count > 2;


-- WHERE is used before GROUP BY, and aggregation functions like COUNT or SUM. This query will show any orders past the given date.
SELECT customer_id, COUNT(*) AS order_count
FROM orders
WHERE order_date > '2023-02-01'
GROUP BY customer_id;

-- Scalar Subqueries return a single value (a single row with a single column)typically within SELECT lists or WHERE clauses.
-- shows the total ammount that is larger than the given min amount of 250.
SELECT id, order_date, total_amount
FROM orders
WHERE total_amount >= (SELECT MIN(250) FROM orders);

-- Column Subqueries, Shows select amount of cloumns I wanted to show. query will show the id order date and customer id that is from specified date.
SELECT id, order_date, customer_id
FROM orders
WHERE customer_id IN (SELECT id FROM customers WHERE order_date = '2023-04-01');

-- Table Subqueries, This query will return all the total_amount values from the orders table.
-- The subquery (SELECT id, order_date, total_amount FROM orders) returns all the columns from the orders table,
-- and the main query selects only the total_amount column from the subquery.
SELECT total_amount
FROM (SELECT id, order_date, total_amount FROM orders) AS order_summary;