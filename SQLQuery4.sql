----project banking system. customers, accounts, transactions

--1st. create database
CREATE DATABASE BankDB4;

--2nd. create tables with primary & foreign key

CREATE TABLE Customers(
CustomerID	INT PRIMARY KEY IDENTITY (1,1),
FirstName VARCHAR (50) NOT NULL,
LastName VARCHAR (50) NOT NULL,
Email VARCHAR (100),
Phone VARCHAR (15),
DateCreated DATETIME DEFAULT GETDATE ()
);

CREATE TABLE Accounts(
AccountsID	INT PRIMARY KEY IDENTITY (1001,1),
CustomerID INT NOT NULL,
AccountType VARCHAR (20) CHECK (AccountType IN ('Savings', 'Current')),
Balance DECIMAL (10,2) DEFAULT 0,
DateOpened DATETIME DEFAULT GETDATE ()

CONSTRAINT FK_CustomerAccount
FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions(
TransactionsID	INT PRIMARY KEY IDENTITY (1,1),
AccountID INT NOT NULL,
TransactionType VARCHAR (10) CHECK (TransactionType IN ('Deposits', 'Withdraw')),
Amount DECIMAL (10,2) NOT NULL,
TransactionDate DATETIME DEFAULT GETDATE ()

CONSTRAINT FK_TransactionsAccountsID
FOREIGN KEY (AccountID)
REFERENCES Accounts(AccountsID)
);


INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES 
('Thabo', 'Mokoena', 'thabo.mokoena@email.co.za', '0712345678'),
('Nomsa', 'Dlamini', 'nomsa.dlamini@email.co.za', '0723456789'),
('Sipho', 'Nkosi', 'sipho.nkosi@email.co.za', '0734567890'),
('Ayesha', 'Khan', 'ayesha.khan@email.co.za', '0745678901'),
('Johan', 'van der Merwe', 'johan.vdmerwe@email.co.za', '0767890123'),
('Lerato', 'Mabaso', 'lerato.mabaso@email.co.za', '0789012345'),
('Michael', 'Naidoo', 'michael.naidoo@email.co.za', '0790123456');


INSERT INTO Accounts (CustomerID, AccountType, Balance)
VALUES
(1, 'Savings', 8500.00),
(1, 'Current', 3200.00),
(2, 'Savings', 12500.00),
(3, 'Current', 2400.00),
(4, 'Savings', 15750.00),
(5, 'Current', 6800.00),
(6, 'Savings', 9200.00),
(7, 'Current', 4100.00);

INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate)
VALUES
(1001, 'Deposits', 2500.00, '2026-01-05 09:15:00'),
(1002, 'Withdraw', 800.00, '2026-01-07 14:20:00'),
(1003, 'Deposits', 1200.00, '2026-01-08 10:45:00'),
(1004, 'Withdraw', 1500.00, '2026-01-09 16:30:00'),
(1005, 'Deposits', 5000.00, '2026-01-10 11:00:00'),
(1006, 'Withdraw', 2000.00, '2026-01-11 13:10:00'),
(1007, 'Deposits', 3500.00, '2026-01-12 08:25:00'),
(1008, 'Withdraw', 900.00, '2026-01-13 17:45:00');

SELECT * FROM Customers

---OPERATORS
--COMPARISON OPERATOR
--ACCOUNTS WITH A BALANCE > 3000
SELECT *FROM Accounts
WHERE Balance < 3000;

--LOGICAL OPERATOR
--savings accounts with balance above 4000
SELECT *FROM Accounts
WHERE AccountType = 'Savings'
AND Balance > 4000;   ---<>(NOT EQUAL), OR(EITHER CONDITION), >=(GREATER OR EQUAL)

---BETWEEN OPERATOR
SELECT *FROM Accounts
WHERE Balance BETWEEN 100
AND 6000;

---LIKE OPERATOR
SELECT * FROM Customers
WHERE FirstName LIKE 'J%';

---CONDITIONAL STATEMENTS (IF ... ELSE)
DECLARE @Balance DECIMAL (10,2) --declare is creating variable, @balance is variable name
SET @Balance = 1000             --set is assigning value to variable @balance

IF @Balance >= 50000           ---if is checking condition, >= is the condition
PRINT 'Withdrawal Allowed'
ELSE                           --if true, print first message, if false print 2nd message
PRINT 'Insufficient Funds'

---HOW DO WE COMPARE 3 OR MORE CONDITIONS, CAN WE HAVE 3 OR MORE CONDITIONS?

--MULTIPLE CONDITIONS IN WHERE(AND, ON, IN, BETWEEN)
SELECT * FROM Accounts
WHERE AccountType = 'Savings'
AND Balance >5000
AND DateOpened>= '2026-01-01';

SELECT * FROM Accounts
WHERE (AccountType = 'Savings' OR AccountType = 'Current')
AND Balance >7000
AND CustomerID = 2;

DECLARE @Balance DECIMAL(10,2) = 8000;
DECLARE @AccountType VARCHAR(20) = 'Savings';
DECLARE @CustomerAge INT = 25;

IF @Balance >= 5000
    AND @AccountType = 'Savings'
    AND @CustomerAge >= 18
BEGIN
    PRINT 'Eligible for Premium Savings Account';
END
ELSE
BEGIN
    PRINT 'Not Eligible'
END;


SELECT 
AccountsID,
Balance,
CASE 
WHEN Balance >= 15000 THEN 'Platinum'
WHEN Balance >= 10000 THEN 'Gold'
WHEN Balance >= 5000 THEN 'Silver'
ELSE 'Standard'
END AS AccountCategory
FROM Accounts; 

---JOINS
--INNER JOIN
SELECT 
C.FirstName,
C.LastName,
A.AccountType,
A.Balance
FROM Customers C ---C IS AN ALIAS
INNER JOIN Accounts A --- A IS AN ALIAS( INNER JOIN )
ON C.CustomerID = A.CustomerID; ---JOINING TO CUSTOMERS TO ACCOUNTS---

---HOW DO WE DETERMINE JOIN TO USE? Dependant on Scenario 

--LEFT JOIN --

SELECT 
C.FirstName,
A.AccountsID
FROM Customers C 
LEFT JOIN Accounts A 
ON C.CustomerID = A.CustomerID;

--- MULTIPLE TABLE JOINS---

SELECT 
C.FirstName,
A.AccountType,
T.TransactionType,
T.Amount
FROM Customers C   
INNER JOIN Accounts A  ON C.CustomerID = A.CustomerID
INNER JOIN Transactions T  ON A.AccountsID = T.AccountID;

---what kind of information are you looking for or what type of information you want be dealing with---


---TRIGGERS HOW ARE WE CREATING A TRIGGER?--

---WHEN A TRANSACTION IS INSERTED---
---IF DEPOSIT ECPECT ADDIND TO BALANCE 
---IF WITHDRAWAL EXPECT SUBTRACTING FROM BALANCE 

CREATE TRIGGER trg_UpdateBalance  ---CREATED TRIGGER
ON Transactions  --TRIGGER ACTIVATING ON TRANSACTION TABLE
AFTER INSERT   ---RUN AFTER A NEW RECORD IS INSERTED
AS
BEGIN
UPDATE Accounts  ---WE ARE MODIFYING ACCOUNTS TABLE
SET Balance = 
CASE  --- WORKING LIFE IF INSIDE SQL
WHEN i.TransactionType = 'Deposits' ---1ST WHEN, IF DEPOSITS TO ADD MONEY
THEN Balance + i.Amount
WHEN i.TransactionType = 'Withdraw'  ---2ND WHEN IF WITHDRAW, SUBTRACT MONEY
THEN Balance - i.Amount
END
FROM Accounts A
INNER JOIN inserted i ---INSERTED IS SPECIAL TEMP TABLE
ON A.AccountsID = i.AccountID;
END;
---TEST TRIGGER
INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES(1001, 'Deposits', 1000);

SELECT * FROM Accounts WHERE AccountsID = 1001;