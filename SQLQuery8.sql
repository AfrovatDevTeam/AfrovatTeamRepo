Create Database SARetail1

-- Create Table for Sample_ Superstore
CREATE TABLE [Sample_Superstore] (
    [Row ID] INT NOT NULL,
    [Order ID] NVARCHAR(50),
    [Order Date] DATETIME,
    [Ship Date] DATETIME,
    [Ship Mode] NVARCHAR(50),
    [Customer ID] NVARCHAR(50),
    [Customer Name] NVARCHAR(100),
    [Segment] NVARCHAR(50),
    [Country] NVARCHAR(50),
    [City] NVARCHAR(50),
    [State] NVARCHAR(50),
    [Postal Code] INT,
    [Region] NVARCHAR(50),
    [Product ID] NVARCHAR(50),
    [Category] NVARCHAR(50),
    [Sub-Category] NVARCHAR(50),
    [Product Name] NVARCHAR(255),
    [Sales] DECIMAL(18, 4),
    [Quantity] INT,
    [Discount] DECIMAL(18, 4),
    [Profit] DECIMAL(18, 4),
    -- Defining Row ID as Primary Key
    CONSTRAINT PK_Sample_Superstore PRIMARY KEY ([Row ID])
);
2. Bulk Insert Templates
For SQL Server 2017 and Newer:
This version supports the FORMAT = 'CSV' argument, which is the most reliable way to handle commas and quotes.

SQL
BULK INSERT [Sample_Superstore]
FROM 'C:\Temp\Sample- Superstore data CSV'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
For SQL Server 2016 and Older:
Since older versions do not recognize the FORMAT keyword, you must use a standard bulk insert. Note that if your data contains commas within text fields, you may need a format file.

SQL
BULK INSERT [Sample_Superstore]
FROM 'C:\Path\To\Sample - Superstore.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', -- Hex for \n (Line Feed)
    TABLOCK
);

SELECT SERVERPROPERTY('InstanceDefaultDataPath') AS DataPath;