
-- ---------------------------------------------
-- PostgreSQL Assignment 
-- Purpose: Table Creation, Data Insertion, and Queries
-- ---------------------------------------------

-- Create Books Table
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) check (price >= 0),
    stock INT DEFAULT 0,
    published_year INT
);


-- Insert Sample Data into Books Table
INSERT INTO books (title, author, price, stock, published_year)
VALUES
('The Alchemist', 'Paulo Coelho', 12.99, 10, 1988),
('To Kill a Mockingbird', 'Harper Lee', 15.50, 8, 1960),
('1984', 'George Orwell', 14.25, 12, 1949),
('Pride and Prejudice', 'Jane Austen', 10.00, 5, 1813),
('The Great Gatsby', 'F. Scott Fitzgerald', 13.75, 7, 1925),
('The Catcher in the Rye', 'J.D. Salinger', 11.80, 6, 1951),
('Brave New World', 'Aldous Huxley', 16.00, 9, 1932),
('The Hobbit', 'J.R.R. Tolkien', 18.99, 11, 1937),
('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 20.00, 15, 1997),
('The Road', 'Cormac McCarthy', 17.50, 4, 2006);


-- Create Customers Table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(40) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);


-- Insert Sample Data into Customers Table
INSERT INTO customers (name, email)
VALUES
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com'),
('Michael Johnson', 'michael.johnson@example.com'),
('Emily Brown', 'emily.brown@example.com'),
('David Wilson', 'david.wilson@example.com'),
('Sophia Martinez', 'sophia.martinez@example.com'),
('Daniel Taylor', 'daniel.taylor@example.com'),
('Olivia Anderson', 'olivia.anderson@example.com'),
('James Thomas', 'james.thomas@example.com'),
('Mia Jackson', 'mia.jackson@example.com');


-- Create Orders Table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    book_id INT REFERENCES books(id),
    quantity INT CHECK (quantity > 0),
    order_date DATE DEFAULT CURRENT_DATE
);


-- Insert Sample Data into Orders Table
INSERT INTO orders (customer_id, book_id, quantity)
VALUES
(1, 3, 2),
(2, 5, 1),
(3, 2, 4),
(4, 7, 1),
(5, 1, 3),
(6, 6, 2),
(7, 4, 1),
(8, 9, 5);

-- ---------------------------------------------------
-- PostgreSQL Problems QUERIES WITH COMMENTS
-- ---------------------------------------------------

-- 1️⃣ Find books that are out of stock.
-- Purpose: Show books where stock is 0
SELECT title FROM books
    WHERE stock = 0;


-- 2️⃣ Retrieve the most expensive book in the store.
-- Purpose: Find most expensive book
SELECT * FROM books ORDER BY price DESC LIMIT 1;


-- 3️⃣ Find the total number of orders placed by each customer.
-- Purpose: Count number of orders by each customer
SELECT name,count(orders.id) AS total_orders FROM customers 
    LEFT JOIN orders ON  orders.customer_id = customers.id
    GROUP BY name 
    ORDER BY total_orders DESC;


-- 4️⃣ Calculate the total revenue generated from book sales.
-- Purpose: Multiply quantity * book price and sum all
SELECT sum(price * quantity) AS total_revenue
 FROM orders
    INNER JOIN books on orders.book_id = books.id;


-- 5️⃣ List all customers who have placed more than one order.
-- Purpose: Filter only those who ordered more than once
SELECT name, COUNT(orders.id) AS orders_count FROM customers
    LEFT JOIN orders ON 
    customers.id = orders.customer_id 
    GROUP BY name 
    HAVING COUNT(orders.id) > 1;


-- 6️⃣ Find the average price of books in the store.
-- Purpose: Show average price
SELECT ROUND(avg(price),2) AS avg_book_price 
    FROM books;


-- 7️⃣ Increase the price of all books published before 2000 by 10%.
-- Purpose: Conditional price update
UPDATE books
    SET price  = ROUND(price * 1.10, 2)
    WHERE published_year < 2000;


-- 8️⃣ Delete customers who haven't placed any orders.
-- Purpose: Remove customers who are inactive
DELETE FROM customers
    WHERE id NOT IN (
        SELECT DISTINCT customer_id FROM orders
    );

