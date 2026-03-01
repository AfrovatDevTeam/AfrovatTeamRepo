Create table Customers1 (
customer_id int primary key,
customer_name Varchar(50),
city Varchar(50)
);

insert into Customers1 values 
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

Create table Branches1 (
branch_id int primary key,
branch_name Varchar(50),
city Varchar(50),
);

Insert INTO Branches1 Values 
(101,'Gateway','Durban'),
(102,'Rosebank','Johannesburg'),
(103,'Sunnypark','Pretoria'),
(104,'Sea point','Cape Town');



Create table Accounts1 (
account_id int primary key,
customer_id int,
branch_id int,
account_type Varchar(20),
balance Decimal(12,2),
FOREIGN KEY (customer_id) REFERENCES Customers1(customer_id),
FOREIGN KEY (branch_id) REFERENCES BRANCHES1 (branch_id)
);

Insert INTO Accounts1
values
(401,1,102,'Savings',12000),
(402,2,101,'Savings',10000),
(403,3,102,'Cheque',19000),
(404,4,103,'Cheque',18000),
(405,5,102,'Savings',15000),
(406,6,103,'Savings',9000),
(407,7,104,'Cheque',6000),
(408,8,102,'Cheque',8000),
(409,9,101,'Savings',11000),
(410,10,103,'Savings',18000),
(411,11,104,'Savings',7000),
(412,12,104,'Cheque',9500),
(413,13,101,'Savings',6500),
(414,14,102,'Cheque',13000),
(415,15,101,'Cheque',20000);

CREATE TABLE Transactions3 ( 
transaction_id INT PRIMARY KEY, 
account_id INT, 
transaction_date DATE, 
transaction_type VARCHAR(20), 
amount DECIMAL(12,2), 
FOREIGN KEY (account_id) REFERENCES Accounts1(account_id) 
); 

INSERT INTO Transactions3 VALUES
(201,401,'2025-01-01','Deposit',2000),
(202,402,'2025-01-05','Deposit',600),
(203,403,'2025-01-03','Withdrawl',3000),
(204,404,'2025-01-07','EFT',1000),
(205,405,'2025-01-10','EFT',4000),
(206,406,'2025-01-02','Deposit',5000),
(207,407,'2025-01-08','Deposit',1500),
(208,408,'2025-01-06','Withdrawal',700),
(209,409,'2025-01-04','Withdrawl',2500),
(210,410,'2025-01-09','Deposit',6000),
(211,411,'2025-01-03','Deposit',500),
(212,412,'2025-01-05','Withdrawal',300),
(213,413,'2025-01-07','EFT',3000),
(214,414,'2025-01-08','Deposit',2500),
(215,415,'2025-01-09','Withdrawal',400);


Create table Loans1 (
loan_id int primary key,
customer_id int,
loan_amount Decimal (12,2),
interest_rate Decimal (5,2),
FOREIGN KEY (customer_id) REFERENCES Customers1(customer_id)
);


INSERT INTO Loans1 VALUES
(101,2,50000,8.5),
(102,3,12000,9.1),
(103,7,20000,10.2),
(104,8,75000,8.9),
(105,10,60000,7.8),
(106,11,40000,9.5),
(107,13,15000,8.0);

--Part 2 Task 1--
Select 
c.customer1_name,a.account_type,a.balance
From Customers1 c
Inner Join Accounts a
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
LEFT JOIN Accounts a
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
FROM Accounts a
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