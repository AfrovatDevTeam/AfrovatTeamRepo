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

create trigger tr_AuditTransactions
on Transactions 
after insert 
as
begin
declare @TransactionsID int;
declare @TransactionsType varchar(15);
declare @Amount money;

select @TransactionsID = TransactionsID,
@TransactionsType = @TransactionsType,
@Amount = @Amount
from inserted;

insert into AuditLog (TableName, ActionType, Description)
values 
('Transactions,
'insert',
'new' + @TransactionsType + 'added.TransactionsID:' + cast(@TransactionsID as varchar) 
+ '.Amount.' + cast(@Amount as varchar)
);
end