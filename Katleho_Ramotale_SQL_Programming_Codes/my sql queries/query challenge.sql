create database bonuscheck

create table Artists
(
ArtistID int primary key identity(1,1),
ArtistName varchar(100) not null,
Email varchar(100) not null,
Genre varchar(50) not null
)

create table Songs
(
SongID int primary key identity(1,1),
Title varchar(100) not null,
ReleaseDate date not null,
Plays int not null,
ArtistID int foreign key references Artists(ArtistID)
)

insert into Artists
values
('RapCat', 'RapCat@gmail.com', 'HipHop'),
('ProKid', 'Dankiesanrecords@gmail.com', 'KasiRap'),
('HHP', 'MotswakoRec@gmail.com', 'Motswako'),
('Mpura', 'Mpurabookings@gmail.com', 'Amapiano');

insert into Songs
values
('MyLife', '20240808', 99000, 1),
('Lotto', '20260201', 50000, 2),
('Winner', '20220306', 10000, 3),
('Yebo', '20230507', 9000, 4);


SELECT DISTINCT 
    A.ArtistName, 
    A.Email 
FROM Artists A                   
JOIN Songs S ON A.ArtistID = S.ArtistID     
WHERE A.Genre = 'KasiRap' 
  AND YEAR(S.ReleaseDate) = 2026 
  AND S.Plays > 40000;