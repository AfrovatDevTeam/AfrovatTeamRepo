---Part1---

CREATE TABLE Customers1 (

customer_id INT PRIMARY KEY,

customer_name VARCHAR(50),

city VARCHAR(50)

);

INSERT INTO Customers1(customer_id, customer_name, city) VALUES
(1, 'Alice Johnson', 'New York'),
(2, 'Bob Smith', 'Los Angeles'),
(3, 'Charlie Davis', 'Chicago'),
(4, 'Diana Prince', 'New York'),
(5, 'Edward Norton', 'Chicago'),
(6, 'Fiona Gallagher', 'Boston'),
(7, 'George Miller', 'Miami'),
(8, 'Hannah Abbott', 'Boston');

CREATE TABLE Branches (

branch_id INT PRIMARY KEY,

branch_name VARCHAR(50),

city VARCHAR(50)

);

INSERT INTO Branches (branch_id, branch_name, city) VALUES
(101, 'Downtown Manhattan', 'New York'),
(102, 'Hollywood Central', 'Los Angeles'),
(103, 'Windy City Main', 'Chicago'),
(104, 'South Loop', 'Chicago'),
(105, 'Back Bay Financial', 'Boston'),
(106, 'Ocean Drive', 'Miami'),
(107, 'Fenway Park', 'Boston'),
(108, 'Silicon Alley', 'New York');


CREATE TABLE Account
 (
 account_id INT PRIMARY KEY,
 customer_id INT,
 branch_id INT,
 account_type VARCHAR(20),
 balance DECIMAL(12,2),
 FOREIGN KEY (customer_id) REFERENCES Customers1(customer_id),
 FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
 );

 INSERT INTO Account (account_id, customer_id, branch_id, account_type, balance) VALUES
(5001, 1, 101, 'Savings', 5000.00),
(5002, 1, 101, 'Checking', 1200.50),
(5003, 2, 102, 'Savings', 25000.00),
(5004, 3, 103, 'Checking', 450.75),
(5005, 4, 101, 'Savings', 8900.00),
(5006, 5, 104, 'Savings', 12500.00),
(5007, 6, 105, 'Checking', 320.00),
(5008, 7, 106, 'Savings', 45000.00);


CREATE TABLE Transactions (
 transaction_id INT PRIMARY KEY,
 account_id INT,
 transaction_date DATE,
 transaction_type VARCHAR(20),
 amount DECIMAL(12,2),
 FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

INSERT INTO Transactions (transaction_id, account_id, transaction_date, transaction_type, amount) VALUES
(9001, 5001, '2023-10-01', 'Deposit', 1500.00),
(9002, 5001, '2023-10-05', 'Withdrawal', 200.00),
(9003, 5002, '2023-10-08', 'Deposit', 300.50),
(9004, 5003, '2023-10-10', 'Withdrawal', 5000.00),
(9005, 5004, '2023-10-12', 'Deposit', 100.00),
(9006, 5006, '2023-10-15', 'Deposit', 2000.00),
(9007, 5007, '2023-10-16', 'Withdrawal', 50.00),
(9008, 5008, '2023-10-17', 'Deposit', 10000.00);


CREATE TABLE Loans (
 loan_id INT PRIMARY KEY,
 customer_id INT,
 loan_amount DECIMAL(12,2),
 interest_rate DECIMAL(5,2),
 FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Loans (loan_id, customer_id, loan_amount, interest_rate) VALUES
(201, 1, 15000.00, 5.50),
(202, 2, 250000.00, 3.25),
(203, 3, 5000.00, 7.00),
(204, 1, 2000.00, 4.50),
(205, 5, 50000.00, 4.20),
(206, 6, 1200.00, 12.00),
(207, 7, 35000.00, 3.80),
(208, 8, 8000.00, 5.25);

---Part2 Task1---
Select
c.customer_name,a.account_type,a.balance
From Customers1 c
Inner Join Account a
ON c.customer_id =a.customer_id

--Task2--
SELECT c.customer_name
FROM Customers1 c
LEFT JOIN Loans l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;


---Task 3---
SELECT b.branch_name, SUM(a.balance) AS total_assets
FROM Branches b
LEFT JOIN Account a ON b.branch_id = a.branch_id
GROUP BY b.branch_name;


---Task 4---
SELECT 
    c1.customer_name AS Customer_A, 
    c2.customer_name AS Customer_B, 
    c1.city
FROM Customers1 c1
JOIN Customers1 c2 ON c1.city = c2.city
WHERE c1.customer_id < c2.customer_id;

---Task5---

SELECT loan_id, loan_amount, interest_rate,
       CASE 
           WHEN interest_rate <= 4.00 THEN 'Low Risk'
           WHEN interest_rate BETWEEN 4.01 AND 6.00 THEN 'Medium Risk'
           ELSE 'High Risk'
       END AS risk_classification
FROM Loans;


---Task6--
SELECT b.branch_name
FROM Account a
RIGHT JOIN Branches b ON a.branch_id = b.branch_id
WHERE a.account_id IS NULL;

---Task7--

SELECT 
    c.customer_name, 
    a.account_id, 
    COUNT(t.transaction_id) AS transaction_count
FROM Transactions t
INNER JOIN Account a ON t.account_id = a.account_id
INNER JOIN Customers1 c ON a.customer_id = c.customer_id
GROUP BY c.customer_name, a.account_id
HAVING COUNT(t.transaction_id) > 1;




