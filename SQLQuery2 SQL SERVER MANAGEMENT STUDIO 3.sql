---Create Tables --
Create Table Clients3
(
ClientID INT IDENTITY Primary Key,
ClientName Varchar(100) not null,
AccountBalance Money Default 0

);

CREATE TABLE Accounts3
(
    AccountID INT IDENTITY PRIMARY KEY,
    ClientID INT NOT NULL,
    AccountName VARCHAR(100) NOT NULL,
    Balance MONEY DEFAULT 0,
    FOREIGN KEY (ClientID) REFERENCES Clients2(ClientID)
);

CREATE TABLE Transactions3
(
    TransactionID INT IDENTITY PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(10) CHECK (TransactionType IN ('Debit','Credit')),
    Amount MONEY NOT NULL CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts3(AccountID)
);

CREATE TABLE AuditLog3
(
    AuditID INT IDENTITY PRIMARY KEY,
    TableName VARCHAR(50),
    ActionType VARCHAR(50),
    ActionDate DATETIME DEFAULT GETDATE(),
    Description VARCHAR(255)
);


---Q3 Insert DATA--
INSERT INTO Clients3(ClientName)
VALUES ('KUNI Traders');

Select * From Clients3

INSERT INTO Accounts3(ClientID, AccountName, Balance)
VALUES (1, 'Main Account', 5000);

Select * From Accounts3


---Q4 Trigger -Update Account Balance--

Create Trigger trg_UpdateAccountBalance3
ON Transactions3
After Insert 
AS 
Begin Set NOCOUNT ON
  Update a
  Set a.Balance =
  CASE --- The CASE expression is used to Implement IF-THEN logic--
      When i.TransactionType = 'DEBIT' THEN a.Balance - i.Amount
	  When i.TransactionType = 'CREDIT' THEN a.Balance + i.Amount
	  END 
FROM Accounts3 a
INNER JOIN inserted i
 ON a.AccountID = i.AccountID;
 END;

 --- Q5 TRIGGER - AUDIT TRANSACTIONS---

 CREATE TRIGGER trg_AuditTransactions3
ON Transactions3
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog3 (TableName, ActionType, Description)
    SELECT 
        'Transactions',
        'INSERT',
        'Transaction of ' + TransactionType + 
        ' amount R' + CAST(Amount AS VARCHAR)
    FROM inserted;
END;

---Q6 TRIGGER PREVENT DELETING TRANSACTIONS---

CREATE TRIGGER trg_PreventTransactionDelete
ON Transactions3
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Deleting financial transactions is not allowed.', 16, 1);
END;


---Q7 TRIGGER PREVENT NEGATIVE BALANCES--
7a

    --Test 1 Credit Transaction--
INSERT INTO Transactions3 (AccountID, TransactionType, Amount)
VALUES (1, 'Credit', 2000);


--Test 2 Debit Transaction--
INSERT INTO Transactions3 (AccountID, TransactionType, Amount)
VALUES (1, 'Debit', 1000);

--Test 3 Invaild Delete--
DELETE FROM Transactions3 WHERE TransactionID = 1;

--Test 4 Overdraw Attempt--
INSERT INTO Transactions3 (AccountID, TransactionType, Amount)
VALUES (1, 'Debit', 10000);


Select * From Transactions3

