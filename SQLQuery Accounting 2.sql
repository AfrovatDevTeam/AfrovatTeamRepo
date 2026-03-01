---Create Tables --
Create Table Clients2
(
ClientID INT IDENTITY Primary Key,
ClientName Varchar(100) not null,
AccountBalance Money Default 0

);

CREATE TABLE Accounts2
(
    AccountID INT IDENTITY PRIMARY KEY,
    ClientID INT NOT NULL,
    AccountName VARCHAR(100) NOT NULL,
    Balance MONEY DEFAULT 0,
    FOREIGN KEY (ClientID) REFERENCES Clients2(ClientID)
);

CREATE TABLE Transactions2
(
    TransactionID INT IDENTITY PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(10) CHECK (TransactionType IN ('Debit','Credit')),
    Amount MONEY NOT NULL CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts2(AccountID)
);

CREATE TABLE AuditLog2
(
    AuditID INT IDENTITY PRIMARY KEY,
    TableName VARCHAR(50),
    ActionType VARCHAR(50),
    ActionDate DATETIME DEFAULT GETDATE(),
    Description VARCHAR(255)
);


---Q3 Insert DATA--
INSERT INTO Clients2(ClientName)
VALUES ('KUNI Traders');

Select * From Clients2

INSERT INTO Accounts2(ClientID, AccountName, Balance)
VALUES (1, 'Main Account', 5000);

Select * From Accounts2


---Q4 Trigger -Update Account Balance--

Create Trigger trg_UpdateAccountBalance2
ON Transactions2
After Insert 
AS 
Begin Set NOCOUNT ON
  Update a
  Set a.Balance =
  CASE --- The CASE expression is used to Implement IF-THEN logic--
      When i.TransactionType = 'DEBIT' THEN a.Balance - i.Amount
	  When i.TransactionType = 'CREDIT' THEN a.Balance + i.Amount
	  END 
FROM Accounts2 a
INNER JOIN inserted i
 ON a.AccountID = i.AccountID;
 END;

 --- Q5 TRIGGER - AUDIT TRANSACTIONS---

 CREATE TRIGGER trg_AuditTransactions2
ON Transactions2
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog2 (TableName, ActionType, Description)
    SELECT 
        'Transactions',
        'INSERT',
        'Transaction of ' + TransactionType + 
        ' amount R' + CAST(Amount AS VARCHAR)
    FROM inserted;
END;

---Q6 TRIGGER PREVENT DELETING TRANSACTIONS---

CREATE TRIGGER trg_PreventTransactionDelete
ON Transactions2
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Deleting financial transactions is not allowed.', 16, 1);
END;


---Q7 TRIGGER PREVENT NEGATIVE BALANCES--
CREATE TRIGGER trg_PreventNegativeBalance3
ON Account
AFTER INSERT
AS
BEGIN 
    IF EXISTS (
        SELECT 1
        FROM Accounts2 a
        JOIN inserted i ON a.AccountID = i.AccountID
        WHERE a.Balance < 0
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('Transaction denied: Account balance cannot go below zero.', 16, 1);
    END
END;

    --Test 1 Credit Transaction--
INSERT INTO Transactions2 (AccountID, TransactionType, Amount)
VALUES (1, 'Credit', 2000);


--Test 2 Debit Transaction--
INSERT INTO Transactions2 (AccountID, TransactionType, Amount)
VALUES (1, 'Debit', 1000);

--Test 3 Invaild Delete--
DELETE FROM Transactions2 WHERE TransactionID = 1;

--Test 4 Overdraw Attempt--
INSERT INTO Transactions2 (AccountID, TransactionType, Amount)
VALUES (1, 'Debit', 10000);


Select * From Transactions2


Select * From AuditLog2