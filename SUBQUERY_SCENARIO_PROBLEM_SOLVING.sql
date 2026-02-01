create database subqueriesProblem;
use subqueriesproblem;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    loyalty_points INT
);
INSERT INTO CUSTOMERS VALUES(5,'ROHAN','MUMBAI',450);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers VALUES
(1,'Alice','Delhi',1200),
(2,'Bob','Mumbai',800),
(3,'Charlie','Delhi',1500),
(4,'Diana','Pune',400);

INSERT INTO Orders VALUES
(101,1,'2025-01-10',5000),
(102,1,'2025-02-15',3000),
(103,2,'2025-02-01',2000),
(104,3,'2025-03-20',7000),
(105,4,'2025-01-25',1000);

select * from orders;
select * from customers;

-- 1.List customers whose total order_amount is greater than the average order_amount of all orders.
SELECT
	CUSTOMER_NAME
FROM 
	CUSTOMERS 
WHERE CUSTOMER_ID 
IN 
	(SELECT
		CUSTOMER_ID
	FROM ORDERS 
	WHERE ORDER_AMOUNT>
		(SELECT
			AVG(ORDER_AMOUNT)
		FROM ORDERS));
        
-- NESTING OF CTE
WITH AVG_ORDER_AMOUNT AS 
(
	SELECT 
		AVG(ORDER_AMOUNT) AVG_AMOUNT
	FROM ORDERS
),
CUSTOMERID_HIGHER_THAN_AVG AS
(
	SELECT
		CUSTOMER_ID
	FROM ORDERS 
    WHERE ORDER_AMOUNT > (SELECT AVG_AMOUNT FROM AVG_ORDER_AMOUNT)
    
)
-- MAIN QUERY
SELECT
	CUSTOMER_NAME
FROM CUSTOMERS
WHERE CUSTOMER_ID IN 
(SELECT CUSTOMER_ID FROM CUSTOMERID_HIGHER_THAN_AVG);


   
SELECT
	C.CUSTOMER_NAME
FROM ORDERS O 
INNER JOIN CUSTOMERS C
ON O.CUSTOMER_ID = C.CUSTOMER_ID
	WHERE ORDER_AMOUNT>
		(SELECT
			AVG(ORDER_AMOUNT)
		FROM ORDERS);
        
        
-- 2.Find customers in Delhi who have placed at least one order above 4000.
SELECT
	CUSTOMER_NAME,
    CITY
FROM CUSTOMERS
WHERE CUSTOMER_ID IN
	(SELECT
		DISTINCT CUSTOMER_ID
	FROM ORDERS 
	WHERE ORDER_AMOUNT > 4000 )
 AND CITY = 'DELHI'   ;
 
 
 
 
 SELECT
	CUSTOMER_NAME,
    CITY
FROM CUSTOMERS
WHERE (CUSTOMER_ID,CITY) IN
	(SELECT
		DISTINCT O.CUSTOMER_ID,
        C.CITY
	FROM ORDERS O INNER JOIN CUSTOMERS C
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
	WHERE O.ORDER_AMOUNT > 4000 AND C.CITY='DELHI');
    
    
-- 3.Display orders that have an amount greater than the maximum order placed by customer_id 2.
SELECT
	ORDER_ID,
    ORDER_AMOUNT
FROM ORDERS
WHERE ORDER_AMOUNT>
	(SELECT
		MAX(T.ORDER_AMOUNT) AS MAX_AMOUNT
	FROM 
		(SELECT
			ORDER_AMOUNT
		FROM ORDERS 
		WHERE CUSTOMER_ID = 1)T);
 
 
 
 -- 4.Show customer_name and total spent for customers whose total spent is in the top 2 totals.
 
SELECT
	T.CUSTOMER_ID,
    C.CUSTOMER_NAME,
    T.SPENDING
FROM CUSTOMERS C INNER JOIN
	(SELECT
		CUSTOMER_ID,
		SUM(ORDER_AMOUNT) SPENDING
	FROM ORDERS
	GROUP BY CUSTOMER_ID)T
ON C.CUSTOMER_ID = T.CUSTOMER_ID
ORDER BY T.SPENDING DESC
LIMIT 2;
 
 
-- 5.Find customers who have never placed an order (using a subquery on Orders).
SELECT
	CUSTOMER_NAME
FROM CUSTOMERS
WHERE CUSTOMER_ID 
NOT IN
	(SELECT
		DISTINCT CUSTOMER_ID
	FROM ORDERS);
    
-- 6.List customers whose loyalty_points are above the average loyalty_points of customers who are from Delhi only.
SELECT 
	CUSTOMER_NAME,
    LOYALTY_POINTS
FROM CUSTOMERS
WHERE LOYALTY_POINTS>
	(SELECT
		AVG(LOYALTY_POINTS)
	FROM CUSTOMERS)
AND CITY ='DELHI';


-- CTE (Common Table expression)
-- Temporary named result set (virtual table), that can be used multiple times within you query to simplyfy and organize complex query.

-- Difference between CTE and subquery
-- Subquery works bottom to top , however CTE works top to bottom

-- Total spending by Customer.
-- MULTIPLE CTE
WITH TOTAL_SPENDING AS
(
	SELECT
		C.CUSTOMER_ID,
        C.CUSTOMER_NAME,
        SUM(O.ORDER_AMOUNT) AS SPENDING
	FROM ORDERS O INNER JOIN CUSTOMERS C 
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID
),
AVG_SALE AS (
	SELECT
		AVG(ORDER_AMOUNT) AVG_AMOUNT
	FROM ORDERS
)
-- MAIN QUERY
SELECT 
	C.CUSTOMER_ID,
    CTE.CUSTOMER_NAME,
    CTE.SPENDING
FROM CUSTOMERS C 
INNER JOIN TOTAL_SPENDING CTE 
ON CTE.CUSTOMER_ID = C.CUSTOMER_ID;


-- SINGLE CTE
-- use cte multiple time
-- top 1 customer per city

WITH CUSTOMERSALES AS (
	SELECT 
		C.CUSTOMER_ID,
        C.CUSTOMER_NAME,
        C.CITY,
        SUM(O.ORDER_AMOUNT) AS TOTAL_AMOUNT
	FROM CUSTOMERS C
    INNER JOIN ORDERS O 
		ON C.CUSTOMER_ID = O.CUSTOMER_ID
	GROUP BY C.CUSTOMER_ID,C.CUSTOMER_NAME, C.CITY    
)

-- MAIN QUERY
SELECT 
	* 
FROM CUSTOMERSALES CS -- FIRST USE
	WHERE CS.TOTAL_AMOUNT = 
(
	SELECT MAX(TOTAL_AMOUNT)
	FROM CUSTOMERSALES -- SECOND USE
	WHERE CITY = CS.CITY);


