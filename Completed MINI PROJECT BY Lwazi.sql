----MINI Project-----
----PART 1 ( Database Setup (SQL Server)----
----Table for Customers8-----
----Spiderman----

CREATE TABLE Customers8 (
 customer_id INT PRIMARY KEY,
 customer_name VARCHAR(50),
 city VARCHAR(50)
);

INSERT INTO Customers8 (customer_id, customer_name, city) 
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Johnson', 'Los Angeles'),
(3, 'Charlie Brown', 'Chicago'),
(4, 'Diana Prince', 'Houston'),
(5, 'Edward Elric', 'Phoenix');

SELECT * FROM Customers8




----Table for Branches----

CREATE TABLE Branches (
 branch_id INT PRIMARY KEY,
 branch_name VARCHAR(50),
 city VARCHAR(50)
);

INSERT INTO Branches (branch_id, branch_name, city) 
VALUES
(1, 'Main Branch', 'New York'),
(2, 'Downtown Branch', 'Los Angeles'),
(3, 'Uptown Branch', 'Chicago'),
(4, 'Westside Branch', 'Houston'),
(5, 'Eastside Branch', 'Phoenix');

SELECT * FROM Branches





-----Table for Accounts------

CREATE TABLE Accounts (
 account_id INT PRIMARY KEY,
 customer_id INT,
 branch_id INT,
 account_type VARCHAR(20),
 balance DECIMAL(12,2),
 FOREIGN KEY (customer_id) REFERENCES Customers8(customer_id),
 FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

INSERT INTO Accounts (account_id, customer_id, branch_id, account_type, balance) VALUES
(1, 1, 1, 'Savings', 1500.75),
(2, 2, 2, 'Checking', 2500.00),
(3, 3, 3, 'Savings', 1800.50),
(4, 4, 4, 'Checking', 3200.25),
(5, 5, 5, 'Savings', 500.00);

SELECT * FROM Accounts





-----Table for Transactions-----

CREATE TABLE Transactions (
 transaction_id INT PRIMARY KEY,
 account_id INT,
 transaction_date DATE,
 transaction_type VARCHAR(20),
 amount DECIMAL(12,2),
 FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

INSERT INTO Transactions (transaction_id, account_id, transaction_date, transaction_type, amount) VALUES
(1, 1, '2023-01-15', 'Deposit', 500.00),
(2, 1, '2023-02-10', 'Withdrawal', 200.00),
(3, 2, '2023-03-05', 'Deposit', 1500.00),
(4, 3, '2023-01-20', 'Withdrawal', 300.50),
(5, 4, '2023-04-01', 'Deposit', 1200.00);

SELECT * FROM Transactions






-----Table for Loans-----

CREATE TABLE Loans1 (
 loan_id INT PRIMARY KEY,
 customer_id INT,
 loan_amount DECIMAL(12,2),
 interest_rate DECIMAL(5,2),
 FOREIGN KEY (customer_id) REFERENCES Customers8(customer_id)
);

INSERT INTO Loans1 (loan_id, customer_id, loan_amount, interest_rate) 
VALUES
(1, 1, 10000.00, 3.50),
(2, 2, 15000.00, 4.00),
(3, 3, 20000.00, 3.75),
(4, 4, 25000.00, 5.00),
(5, 5, 30000.00, 4.25);

SELECT * FROM Loans1


----PART2:Tasks with Advanced JOINs----
----Task 1: Customer Account Overview 

SELECT * FROM Customers8
SELECT * FROM Branches
SELECT * FROM Accounts
SELECT * FROM Transactions
SELECT * FROM Loans1



----Task2: Customers without Loans -------

SELECT 
    c.customer_id,
    c.customer_name,
    c.city
FROM 
    Customers8 c
LEFT JOIN 
    Loans1 ON c.customer_id = Loans1.customer_id

--In my istance all my customers took loans



------Task3: Branch Performance Report-------

SELECT 
    b.branch_id,
    b.branch_name,
    SUM(a.balance) AS total_balance
FROM 
    Accounts a
JOIN 
    Branches b ON a.branch_id = b.branch_id  -- Join to connect accounts with branches
GROUP BY 
    b.branch_id, b.branch_name;  -- Group by branch to calculate total balance


-----Task 4: SELF JOIN – Customers in the Same City-----

SELECT 
    c.city,
    COUNT(c.customer_id) AS customer_count
FROM 
    Customers8 c
GROUP BY 
    c.city
HAVING 
    COUNT(c.customer_id) > 1;  -- Filter for cities with more than one customer


----In my instance there no customers who live in the same city----


----Task 5: NON-EQUI JOIN – Loan Risk Classification----
Select * from Loans1

SELECT 
    loan_id,
    customer_id,
    loan_amount,
    interest_rate,
    CASE 
        WHEN loan_amount <= 10000 THEN 'Low Risk'
        WHEN loan_amount > 10000 AND loan_amount <= 20000 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS risk_band
FROM 
    Loans1;


----Task 6: RIGHT JOIN – Branches without Accounts

SELECT 
    b.branch_id,
    b.branch_name,
    b.city
FROM 
    Branches b
RIGHT JOIN 
    Accounts a ON b.branch_id = a.branch_id
WHERE 
    a.account_id IS NULL;  -- Filter for branches without accounts


SELECT * FROM Branches


-----Task 7: Advanced Analytics – High Activity Accounts---

SELECT 
    a.account_id,
    COUNT(t.transaction_id) AS transaction_count
FROM 
    Accounts a
INNER JOIN 
    Transactions t ON a.account_id = t.account_id  -- Join accounts with their transactions
GROUP BY 
    a.account_id
HAVING 
    COUNT(t.transaction_id) > 1;  -- Filter accounts with more than one transaction




