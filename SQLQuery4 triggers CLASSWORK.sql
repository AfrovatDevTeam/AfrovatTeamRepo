CREATE TABLE Employee4(
 Id INT PRIMARY KEY,
 Name VARCHAR(45),
 Salary INT,
 Gender VARCHAR(12),
 DepartmentId INT
 );

INSERT INTO Employee4 VALUES 
(1,'Phillips', 82000, 'Male', 3),
 (2,'Jennifer', 52000, 'Female', 2),
 (3,'Mbulelo', 25000, 'male', 1),
 (4,'Kamo', 47000, 'Male', 2),
 (5,'Priya', 46000, 'Female', 3);

CREATE TABLE Employee_Audit_Test2
(
 Id int IDENTITY,
 Audit_Action text
 )

---WE ARE NOW CREATING A TRIGGER, STORING RECORDS OF EACH deletion ON EMP TBL.
 CREATE TRIGGER trDeleteEmployee21
 ON Employee4
 FOR DELETE
 AS
 BEGIN
 Declare @Id int
 SELECT @Id = Id from deleted
 INSERT INTO Employee_Audit_Test2
 VALUES ('An existing employee with Id = ' + CAST(@Id AS VARCHAR(10)) + 
 ' is deleted at ' + CAST(Getdate() AS VARCHAR(22)))
 END

 DELETE from Employee4 WHERE Id = 2;

 Select * from Employee_Audit_Test2;
 
 select * from Employee4;

 ---1? Main table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

Audit / Log table
CREATE TABLE Employee_Audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    emp_id INT,
    action_type VARCHAR(20),
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    action_date DATETIME DEFAULT GETDATE()
);

---2? AFTER INSERT Trigger 

CREATE TRIGGER trg_AfterInsert_Employees
ON Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Employee_Audit (emp_id, action_type)
    SELECT emp_id, 'INSERT'
    FROM inserted;
END;

-------------------

----3? AFTER UPDATE Trigger

CREATE TRIGGER trg_AfterUpdate_Employees
ON Employees
AFTER UPDATE
AS
BEGIN
    INSERT INTO Employee_Audit (emp_id, action_type, old_salary, new_salary)
    SELECT 
        i.emp_id,--- i is our alias and emp_id column name
        'UPDATE',--- who is this update? string 
        d.salary AS old_salary,--- d is our alias, salary column name
        i.salary AS new_salary--- i is our alias and salary is column name 
    FROM inserted i--- what have we inserted and where? employees
    INNER JOIN deleted d--- is d the deleted part of the table?
        ON i.emp_id = d.emp_id;
END;

---------------

---4? AFTER DELETE Trigger

CREATE TRIGGER trg_AfterDelete_Employees
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO Employee_Audit (emp_id, action_type, old_salary)
    SELECT emp_id, 'DELETE', salary
    FROM deleted;
END;
----------------

---Lets do a Quick Test
INSERT INTO Employees VALUES (1, 'Steven', 'IT', 50000);

UPDATE Employees
SET salary = 55000
WHERE emp_id = 1;

DELETE FROM Employees
WHERE emp_id = 1;

SELECT * FROM Employee_Audit;