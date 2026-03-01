create table StaffSalary3
(
ID int primary key not null,
Name varchar (45) not null,
Surname varchar (56) not null,
Salary money not null
);
Insert into StaffSalary3
Values 
(100,'Francis','Anosike', 5000),
(200, 'Sarah','Martins', 15000),
( 300,'Wendy','Mesh', 50000),
( 400,'Mark','Owen', 20000),
( 500,'John','Webs', 10000);
Select * from StaffSalary3

Select IIF (Salary >=10000, 'Good Salary','Poor Salary')
From StaffSalary3
Select ID,Name,Case
when Salary = 10000 then 'Good salary'
when Salary=20000 then 'Good Salary'
when Salary = 15000 then 'Good Salary'
when Salary =50000 then 'Extremely Good Salary'
when Salary = 5000 then 'Poor Salary'
else 'never a good salary'
end as Result 
from StaffSalary3