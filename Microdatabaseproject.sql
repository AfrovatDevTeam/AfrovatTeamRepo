Create database MacroDataBase

CREATE TABLE StaffLogin1 (
    Stafford INT PRIMARY KEY NOT NULL,
    StaffUsername VARCHAR(55) NOT NULL,
    StaffPassword VARCHAR(55) NOT NULL
);

INSERT INTO StaffLogin1 
VALUES (1, 'admin', 'password123');

Select * from StaffLogin1

CREATE TABLE Products1 (
    ProductID INT PRIMARY KEY NOT NULL,
    ProductName VARCHAR(56) NOT NULL,
    Description VARCHAR(55) NOT NULL,
    Soldby VARCHAR(55) NOT NULL,
    Quantity VARCHAR(55) NOT NULL,
    Amount VARCHAR(55) NOT NULL
);

select * from Products1