CREATE TABLE Employee3(
 Id INT PRIMARY KEY,
 Name VARCHAR(45),
 Salary INT,
 Gender VARCHAR(12),
 DepartmentId INT
 );

 INSERT INTO Employee3 VALUES 
(1,'Phillips', 82000, 'Male', 3),
 (2,'Jennifer', 52000, 'Female', 2),
 (3,'Mbulelo', 25000, 'male', 1),
 (4,'Kamo', 47000, 'Male', 2),
 (5,'Priya', 46000, 'Female', 3);

 SELECT * FROM Employee3 

 CREATE TABLE Employee_Audit_Test1
(
 Id int IDENTITY,
 Audit_Action text
 );

 ---We are creating a TRIGGER, STORING RECORDS OF EACH INSERTION ON EMP TBL.---
 CREATE trigger  trg_EmployeeDelete10
ON Employee3
FOR DELETE
AS
BEGIN
    DECLARE @Id INT;
    SELECT @Id = Id FROM deleted;

   
    INSERT INTO Employee_Audit_Test1 (Audit_Action) 
    VALUES ('Employee deleted with Id = ' + CAST(@Id AS VARCHAR(10)) + ' at ' + CAST(GETDATE() AS VARCHAR(22)));
END;



DELETE FROM Employee3 WHERE ID = 4;


SELECT * FROM Employee_Audit_Test1;


