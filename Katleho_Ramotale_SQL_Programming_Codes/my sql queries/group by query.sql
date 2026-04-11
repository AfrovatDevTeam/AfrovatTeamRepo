create table Customer
(
CUSTID int primary key not null,
Years varchar(50) not null,
Amount money not null
)

insert into Customer
values
(108, '2010', 100),
(101, '2010', 100),
(102, '2010', 200),
(103, '2011', 300),
(104, '2012', 400),
(105, '2012', 500),
(106, '2011', 600),
(107, '2012', 700);

--group by query---
select years, SUM(Amount) from Customer
group by Years