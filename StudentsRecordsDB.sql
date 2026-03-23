create database StudentsRecodsDB

Create table StudentLogin
(
ID int primary key not null,
Username varchar(45) not null,
Password varchar(45) not null
)
insert into StudentLogin
values (1, 'Francis', '123');

create table StudentReg
(
ID int primary key not null,
Name varchar(56) not null,
Surname varchar(56) not null,
Address varchar(56) not null,
RegFees varchar(56) not null
)