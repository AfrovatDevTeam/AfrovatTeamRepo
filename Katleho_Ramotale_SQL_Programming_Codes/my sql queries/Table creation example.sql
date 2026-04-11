----project banking system. customers, accounts, transactions

--1st. create database
CREATE DATABASE BankDB;

--2nd. create tables with primary & foreign key

CREATE TABLE Customers(
CustomerID	INT PRIMARY KEY IDENTITY (1,1),
FirstName VARCHAR (50) NOT NULL,
LastName VARCHAR (50) NOT NULL,
Email VARCHAR (100),
Phone VARCHAR (15),
DateCreated DATETIME DEFAULT GETDATE ()
);

select * from  Customers

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

select * from  Accounts

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

select * from Transactions

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
