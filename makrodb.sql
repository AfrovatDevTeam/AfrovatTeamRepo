create database MakroDB

Create Table StaffLogin
( 
Stafford int primary key not null,
StaffUsername varchar (55) not null,
StaffPassword varchar (55) not null,
)

Insert into StaffLogin
values 
(2,'Abby','1223')

Create Table Products
(
ProductID int Primary key not null,
ProductName varchar (56) not null,
Description varchar (55) not null,
Soldby varchar (55) not null,
Quantity varchar (55) not null,
Amount varchar (55) not null,
);