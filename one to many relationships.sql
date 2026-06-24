Create table StaffSalary
(
ID int primary key not null,
Name varchar(45) not null,
Surname varchar(56) not null,
Salary money not null
);

insert into StaffSalary
values
(100, 'Francis', 'Anosike', 5000),
(200, 'Sara', 'Martins', 15000),
(300, 'Wendy', 'Mesh', 50000),
(400, 'Mark', 'Owen', 20000),
(500, 'John', 'Webs', 10000);

select * from StaffSalary

Create table Department
(
DepartmentID int primary key not null,
DpartmentName varchar(45) not null
)

Alter table Department
--add ID int--

--Alter table Department
--add Foreign key (ID)
--references StaffSalary (ID)--

insert into Department
values
(400, 'HR', 100),
(300, 'Firedrill', 200),
(600, 'Receptionist', 300),
(900, 'Finance', 400), 
(800, 'Payroll', 500);

select * from Department 