CREATE DATABASE AccountingDB

create table Clients
(
ClientID int primary key,
Clientname varchar(30),
AccountBalance money Default 0
);

create table Accounts 
(
AccountID int primary key,
ClientID int foreign key (ClientID) references Clients (ClientID),
AccountName varchar(50) not null,
Balance money Default 0 
);


create table Transactions
(
TransactionsID int primary key,
AccountID int foreign key (AccountID) references Accounts (AccountID),
TransactionType varchar(15) check (TransactionType in ('Debit', 'Credit')),
Amount money not null,
TransactionDate datetime default getdate()
);

DROP TABLE Transactions;

CREATE TABLE Transactions (
    TransactionID int PRIMARY KEY IDENTITY(1,1), -- Handles the ID automatically
    AccountID int,
    TransactionType varchar(15),
    Amount money,
    TransactionDate datetime DEFAULT GETDATE(),
    
    -- This keeps the relationship you mentioned
    CONSTRAINT FK_AccountTransactions FOREIGN KEY (AccountID) 
    REFERENCES Accounts(AccountID)
);



create table AuditLog 
(
AuditID int primary key identity(1,1),
TableName varchar(30) not null,
ActionType varchar(30) not null,
ActionDate datetime default getdate(),
Description varchar(max)
);

insert into Clients
values
(100, 'Katleho', 250000);

insert into Accounts
values
(001, 100, 'Savings', 5000);

CREATE TRIGGER tr_UpdateAccountBalance
ON Transactions
AFTER INSERT
AS
BEGIN
    -- 1. Declare the variables
    DECLARE @AccountID int;
    DECLARE @Amount money;
    DECLARE @TransactionType varchar(15);

    -- 2. Pull the ACTUAL column values from the 'inserted' table
    SELECT @AccountID = AccountID, 
           @Amount = Amount, 
           @TransactionType = TransactionType
    FROM inserted;

    -- 3. Logic for Credit
    IF @TransactionType = 'Credit'
    BEGIN
        UPDATE Accounts
        SET Balance = Balance + @Amount -- Added 'Balance =' here
        WHERE AccountID = @AccountID;
    END

    -- 4. Logic for Debit
    IF @TransactionType = 'Debit'
    BEGIN
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @AccountID;
    END
END

CREATE TRIGGER tr_AuditTransactions
ON Transactions
AFTER INSERT
AS
BEGIN
    -- 1. Use specific names for your variables
    DECLARE @LogTransactionID int; 
    DECLARE @LogType varchar(15);
    DECLARE @LogAmount money;

    -- 2. Pull the specific TransactionID from the inserted row
    SELECT @LogTransactionID = TransactionsID, 
           @LogType = TransactionType, 
           @LogAmount = Amount 
    FROM inserted;

    -- 3. Insert into AuditLog using the specific TransactionID in the description
    INSERT INTO AuditLog (TableName, ActionType, Description)
    VALUES (
        'Transactions', 
        'INSERT', 
        'New ' + @LogType + ' recorded. TransactionID: ' + CAST(@LogTransactionID AS varchar) + '. Amount: ' + CAST(@LogAmount AS varchar)
    );
END


CREATE TRIGGER tr_PreventDeleteTransactions
ON Transactions
INSTEAD OF DELETE
AS
BEGIN
    -- This command stops the delete and shows the specific message required
    RAISERROR ('Deleting financial transactions is not allowed.', 16, 1);
    
    -- ROLLBACK ensures the data stays exactly where it is
    ROLLBACK TRANSACTION;
END


CREATE TRIGGER tr_PreventNegativeBalance
ON Accounts
AFTER UPDATE
AS
BEGIN
    -- Check if the new balance after the update is less than zero
    IF EXISTS (SELECT 1 FROM inserted WHERE Balance < 0)
    BEGIN
        -- 1. Show the meaningful error message
        RAISERROR ('Transaction failed: Account balance cannot go below zero.', 16, 1);

        -- 2. Undo the transaction (Rollback)
        ROLLBACK TRANSACTION;
    END
END


-----Bonus Work---

ALTER TRIGGER tr_PreventNegativeBalance
ON Accounts
AFTER UPDATE
AS
BEGIN
    -- Changed the check from 0 to -5000
    IF EXISTS (SELECT 1 FROM inserted WHERE Balance < -5000)
    BEGIN
        RAISERROR ('Transaction failed: Overdraft limit of R5,000 exceeded.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END


----number 2----

CREATE TABLE ReversalTransactions (
    ReversalID int PRIMARY KEY IDENTITY(1,1),
    OriginalTransactionID int,
    AccountID int,
    Amount money,
    ReversalReason varchar(255),
    ReversalDate datetime DEFAULT GETDATE()
);


-----number 3-----

CREATE TRIGGER tr_SyncClientBalance
ON Accounts
AFTER UPDATE
AS
BEGIN
    -- Update the Client table whenever the Account table changes
    UPDATE Clients
    SET AccountBalance = i.Balance
    FROM Clients c
    INNER JOIN inserted i ON c.ClientID = (SELECT ClientID FROM Accounts WHERE AccountID = i.AccountID);
END


---number 4---

CREATE TRIGGER tr_AuditChangesAndDeletes
ON Transactions
AFTER UPDATE, DELETE
AS
BEGIN
    DECLARE @Action varchar(20);
    
    -- Figure out if the action was a Delete or an Update
    SET @Action = CASE 
        WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) THEN 'UPDATE'
        WHEN EXISTS(SELECT * FROM deleted) THEN 'DELETE'
    END;

    INSERT INTO AuditLog (TableName, ActionType, Description)
    VALUES (
        'Transactions', 
        @Action, 
        'Security Alert: Attempted ' + @Action + ' on transaction record.'
    );
END

----Test 1---

INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES
(1, 'CREDIT', 2000)

---Test 2---

INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES
(1, 'Debit', 1000);

---Test 3---

Delete from Transactions where TransactionID = 1;

---test 4---

Insert into Transactions (AccountID, TransactionType, Amount)
values (1, 'Debit', 1000);





delete from Transactions;
update Accounts set Balance = 5000;
delete from AuditLog

insert into Transactions (AccountID, TransactionType, Amount)
values
(1, 'Credit', 2000);


insert into Transactions (AccountID, TransactionType, Amount)
values
(1, 'Debit', 1000);

select * from Transactions 

delete from Transactions where AccountID = 1;