
CREATE TABLE Customers (
 customer_id INT PRIMARY KEY,
 customer_name VARCHAR(50),
 city VARCHAR(50)
);

INSERT INTO customers (customer_id,customer_name,city)VALUES 
(1,'john Smith' ,'Cape Town'),
(2,'Ayesha Patel' ,'Durban'),
(3,'Ryan Jacobs' ,'Cape Town'),
(4,'Jayden Pillay' ,'Johannesburg'),
(5,'Kiaynno Naidoo' ,'Cape Town'),
(6,'Jason Adams' ,'Durban'),
(7,'Kabo Modise' ,'Cape Town'),
(8,'David williams' ,'Johannesburg'),
(9,'Tiffany Brown' ,'Cape Town'),
(10,'Ashyle Green' ,'Johannesburg'),
(11,'Zanele Nkosi' ,'Cape Town'),
(12,'Monqiue Grey' ,'Cape Town'),
(13,'Joe Rryn' ,'Durban'),
(14,'Katie Khan' ,'Johannesburg'),
(15,'Abby James' ,'Pretoria');




CREATE TABLE Branches (
 branch_id INT PRIMARY KEY,
 branch_name VARCHAR(50),
 city VARCHAR(50)
);
INSERT INTO Branches (branch_id, branch_name, city) VALUES 
 (1, 'Cape Town Central', 'Cape Town'),
 (2, 'Durban Main', 'Durban'),
 (3, 'Johannesburg CBD', 'Johannesburg'),
 (4, 'Pretoria North', 'Pretoria'), 
 (5, 'Sandton City', 'Johannesburg'), 
 (6, 'Midrand', 'Midrand'),
 (7, 'Umhlanga', 'Durban'), 
 (8, 'Bellville', 'Cape Town'),
 (9, 'Polokwane Central', 'Polokwane'),
 (10, 'Rustenburg Mall', 'Rustenburg'),
 (11, 'Bloemfontein Central', 'Bloemfontein'),
 (12, 'East London Main', 'East London'),
 (13, 'Port Elizabeth Central', 'Port Elizabeth'), 
 (14, 'Kimberley Branch', 'Kimberley'),
 (15, 'Nelspruit Central', 'Nelspruit');



CREATE TABLE Accounts (
 account_id INT PRIMARY KEY,
 customer_id INT,
 branch_id INT,
 account_type VARCHAR(20),
 balance DECIMAL(12,2),
 FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
 FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

INSERT INTO Accounts (account_id, customer_id, branch_id, account_type, balance) VALUES 
(101, 1, 1, 'Savings', 5500.00),
(102, 2, 2, 'Cheque', 3200.50),
(103, 3, 3, 'Savings', 7800.75),
(104, 4, 4, 'Cheque', 1500.00),
(105, 5, 5, 'Savings', 9600.00),
(106, 6, 6, 'Cheque', 4100.25),
(107, 7, 7, 'Savings', 2200.00),
(108, 8, 8, 'Cheque', 8300.90), 
(109, 9, 9, 'Savings', 12000.00),
(110, 10, 10, 'Cheque', 5400.60),
(111, 11, 11, 'Savings', 6700.00), 
(112, 12, 12, 'Cheque', 2900.80),
(113, 13, 13, 'Savings', 4500.00), 
(114, 14, 14, 'Cheque', 3800.40), 
(115, 15, 15, 'Savings', 10200.00);





CREATE TABLE Transactions (
 transaction_id INT PRIMARY KEY,
 account_id INT,
 transaction_date DATE,
 transaction_type VARCHAR(20),
 amount DECIMAL(12,2),
 FOREIGN KEY (account_id) REFERENCES Accounts(account_id)



 



 INSERT INTO Transactions (transaction_id, account_id, transaction_type, amount, transaction_date) 
  VALUES 
  (101, 1, 'Deposit', 1500.00, '2026-02-01'),
  (102, 1, 'Withdrawal', 1400.00, '2026-02-09'),
  (103, 2, 'Deposit', 3000.00, '2026-02-03'), 
  (104, 2, 'Withdrawal', 500.00, '2026-02-03'), 
  (105, 3, 'Deposit', 1200.00, '2026-02-04'),
  (106, 3, 'Withdrawal', 250.00, '2026-02-05'), 
  (107, 4, 'Deposit', 800.00, '2026-02-07'),
  (108, 4, 'Withdrawal', 100.00, '2026-02-06');


CREATE TABLE Loans (
 loan_id INT PRIMARY KEY,
 customer_id INT,
 loan_amount DECIMAL(12,2),
 interest_rate DECIMAL(5,2),
 FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


INSERT INTO Loans (loan_id ,customer_id, loan_amount, interest_rate) VALUES
   (1, 1, 50000.00, 7.50),
   (2, 2, 120000.00, 6.25),
   (3, 3, 30000.00, 8.00),
   (4, 4, 95000.00, 5.75),
   (5, 5, 60000.00, 7.00),
   (6, 6, 150000.00, 6.80),
   (7, 7, 45000.00, 9.25),
   (8, 8, 80000.00, 7.25);
  
  TASK 1

  SELECT
  c.customer_id,
  c.customer_name, 
  a.account_id,
  a.balance 
  FROM Customers c
  INNER JOIN Accounts a
   ON c.customer_id = a.customer_id;


	TASK 2
	SELECT
	 c.customer_id,
	 c.customer_name
	 FROM Customers c
	 LEFT JOIN Loans l 
	 ON c.customer_id = l.customer_id 
	 WHERE l.loan_id IS NULL;

	 TASK 3
	 SELECT
	  b.branch_name,
	   SUM(a.balance) AS total_balance
	    FROM Branches b
	   INNER JOIN Accounts a
	    ON b.branch_id = a.branch_id 
		GROUP BY b.branch_name;

		TASK4
 SELECT
  c1.customer_name AS Customer1,
   c2.customer_name AS Customer2,
   c1.city
   FROM Customers c1
    INNER JOIN Customers c2
	 ON c1.city = c2.city
  AND c1.customer_id < c2.customer_id;



  TASK 5
SELECT
 loan_id,
  loan_amount, interest_rate,
  CASE WHEN interest_rate < 6 
 THEN 'Low Risk' 
 WHEN interest_rate
 BETWEEN 6 AND 8 THEN 
'Medium Risk'
 ELSE 'High Risk'
 END AS Risk_Level
 FROM Loans

 TASK6
SELECT
   b.branch_id,
   b.branch_name
   FROM Accounts a  
   RIGHT JOIN Branches b 
   ON a.branch_id = b.branch_id
   WHERE a.account_id IS NOT NULL; 

   TASK7
   SELECT 
   c.customer_name,
    a.account_id,
	COUNT(t.transaction_id) AS num_transactions
	FROM Customers c
   INNER JOIN Accounts a
    ON c.customer_id = a.customer_id 
   INNER JOIN Transactions t 
    ON a.account_id = t.account_id 
	GROUP BY c.customer_name, a.account_id
    HAVING COUNT(t.transaction_id) > 1;
