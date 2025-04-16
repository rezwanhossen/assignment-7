-- Active: 1744445953993@@127.0.0.1@5432@bookstore_db@public

-- create books table
CREATE TABLE books(
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    price NUMERIC(6,2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    published_year int NOT NULL
)
-- insert data in books table

INSERT INTO books (title, author, price, stock, published_year) VALUES
('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
('You Don /Know JS', 'Kyle Simpson', 30.00, 8, 2014),
('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

-- SELECT * FROM books


-- creat customers table
CREATE TABLE customers (
    customers_id SERIAL PRIMARY KEY,
    customers_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    joined_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- insert data in customers table
INSERT INTO customers (customers_id, customers_name, email, joined_date) VALUES
(1, 'Alice', 'alice@email.com', '2023-01-10'),
(2, 'Bob', 'bob@email.com', '2022-05-15'),
(3, 'Charlie', 'charlie@email.com', '2023-06-20');

-- SELECT * FROM customers;
-- creat orders table

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customers_id),
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    order_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- insert data on orders table
INSERT INTO orders (order_id, customer_id, book_id, quantity, order_date) VALUES
(1, 1, 2, 1, '2024-03-10'),
(2, 2, 1, 1, '2024-02-20'),
(3, 1, 3, 2, '2024-03-05');


SELECT * FROM orders;
 SELECT * FROM books;
 SELECT * FROM customers;

--PostgreSQL Problems & Sample Outputs
 
-- 1. Find books that are out of stock.
SELECT title FROM books
    WHERE stock=0;

-- 2. Retrieve the most expensive book in the store.

SELECT * FROM books
 ORDER BY price DESC
 LIMIT 1;


-- 3. Find the total number of orders placed by each customer.

SELECT customers_name , count(o.order_id) as t_order FROM customers as c
JOIN orders as o ON c.customers_id=o.customer_id 
GROUP BY customers_name;

-- 4. Calculate the total revenue generated from book sales.

SELECT sum(b.price * o.quantity) as total_revenue  FROM orders as o
join books as b on b.book_id= o.book_id;

-- 5. List all customers who have placed more than one order.
SELECT customers_name,count(*) FROM customers as c
join orders as o on o.customer_id=c.customers_id
GROUP BY customers_name
HAVING count(o.quantity)>1;

-- 6. Find the average price of books in the store.
SELECT round(avg(price),2) as avg_book_price FROM books;

-- 7. Increase the price of all books published before 2000 by 10%.
UPDATE books
SET price = price * 1.10
WHERE published_year < 2000;

-- 8. Delete customers who haven't placed any orders.
DELETE FROM customers
WHERE customers_id not in (SELECT customer_id FROM orders)