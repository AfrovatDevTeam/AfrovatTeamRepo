create table product 
(
ID INT primary key not null,
Name varchar(45) not null,
Item varchar(56) not null,
Amount money not null, 
Quantity INT not null
); 
insert into Product values 
(100, 'TV', 'Tv stand', 300, 1),
(200, 'shoes', 'collections', 1000, 3),
(300, 'cars', 'automobile', 90000, 6),
(400, 'laptops', 'computer', 13000, 5);
select* From Product;
Select * from product 
order by ID DESC;
Select * FROM Product 
Order by Name ASC;
Select * From Product 
order by Amount DESC;




