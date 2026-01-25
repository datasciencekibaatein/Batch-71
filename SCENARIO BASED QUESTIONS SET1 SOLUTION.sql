create database problemsolving;
use problemsolving;
CREATE TABLE department (
 dept_id INT PRIMARY KEY,
 dept_name VARCHAR(100)
);
CREATE TABLE employee (
 emp_id INT PRIMARY KEY,
 emp_name VARCHAR(100),
 salary INT,
 dept_id INT,
 FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);
INSERT INTO department VALUES
(10, 'HR'),
(20, 'Sales'),
(30, 'IT'),
(40, 'Finance');
INSERT INTO employee VALUES
(1, 'Amit', 50000, 10),
(2, 'Rohan', 60000, 20),
(3, 'Neha', 45000, 20),
(4, 'Sneha', 80000, 30),
(5, 'Manish', 40000, NULL);

select * from employee;

select * from department;
-- Q1: Fetch employees with their department names
SELECT
	E.EMP_NAME,
    D.DEPT_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D
ON E.DEPT_ID = D.DEPT_ID;

-- Q2: Fetch all employees and department names (even if dept not assigned)
SELECT
	E.EMP_NAME,
    D.DEPT_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D
ON E.DEPT_ID = D.DEPT_ID;

-- Q3: Find departments with NO employees
SELECT
    D.DEPT_NAME
FROM EMPLOYEE E
RIGHT JOIN DEPARTMENT D
ON E.DEPT_ID = D.DEPT_ID 
WHERE EMP_ID IS NULL;


-- Scenario 2: Customers & Orders
CREATE TABLE customers (
 cust_id INT PRIMARY KEY,
 cust_name VARCHAR(100),
 city VARCHAR(100)
);
CREATE TABLE orders (
 order_id INT PRIMARY KEY,
 cust_id INT,
 amount DECIMAL(10,2),
 order_date DATE,
 FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
);
INSERT INTO customers VALUES
(101, 'Dhruv', 'Delhi'),
(102, 'Rahul', 'Pune'),
(103, 'Meena', 'Delhi'),
(104, 'Sonia', 'Mumbai');
INSERT INTO orders VALUES
(1, 101, 500, '2025-01-01'),
(2, 101, 1200, '2025-01-03'),
(3, 103, 450, '2025-01-05');
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
-- Q4: Fetch all customers who placed orders
SELECT 
	O.CUST_ID,
    C.CUST_NAME,
    O.AMOUNT,
    O.ORDER_DATE
FROM ORDERS O 
INNER JOIN CUSTOMERS C
ON O.CUST_ID = C.CUST_ID;
-- Q5: Fetch customers who have NOT placed any order
SELECT 
    C.CUST_NAME
FROM ORDERS O 
RIGHT JOIN CUSTOMERS C
ON O.CUST_ID = C.CUST_ID 
WHERE O.ORDER_ID IS NULL;
-- Q6: Fetch total spending of each customer
SELECT 
    C.CUST_NAME,
    SUM(O.AMOUNT) AS SPENDING
FROM ORDERS O 
INNER JOIN CUSTOMERS C
ON O.CUST_ID = C.CUST_ID
GROUP BY C.CUST_NAME;


-- --------------------------------------------------------
CREATE TABLE departments (
 dept_id INT PRIMARY KEY,
 dept_name VARCHAR(50),
 location VARCHAR(50)
);
CREATE TABLE employees (
 emp_id INT PRIMARY KEY,
 emp_name VARCHAR(50),
 dept_id INT,
 salary INT,
 hire_date DATE,
 manager_id INT,
 FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
CREATE TABLE customers (
 customer_id INT PRIMARY KEY,
 customer_name VARCHAR(50),
 city VARCHAR(50),
 signup_date DATE
);
CREATE TABLE orders (
 order_id INT PRIMARY KEY,
 customer_id INT,
 order_date DATE,
 order_amount INT,
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- Insert Sample Data
INSERT INTO departments VALUES
(1, 'HR', 'Mumbai'),
(2, 'IT', 'Bangalore'),
(3, 'Finance', 'Delhi');
INSERT INTO employees VALUES
(101, 'Amit', 1, 40000, '2018-05-10', NULL),
(102, 'Neha', 1, 35000, '2019-03-15', 101),
(103, 'Raj', 2, 70000, '2017-07-01', NULL),
(104, 'Sneha', 2, 65000, '2020-08-21', 103),
(105, 'Karan', 3, 50000, '2016-01-11', NULL),
(106, 'Pooja', 3, 45000, '2021-09-05', 105);
INSERT INTO customers VALUES
(1, 'Rohit', 'Mumbai', '2022-01-10'),
(2, 'Anjali', 'Delhi', '2021-11-20'),
(3, 'Suresh', 'Bangalore', '2023-02-15'),
(4, 'Meena', 'Mumbai', '2022-06-18');
INSERT INTO orders VALUES
(201, 1, '2023-01-05', 12000),
(202, 1, '2023-03-12', 18000),
(203, 2, '2022-12-25', 22000),
(204, 3, '2023-04-10', 8000);


select 
	dept.dept_name,
	dept.dept_id,
    avg(emp.salary) as dept_avg_salary
from employees emp
inner join departments dept
on emp.dept_id = dept.dept_id
group by dept.dept_id
having avg(emp.salary) > (select avg(salary) from employees);



-- ----------------------
select 
	emp_name,
    dept_id,
    salary,
    hire_date
    from employees emp
    where salary <(
select 
	avg(salary)
from employees
where dept_id = emp.dept_id and hire_date <= date_sub(curdate(), interval 5 year));

