CREATE DATABASE BankingAnalyticsDB;



CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);
INSERT INTO Customers VALUES
(1,'John Smith','Johannesburg'),
(2,'Mary Jones','Cape Town'),
(3,'David Brown','Durban'),
(4,'Sarah Wilson','Pretoria'),
(5,'James Taylor','Johannesburg'),
(6,'Linda White','Cape Town'),
(7,'Robert Green','Durban'),
(8,'Patricia Black','Pretoria'),
(9,'Michael Adams','Johannesburg'),
(10,'Jennifer King','Cape Town'),
(11,'William Scott','Durban'),
(12,'Elizabeth Hall','Pretoria'),
(13,'Daniel Young','Johannesburg'),
(14,'Emma Allen','Cape Town'),
(15,'Matthew Wright','Durban');


Select *from Customers

CREATE TABLE Branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO Branches VALUES
(1,'JHB Central','Johannesburg'),
(2,'Cape Mall','Cape Town'),
(3,'Durban North','Durban'),
(4,'Pretoria CBD','Pretoria'),
(5,'Sandton','Johannesburg'),
(6,'Sea Point','Cape Town'),
(7,'Umhlanga','Durban'),
(8,'Hatfield','Pretoria'),
(9,'Rosebank','Johannesburg'),
(10,'Claremont','Cape Town'),
(11,'Westville','Durban'),
(12,'Centurion','Pretoria'),
(13,'Midrand','Johannesburg'),
(14,'Bellville','Cape Town'),
(15,'Pinetown','Durban');

Select *from Branches


CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    branch_id INT,
    account_type VARCHAR(20),
    balance DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

INSERT INTO Accounts VALUES
(101,1,1,'Savings',12000),
(102,2,2,'Current',8000),
(103,3,3,'Savings',15000),
(104,4,4,'Current',5000),
(105,5,5,'Savings',20000),
(106,6,6,'Savings',9000),
(107,7,7,'Current',7000),
(108,8,8,'Savings',11000),
(109,9,9,'Current',3000),
(110,10,10,'Savings',14000),
(111,11,11,'Current',4000),
(112,12,12,'Savings',10000),
(113,13,13,'Current',6000),
(114,14,14,'Savings',13000),
(115,15,15,'Current',7500);

Select *from Accounts

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);
INSERT INTO Transactions VALUES
(1,101,'2025-01-01','Deposit',2000),
(2,101,'2025-01-05','Withdrawal',500),
(3,102,'2025-01-03','Deposit',1000),
(4,103,'2025-01-07','Withdrawal',2000),
(5,104,'2025-01-10','Deposit',1500),
(6,105,'2025-01-12','Withdrawal',1000),
(7,106,'2025-01-13','Deposit',1200),
(8,107,'2025-01-14','Deposit',800),
(9,108,'2025-01-15','Withdrawal',600),
(10,109,'2025-01-16','Deposit',900),
(11,110,'2025-01-17','Withdrawal',700),
(12,111,'2025-01-18','Deposit',500),
(13,112,'2025-01-19','Deposit',1000),
(14,113,'2025-01-20','Withdrawal',400),
(15,114,'2025-01-21','Deposit',2000),
(16,115,'2025-01-22','Withdrawal',300),
(17,101,'2025-01-23','Deposit',1000),
(18,102,'2025-01-24','Withdrawal',500),
(19,103,'2025-01-25','Deposit',1500),
(20,105,'2025-01-26','Deposit',2500);
Select *from Transactions

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Loans VALUES
(1,1,50000,7.5),
(2,2,30000,6.5),
(3,3,80000,8.0),
(4,4,25000,5.5),
(5,5,60000,7.0),
(6,6,45000,6.0),
(7,7,70000,8.5),
(8,8,20000,5.0),
(9,9,90000,9.0),
(10,10,35000,6.8),
(11,11,40000,7.2),
(12,12,100000,9.5),
(13,13,15000,4.5),
(14,14,55000,7.8),
(15,15,65000,8.2);
Select *from Loans

/* List customers and their account details */

SELECT C.customer_name, C.city,
       A.account_type, A.balance
FROM Customers C
INNER JOIN Accounts A
ON C.customer_id = A.customer_id;

/*Identify customers without loan */

SELECT C.customer_id, C.customer_name
FROM Customers C
LEFT JOIN Loans L
ON C.customer_id = L.customer_id
WHERE L.loan_id IS NULL;

/*Calculating total accountbalance per branch*/

SELECT B.branch_name,
       SUM(A.balance) AS Total_Balance
FROM Branches B
INNER JOIN Accounts A
ON B.branch_id = A.branch_id
GROUP BY B.branch_name
ORDER BY Total_Balance DESC;

/*Finding customers who live in the same city*/

SELECT C1.customer_name AS Customer1,
       C2.customer_name AS Customer2,
       C1.city
FROM Customers C1
JOIN Customers C2
ON C1.city = C2.city
AND C1.customer_id < C2.customer_id;

/* Classify loans into risk bands */

CREATE TABLE RiskBands (
RiskLevel VARCHAR(20),
MinRate DECIMAL(5,2),
MaxRate DECIMAL(5,2)
);


INSERT INTO RiskBands VALUES
('Low Risk',0,5.99),
('Medium Risk',6.00,7.99),
('High Risk',8.00,15.00);

SELECT L.loan_id,
       L.loan_amount,
       L.interest_rate,
       R.RiskLevel
FROM Loans L
JOIN RiskBands R
ON L.interest_rate BETWEEN R.MinRate AND R.MaxRate;

/* Branches with that have no accounts */

SELECT B.branch_name
FROM Accounts A
RIGHT JOIN Branches B
ON A.branch_id = B.branch_id
WHERE A.account_id IS NULL;

/* Accounts with more than one transaction */

SELECT A.account_id,
       COUNT(T.transaction_id) AS TransactionCount
FROM Accounts A
JOIN Transactions T
ON A.account_id = T.account_id
GROUP BY A.account_id
HAVING COUNT(T.transaction_id) > 1;