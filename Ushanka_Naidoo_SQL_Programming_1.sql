Create table Employee
(
EmpID int Primary Key,
Name Varchar(50) not null,
Surname Varchar(50) not null,
IDNumber Char(13) not null,
ContactNumber Varchar(20) not null,
IsManager bit null,
Username Varchar(20) not null,
Password Varchar(20) not null
);
Insert into Employee
Values
(100,'Kaylin','Kuni','9901011234083','0744839111','1','Kuni27','990927'),
(200,'Josi','Bongani','8805055678082','0724142993','0 ','JosiBo05','147896'),
(300,'Lebogang','Busi','8825102857081','0619879793','1','LeboB21@gmail.com','369258'),
(400,'Ushanka','Pillay','0112270268082','0604173182','0 ','Shankie06@gmail.com','300906'),
(500,'Denver','Paul','9901011234083','0744839111','1','DenverP0','271610');
Select * from Employee

Create Table Stock  
(
StockID INT Primary key,
StockName Varchar(50) not null,
Barcode Varchar(50) not null,
UnitPrice Decimal(8,2) not null,
Qty Int null
);
Insert into Stock
Values
(1, 'coke 500ml','601123456789',12.50,1000),
(2,'water 500ml','600123456789',9.00,1500),
(3,'Juice 1 liter','602123456789',10.50,1000);  

Create table Category
(
CatID int Primary key,
Type Varchar(20) not null, 
Description Varchar(max) not null
);
Insert into Category
Values
(1,'Drinks',' Beverages Including Cold drinks'),
(2,'Drinks','Beverages Including Water'),
(3,'Drinks','Beverages Including Juice');

Create table Suppliers
(
SupID int Primary Key,
Name Varchar(50) not null,
Dateadded date not null,
ContactNumber Varchar(20) not null,
Email Varchar(max) not null, 
Address Varchar(max) not null,
Balance Decimal(8,2) not null
);

Insert into Suppliers
Values

(1,'ABC Suppliers','2024-01-10','0712345678','abc@gmail.com','Durban',2500.00),
(2,'Fresh Drinks Co','2024-02-05','0723456789','freshdrinks@gmail.com','Johannesburg',1800.50),
(3,'Water World','2024-02-15','0734567890','waterworld@gmail.com','Cape Town',3200.00);

SELECT * FROM Suppliers;

Create table Sales 
(
SalesID int Primary Key,
Timestamp Date not null
);
INSERT INTO Sales
VALUES
(1,'2024-03-01'),
(2,'2024-03-02'),
(3,'2024-03-03'),
(4,'2024-03-04');
SELECT * FROM Sales;