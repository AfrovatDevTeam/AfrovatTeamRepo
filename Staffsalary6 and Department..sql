Create table staffSalary6
 (
    ID int PRIMARY KEY NOT NULL,
    Name varchar(45) NOT NULL,
    Surname varchar(56) NOT NULL,
    Salary money NOT NULL
);
INSERT INTO staffSalary6(ID, Name, Surname, Salary)
VALUES
(100, 'Francis', 'Anosike', 5000),
(200, 'Sara', 'Martins', 15000),
(300, 'Wendy', 'Mesh', 50000),
(400, 'Mark', 'Owen', 20000),
(500, 'John', 'Webs', 10000);

SELECT * FROM staffSalary6;

CREATE TABLE Department2
(
    DepartmentID int PRIMARY KEY NOT NULL,
    DepartmentName varchar(45) NOT NULL,
    ID int NOT NULL,
    CONSTRAINT FK_Department_StaffSalary6
        FOREIGN KEY (ID) REFERENCES StaffSalary6(ID)
);
INSERT INTO Department2(DepartmentID, DepartmentName, ID)
VALUES
(400, 'HR', 100),
(300, 'Firedrill', 200),
(600, 'Receptionist', 300),
(900, 'Finance', 400),
(800, 'Payroll', 500);

SELECT * FROM Department2;

--ALTER TABLE Department2
--ADD  Foreign Key (ID)
 --REFERENCES StaffSalary6(ID)-- 

ALTER TABLE Department ADD ID int;

INSERT INTO Department2 (DepartmentID, DepartmentName, ID)
VALUES
(400, 'HR', 100),
(300, 'Firedrill', 200),
(600, 'Receptionist', 300),
(900, 'Finance', 400),
(800, 'Payroll', 500);