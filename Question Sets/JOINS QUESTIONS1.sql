CREATE DATABASE JOIN_QUESTIONS;
USE JOIN_QUESTIONS;

-- SCENARIO 1 — E-Commerce Orders & Customers
-- You work for a shopping platform. You need to analyze customers, orders, and which 
-- customers haven't ordered yet.
-- CREATE TABLES
CREATE TABLE customers (
 customer_id INT PRIMARY KEY,
 customer_name VARCHAR(50),
 city VARCHAR(50)
);
CREATE TABLE orders (
 order_id INT PRIMARY KEY,
 customer_id INT,
 order_date DATE,
 amount DECIMAL(10,2),
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- INSERT DATA
INSERT INTO customers VALUES
(1, 'Amit', 'Delhi'),
(2, 'Priya', 'Mumbai'),
(3, 'Rohit', 'Bangalore'),
(4, 'Neha', 'Delhi'),
(5, 'Kunal', 'Chennai');
INSERT INTO orders VALUES
(101, 1, '2025-01-10', 1200.50),
(102, 3, '2025-01-12', 450.00),
(103, 3, '2025-01-14', 780.25),
(104, 1, '2025-01-16', 999.00),
(105, 2, '2025-01-18', 650.00);


-- READ DATA
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMERS;
-- JOIN QUESTIONS
-- 1. List all customers with their orders (including customers with no orders).
SELECT 
	*
FROM CUSTOMERS C
LEFT JOIN ORDERS O 
ON C.CUSTOMER_ID = O.CUSTOMER_ID;
-- 2. Show customers who never placed any order.
SELECT 
	C.CUSTOMER_NAME,
    C.CITY
FROM CUSTOMERS C
LEFT JOIN ORDERS O 
ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE O.ORDER_ID IS NULL;
-- 3. Show total amount spent by each customer.
SELECT 
	C.CUSTOMER_NAME,
    SUM(O.AMOUNT) AS SPENDING
FROM CUSTOMERS C
LEFT JOIN ORDERS O 
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_NAME
HAVING SPENDING IS NOT NULL
ORDER BY SPENDING;

-- 4. Get details of orders placed by customers from Delhi.
SELECT 
	C.CUSTOMER_NAME,
    C.CITY,
    O.AMOUNT,
    O.ORDER_DATE
FROM CUSTOMERS C
LEFT JOIN ORDERS O 
ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE C.CITY = "DELHI"
AND O.ORDER_ID IS NOT NULL;

-- 5. Show customer name, order date, and order amount — sorted by highest order value.

SELECT 
	C.CUSTOMER_NAME,
    C.CITY,
    O.AMOUNT,
    O.ORDER_DATE
FROM CUSTOMERS C
LEFT JOIN ORDERS O 
ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE O.ORDER_ID IS NOT NULL
ORDER BY O.AMOUNT DESC;