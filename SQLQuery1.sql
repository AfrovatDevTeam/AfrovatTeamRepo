create table Customer 
(
CUSTID INT PRIMARY KEY NOT NULL, 
YEARS VARCHAR(50) NOT NULL, 
AMOUNT MONEY NOT NULL
);

INSERT INTO CUSTOMER VALUES 
(108, '2010', 100),
(101, '2010', 100),
(102, '2010', 200),
(103, '2011', 300),
(104, '2012', 400),
(105, '2012', 500),
(106, '2011', 600),
(107, '2012', 700);

select years, sum(Amount)  FROM Customer
group by Years

--group by clause--
select sum(Amount), Years  FROM Customer
group by Years 

--Having clause--
select sum(Amount), Years  FROM Customer
group by Years 
Having Sum (Amount) >900

