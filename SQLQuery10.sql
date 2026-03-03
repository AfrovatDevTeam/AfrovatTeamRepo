
---1️ Main table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

 --Audit / Log table
CREATE TABLE Employee_Audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    emp_id INT,
    action_type VARCHAR(20),
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    action_date DATETIME DEFAULT GETDATE()
);
---2️ AFTER INSERT Trigger 

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

----3️ AFTER UPDATE Trigger

CREATE TRIGGER trg_AfterUpdate_Employees
ON Employees
AFTER UPDATE
AS
BEGIN
    INSERT INTO Employee_Audit (emp_id, action_type, old_salary, new_salary)
    SELECT 
        i.emp_id,
        'UPDATE',
        d.salary AS old_salary,
        i.salary AS new_salary
    FROM inserted i
    INNER JOIN deleted d
        ON i.emp_id = d.emp_id;
END;

---------------

---4️ AFTER DELETE Trigger

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


