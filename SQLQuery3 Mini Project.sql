CREATE TABLE Customers ( 
customer_id INT PRIMARY KEY, 
customer_name VARCHAR(50), 
city VARCHAR(50) 
); 

Insert into Customers values 
(1,'Ushanka','Johannesburg'),
(2,'Katleho','Durban'),
(3,'Priya','Johannesburg'),
(4,'Mbulelo','Pretoria'),
(5,'Yasfeer','Durban'),
(6,'Fatima','Pretoria'),
(7,'Khumo','Cape Town'),
(8,'Thabo','Johannesburg'),
(9,'sidd','Durban'),
(10,'Kiasha','Pretoria'),
(11,'Kyle','Cape Town'),
(12,'Shanelda','Cape Town'),
(13,'Refiloe','Durban'),
(14,'Jennifer','Johannesburg'),
(15,'Daniel','Durban');

CREATE TABLE Branches ( 
branch_id INT PRIMARY KEY, 
branch_name VARCHAR(50), 
city VARCHAR(50) 
); 
Insert INTO Branches Values 
(101,'Durban Central','Durban'),
(102,'Sandton','Johannesburg'),
(103,'Menlyn','Pretoria'),
(104,'Canal Walk','Cape Town');


CREATE TABLE Accounts2 ( 
account_id INT PRIMARY KEY, 
customer_id INT, 
branch_id INT, 
account_type VARCHAR(20), 
balance DECIMAL(12,2), 
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id), 
FOREIGN KEY (branch_id) REFERENCES Branches(branch_id) 
); 
Insert INTO Accounts2 Values 
(301,1,102,'Savings',12000),
(302,2,101,'Cheque',10000),
(303,3,102,'Savings',11000),
(304,4,103,'Cheque',18000),
(305,5,101,'Savings',14000),
(306,6,103,'Savings',12000),
(307,7,104,'Savings',5000),
(308,8,102,'Cheque',9000),
(309,9,101,'Savings',10000),
(310,10,103,'Cheque',17000),
(311,11,104,'Savings',8000),
(312,12,104,'Cheque',9500),
(313,13,101,'Savings',6500),
(314,14,102,'Cheque',19000),
(315,15,101,'Cheque',20000);

CREATE TABLE Transactions1 ( 
transaction_id INT PRIMARY KEY, 
account_id INT, 
transaction_date DATE, 
transaction_type VARCHAR(20), 
amount DECIMAL(12,2), 
FOREIGN KEY (account_id) REFERENCES Accounts2(account_id) 
); 

INSERT INTO Transactions1 VALUES
(1,301,'2025-01-01','Deposit',2000),
(2,302,'2025-01-05','Withdrawal',500),
(3,303,'2025-01-03','Deposit',3000),
(4,304,'2025-01-07','Deposit',4000),
(5,305,'2025-01-10','Withdrawal',1000),
(6,306,'2025-01-02','Deposit',5000),
(7,307,'2025-01-08','Deposit',1500),
(8,308,'2025-01-06','Withdrawal',800),
(9,309,'2025-01-04','Deposit',1200),
(10,310,'2025-01-09','Deposit',2000),
(11,311,'2025-01-03','Deposit',1000),
(12,312,'2025-01-05','Withdrawal',500),
(13,313,'2025-01-07','Deposit',3000),
(14,314,'2025-01-08','Deposit',2500),
(15,315,'2025-01-09','Withdrawal',700);

CREATE TABLE Loans ( 
loan_id INT PRIMARY KEY, 
customer_id INT, 
loan_amount DECIMAL(12,2), 
interest_rate DECIMAL(5,2), 
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) 
); 
INSERT INTO Loans VALUES
(201,2,50000,8.5),
(202,3,12000,9.1),
(203,7,20000,10.2),
(204,8,75000,8.9),
(205,9,60000,7.8),
(206,11,40000,9.5),
(207,13,15000,8.0);

--Part 2 Task 1--
Select 
c.customer_name,a.account_type,a.balance
From Customers c
Inner Join Accounts2 a
ON c.customer_id = a.customer_id;

--Task 2--
SELECT c.customer_name
FROM Customers c
LEFT JOIN Loans l
ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;

--TASK 3--
Select b .branch_name, 
SUM(a.balance)AS total_balance 
From Branches b
LEFT JOIN Accounts2 a
ON b .branch_id = a .branch_id
Group by b .branch_name;

--TASK 4--
SELECT a. Customer_name AS Customer1,
       b. customer_name AS Customer2,
	   a. City 
From Customers a
INNER Join Customers b
ON a .city = b .city
AND a .customer_id = b .customer_id;

--TASK 5--
SELECT customer_id, loan_amount,
CASE
    WHEN loan_amount < 50000 THEN 'Low Risk'
    WHEN loan_amount BETWEEN 50000 AND 90000 THEN 'Medium Risk'
    ELSE 'High Risk'
END AS Risk_Level
FROM Loans;

--Task 6--
SELECT b.branch_name
FROM Accounts2 a
RIGHT JOIN Branches b
ON a.branch_id = b.branch_id
WHERE a.account_id IS NULL;

--TASK 7 --
SELECT 
    c.customer_name,
    a.account_id,
  (t.transaction_id) 
FROM Accounts a
INNER JOIN Customers c
    ON a.customer_id = c.customer_id
INNER JOIN Transactions t
    ON a.account_id = t.account_id

