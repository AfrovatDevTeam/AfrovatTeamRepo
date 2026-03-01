--Create table actors
	CREATE TABLE actors (  
	    actor_id INT PRIMARY KEY,  
	    actor_name VARCHAR(100),  
	    movie_id INT  
	);  

---Insert data into actors
	INSERT INTO actors (actor_id, actor_name, movie_id) VALUES  
	(1, 'Vin Diesel', 301),  
	(2, 'Marilyn Monroe', 302),  
	(3, 'Alvaro Morte', 303),  
	(4, 'Rose DeWitt', 304),  
	(5, 'Halle Berry', 306);  
-----------------
Select* from actors
	CREATE TABLE movies (  
	    movie_id INT PRIMARY KEY,  
	    movie_title VARCHAR(100)  
	);  

	INSERT INTO movies (movie_id, movie_title) VALUES  
	(301, 'Fast and Furious'),  
	(302, 'Blonde'),  
	(303, 'Money Heist'),  
	(304, 'Titanic'),  
	(305, 'John Wick');
	Select* from movies;

--query that perform a join operation 
Select actors.actor_name,movies.movie_title
From actors
Join movies
ON actors.movie_id = movies.movie_id;

Table 1: Employee

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age > 0)
);

INSERT INTO Employee (emp_id, name, age) VALUES
(1, 'Akhona', 30),
(2, 'Leasha', 25),
(3, 'Jennifer', 28),
(4, 'Refiloe', 35),
(5, 'Mbulelo', 40),
(6, 'Josepht', 29),
(7, 'Thabiso', 33);

-- Table 2: Departments
CREATE TABLE Departments 
(
    dept_id INT PRIMARY KEY,
    emp_id INT,
    department_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

INSERT INTO Departments (dept_id, emp_id, department_name) VALUES
(101, 1, 'HR'),
(102, 3, 'Sales'),
(103, 4, 'Marketing'),
(104, 6, 'IT'),
(105, 7, 'Finance');

---QUERY FOR INNER JOIN

SELECT 
Employee.emp_id,
Employee.name,
Departments.department_name
from Employee
INNER JOIN Departments
on Employee.emp_id = Departments.emp_id;

--LEFT JOIN 
-- Table 1: Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

INSERT INTO Customers (customer_id, name) VALUES
(1, 'Lolo'),
(2, 'Mpho'),
(3, 'Keketso');

-- Table 2: Orders
CREATE TABLE Orders 
(
    order_id INT PRIMARY KEY,
    customer_id INT,
    product VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders (order_id, customer_id, product) VALUES
(101, 1, 'Laptop'),
(102, 2, 'Smartphone');

--QUERY FOR LEFT JOIN 

Select 
Customers.customer_id,Customers.name,Orders.order_id,Orders.product
From Customers
LEFT JOIN Orders
ON Customers.customer_id =Orders.customer_id;

---Query for right Join ---

-- Table 1: Departments
CREATE TABLE Departments1
(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

INSERT INTO Departments1(department_id, department_name) VALUES
(101, 'HR'),
(102, 'IT'),
(103, 'Marketing');

-- Table 2: Employees2
CREATE TABLE Employees2 
(
    employee_id INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments1(department_id)
);

INSERT INTO Employees2 (employee_id, name, department_id) VALUES
(1, 'Kabo', 101),
(2, 'Emma', 102);

--QUERY TO PERFORM RIGHT JOIN --

Select
Employees2.Name,Employees2.department_id,Departments1.department_name
From Employees2
RIGHT JOIN Departments1
On Employees2.department_id = Departments1.department_id;

-- Table 1: Sales
CREATE TABLE Sales 
(
    sale_id INT PRIMARY KEY,
    customer_id INT,
    sale_amount DECIMAL(10,2) NOT NULL,
    sale_date DATE NOT NULL
);

INSERT INTO Sales (sale_id, customer_id, sale_amount, sale_date) VALUES
(1001, 201, 500.00, '2025-01-10'),
(1002, 202, 1200.00, '2025-01-11'),
(1003, 203, 300.00, '2025-01-12'),
(1004, 205, 450.00, '2025-01-13');

-- Table 2: Customer Feedback
CREATE TABLE Customer_Feedback 
(
    feedback_id INT PRIMARY KEY,
    customer_id INT,
    feedback_score INT CHECK (feedback_score BETWEEN 1 AND 5),
    feedback_date DATE NOT NULL
);

INSERT INTO Customer_Feedback (feedback_id, customer_id, feedback_score, feedback_date) VALUES
(501, 202, 4, '2025-01-14'),
(502, 203, 5, '2025-01-15'),
(503, 204, 3, '2025-01-16');

--QUERY TO PERFORM FULL JOIN--
SELECT 
Sales.customer_id,
Sales.sale_amount,
Sales.sale_date,
Customer_Feedback.feedback_score,
Customer_Feedback.feedback_date
FROM
Sales
FULL JOIN Customer_Feedback
ON Sales.customer_id = Customer_Feedback.customer_id;

-- Table: Employees
CREATE TABLE Employees3 (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    manager_id INT,
    CONSTRAINT FK_Employees_Manager
        FOREIGN KEY (manager_id) REFERENCES Employees3(emp_id)
);

INSERT INTO Employees3(emp_id, name, manager_id) VALUES
(1, 'Smanga', NULL),  -- top-level manager
(2, 'Thabile', 1),      -- reports to Smanga
(3, 'Ben', 1),        -- reports to Smanga
(4, 'Keletso', 2);      -- reports to Thabile

SELECT 
    e.name AS employee,
    m.name AS manager
FROM Employees3 AS e
LEFT JOIN Employees3 AS m
ON e.manager_id = m.emp_id;



-- Table 1: Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);

INSERT INTO Products (product_id, product_name) VALUES
(1, 'Laptop'),
(2, 'Smartphone'),
(3, 'Headphones'),
(4, 'Smartwatch');

-- Table 2: Stores
CREATE TABLE Stores (
    store_id INT PRIMARY KEY,
    store_location VARCHAR(50) NOT NULL
);

INSERT INTO Stores (store_id, store_location) VALUES
(101, 'Kempton Park'),
(102, 'Midrand'),
(103, 'Thembisa');

--QUERY FOR PERFORMING CROSS JOIN--
Select 
P.product_name,
s.store_location
From 
Products p
CROSS JOIN 
STores s;