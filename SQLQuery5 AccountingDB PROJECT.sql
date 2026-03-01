
---Create Tables --
Create Table Clients 
(
ClientID INT IDENTITY Primary Key,
ClientName Varchar(100) not null,
AccountBalance Money Default 0

);

CREATE TABLE Accounts
(
    AccountID INT IDENTITY PRIMARY KEY,
    ClientID INT NOT NULL,
    AccountName VARCHAR(100) NOT NULL,
    Balance MONEY DEFAULT 0,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);

CREATE TABLE Transactions
(
    TransactionID INT IDENTITY PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(10) CHECK (TransactionType IN ('Debit','Credit')),
    Amount MONEY NOT NULL CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE AuditLog
(
    AuditID INT IDENTITY PRIMARY KEY,
    TableName VARCHAR(50),
    ActionType VARCHAR(50),
    ActionDate DATETIME DEFAULT GETDATE(),
    Description VARCHAR(255)
);


---Q3 Insert DATA--
INSERT INTO Clients (ClientName)
VALUES ('KUNI Traders');

INSERT INTO Accounts (ClientID, AccountName, Balance)
VALUES (1, 'Main Account', 5000);

Select* From Clients;

Select* from Accounts;

---Q4 Trigger -Update Account Balance--

Create Trigger trg_UpdateAccountBalance
ON Transactions 
After Insert 
AS 
Begin
  Update a
  Set a.Balance =
  CASE --- The CASE expression is used to Implement IF-THEN logic--
      When i.TransactionType = 'Credit' THEN a.Balance + i.Amount
	  When i.TransactionType = 'DEBIT' THEN a.Balance - i. Amount
	  END 
FROM Accounts a
INNER JOIN inserted i
 ON a.AccountID = i.AccountID;
 END;

 --- Q5 TRIGGER - AUDIT TRANSACTIONS---

 CREATE TRIGGER trg_AuditTransactions
ON Transactions
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (TableName, ActionType, Description)
    SELECT 
        'Transactions',
        'INSERT',
        'Transaction of ' + TransactionType + 
        ' amount R' + CAST(Amount AS VARCHAR)
    FROM inserted;
END;

---Q6 TRIGGER PREVENT DELETING TRANSACTIONS---

CREATE TRIGGER trg_PreventTransactionDelete
ON Transactions
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Deleting financial transactions is not allowed.', 16, 1);
END;
---Q7 TRIGGER PREVENT NEGATIVE BALANCES--
CREATE TRIGGER trg_PreventNegativeBalance
ON Transactions
AFTER INSERT
AS
BEGIN 
    IF EXISTS (
        SELECT 1
        FROM Accounts a
        JOIN inserted i ON a.AccountID = i.AccountID
        WHERE a.Balance < 0
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('Transaction denied: Account balance cannot go below zero.', 16, 1);
    END
END;

    --Test 1 Credit Transaction--
INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (1, 'Credit', 2000);

--Test 2 Debit Transaction--
INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (1, 'Debit', 1000);

--Test 3 Invaild Delete--
DELETE FROM Transactions WHERE TransactionID = 1;

--Test 4 Overdraw Attempt--
INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (1, 'Debit', 10000);



