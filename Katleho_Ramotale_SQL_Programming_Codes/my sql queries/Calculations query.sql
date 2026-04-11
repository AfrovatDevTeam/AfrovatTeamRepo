create schema ite


create table ite.INFODATA1
(
CaseID int primary key not null,
Name varchar(60) not null,
Surname varchar(60) not null,
Gender varchar(60) not null,
Salary money not null,
Age int not null,
Place varchar(60) not null,
weight decimal not null,
Company varchar(60) not null,
AcademicDegree varchar(60) not null
)

insert into ite.INFODATA1
values
(1, 'Synthia', 'Williams', 'Female', 1500, 33, 'Chicago', 80, 'BMW', 'Bachelor'),
(2, 'Selina', 'Gomez', 'Female', 1200, 33, 'Chicago', 82.5, 'Ford', 'NO'),
(3, 'Terry', 'Cruz', 'Male', 2200, 34, 'NewYork', 100.8, 'BMW', 'Bachelor'),
(4, 'Donald', 'Trump', 'Male', 2100, 42, 'NewYork', 90, 'BMW', 'Master'),
(5, 'Ambessa', 'Ford', 'Female', 1500, 29, 'Chicago', 67, 'Ford', 'Master'),
(6, 'Angelina', 'Jolie', 'Female', 1700, 19, 'Washington', 60, 'Ford', 'Master'),
(7, 'Victor', 'Hernandez', 'Male', 3000, 50, 'Washington', 77, 'Ford', 'No'),
(8, 'Cyril', 'Ramaphosa', 'Male', 3000, 55, 'Washington', 77, 'Ford', 'Bachelor'),
(9, 'Beyonce', 'Carter', 'Female', 2800, 31, 'NewYork', 87, 'Ford', 'Bachelor'),
(10, 'Nipssey', 'Hussle', 'Male', 2900, 46, 'NewYork', 70, 'GM', 'Master'),
(11, 'Amber', 'Rose', 'Female', 2780, 36, 'Washington', 57, 'BMW', 'No'),
(12, 'John', 'Scena', 'Male', 2550, 48, 'NewYork', 64, 'GM', 'Master');

select * from ite.INFODATA1

--Total of Salary--
select SUM(Salary) from ite.INFODATA1

=27230.00

--Average Salary--
select AVG(Salary) from ite.INFODATA1

=2269,1666
=2269,70

--Max Salary earned--
select MAX(Salary) from ite.INFODATA1

=3000,00

--Minumum Salary earned--
select MIN(Salary) from ite.INFODATA1

1200

--how many people with age on data--
select COUNT(Age) from ite.INFODATA1

=12

--find square root of weight from person 9--

select SQRT(31)

=5,5677
=5,57