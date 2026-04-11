create table ArtistRoyalties
(
ID int primary key not null,
Name varchar(45) not null,
Surname varchar(45) not null,
Royalties money not null
);

insert into ArtistRoyalties
values
(100, 'Kay', 'Claude', 10000),
(200, 'Seac', 'Adkins', 20000),
(300, 'RapCat', 'RSA', 90000),
(400, 'Frank', 'Ocean', 3000),
(500, 'Slim', 'Shady', 6000);

select * from ArtistRoyalties

select IIF (Royalties >= 1000, 'POSITIVE OUTCOME', 'NEGATIVE OUTCOME') from
ArtistRoyalties

select ID, Name, Surname,
Case
 when Royalties <=10000 then 'Bad Stats'
 when Royalties >=20000 then 'Good perfomance'
 when Royalties =90000 then 'Exceptional Stats'
 when Royalties =3000 then 'etremely poor perfomance'
 else 'Never a good stats or perfomance'
 end as Outcome 
 from ArtistRoyalties

