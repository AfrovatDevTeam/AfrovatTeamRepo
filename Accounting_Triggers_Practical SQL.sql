/* =========================================
   QUESTION 1: CREATE DATABASE
   ========================================= */

CREATE DATABASE AccountingDB;

GO

USE AccountingDB;
GO

/* =========================================
   QUESTION 2: CREATE TABLES
   ========================================= */

/* 2.1 Clients Table */
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    ClientName VARCHAR(100) NOT NULL,
    AccountBalance DECIMAL(18,2) DEFAULT 0,
);

/* =========================================
   QUESTION 3: INSERT SAMPLE DATA
   ========================================= */

/* Insert one client */
INSERT INTO Clients (ClientName)
VALUES ('ABC Traders');
SELECT *from Clients

/* 2.2 Accounts Table */
CREATE TABLE Accounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    AccountName VARCHAR(100),
    Balance DECIMAL(18,2) DEFAULT 0,
    CONSTRAINT FK_Accounts_Clients
        FOREIGN KEY (ClientID)
        REFERENCES Clients(ClientID)
);

/* Insert one account with starting balance of 5000 */
INSERT INTO Accounts (ClientID, AccountName, Balance)
VALUES (1, 'Main Account', 5000);
Select *from Accounts

/* 2.3 Transactions Table */
CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(10) 
        CHECK (TransactionType IN ('Debit', 'Credit')),
    Amount DECIMAL(18,2) CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Transactions_Accounts
        FOREIGN KEY (AccountID)
        REFERENCES Accounts(AccountID)
);

/* 2.4 AuditLog Table */
CREATE TABLE AuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName VARCHAR(50),
    ActionType VARCHAR(50),
    ActionDate DATETIME DEFAULT GETDATE(),
    Description VARCHAR(255)
);

/* =========================================
   QUESTION 4: TRIGGER TO UPDATE ACCOUNT BALANCE
   ========================================= */

CREATE TRIGGER trg_UpdateAccountBalance
ON Transactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    /* Update balance for CREDIT transactions */
    UPDATE A
    SET A.Balance = A.Balance + I.Amount
    FROM Accounts A
    JOIN inserted I ON A.AccountID = I.AccountID
    WHERE I.TransactionType = 'Credit';

    /* Update balance for DEBIT transactions */
    UPDATE A
    SET A.Balance = A.Balance - I.Amount
    FROM Accounts A
    JOIN inserted I ON A.AccountID = I.AccountID
    WHERE I.TransactionType = 'Debit';
END;
GO


/* =========================================
   QUESTION 5: TRIGGER TO AUDIT TRANSACTIONS
   ========================================= */

CREATE TRIGGER trg_AuditTransactions
ON Transactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AuditLog (TableName, ActionType, Description)
    SELECT
        'Transactions',
        'INSERT',
        'Transaction of ' + TransactionType +
        ' amount ' + CAST(Amount AS VARCHAR(20)) +
        ' for AccountID ' + CAST(AccountID AS VARCHAR(10))
    FROM inserted;
END;
GO

/* =========================================
   QUESTION 6: PREVENT DELETE ON TRANSACTIONS
   ========================================= */

CREATE TRIGGER trg_PreventTransactionDelete
ON Transactions
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Deleting financial transactions is not allowed.', 16, 1);
END;
GO


/* =========================================
   QUESTION 7: PREVENT NEGATIVE BALANCES
   ========================================= */

CREATE TRIGGER trg_PreventNegativeBalance
ON Transactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if any account balance goes below zero */
    IF EXISTS (
        SELECT 1
        FROM Accounts A
        JOIN inserted I ON A.AccountID = I.AccountID
        WHERE A.Balance < 0
    )
    BEGIN
        RAISERROR ('Transaction denied: Account balance cannot go below zero.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (1, 'Credit', 2000);

INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (1, 'Debit', 1000);

Select *from Transactions

DELETE FROM Transactions WHERE TransactionID = 1;
INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (1, 'Debit', 10000);