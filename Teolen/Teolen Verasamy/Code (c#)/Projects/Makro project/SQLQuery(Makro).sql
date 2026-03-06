create database MakroDB
create table StaffLogin
(
Stafford int primary key not null,
StaffUsername varchar (55) not null,
StaffPassword varchar (55) not null,
)
insert into StaffLogin 
values(1,'Teolen','123');

create table Products
(
	ProductID int Primary key not null,
	ProductName varchar (56) not null,
	Description varchar (55) not null,
	Soldby varchar (55) not null,
	Quantity varchar (55) not null,
	Amount varchar (55) not null,
)
select * from Products









