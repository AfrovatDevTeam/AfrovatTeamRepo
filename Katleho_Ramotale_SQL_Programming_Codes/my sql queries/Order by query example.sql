create table Product
(
ID int primary key not null,
Name varchar(45) not null,
Item varchar(56) not null,
Amount money not null,
Quantity int not null
)

insert into Product
values
(100, 'TV', 'Tv stand', 300, 1),
(200, 'shoes', 'collections', 1000,3),
(300, 'cars', 'automobile', 90000, 5),
(400, 'laptops', 'computer', 1300, 7);

select * from Product

--order by is used to sort data in a table either in Asc or Desc order--
select * from Product
order by ID asc

select top 2 * from Product