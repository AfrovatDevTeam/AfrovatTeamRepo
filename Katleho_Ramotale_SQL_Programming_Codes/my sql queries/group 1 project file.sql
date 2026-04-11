create database stores

--- CREATE PARENT TABLES
-- Stores Table
CREATE TABLE Stores (
    StoreID INT PRIMARY KEY IDENTITY(1,1),
    StoreName VARCHAR(100) NOT NULL,
    Location VARCHAR(150),
    Email VARCHAR(100) UNIQUE,
    CreatedAt DATETIME DEFAULT GETDATE() -- Auto-timestamp
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) DEFAULT 0.00 CHECK (Price >= 0) -- Constraint: No negative prices
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE CHECK (Email LIKE '%@%.%'), -- Constraint: Valid email format
    JoinDate DATE DEFAULT CAST(GETDATE() AS DATE)
);

--- 3. CREATE CHILD TABLES (With Foreign Keys)
-- Inventory Table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    StoreID INT NOT NULL,
    ProductID INT NOT NULL,
    StockLevel INT DEFAULT 0 CHECK (StockLevel >= 0),
    LastUpdated DATETIME DEFAULT GETDATE(),
    
    -- Link to Stores and Products
    CONSTRAINT FK_Inventory_Stores FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    CONSTRAINT FK_Inventory_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    StoreID INT NOT NULL,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT DEFAULT 1 CHECK (Quantity > 0),
    SaleDate DATETIME DEFAULT GETDATE(),
    
    -- Link to Stores, Customers, and Products
    CONSTRAINT FK_Sales_Stores FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    CONSTRAINT FK_Sales_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Sales_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 1. STORES
INSERT INTO Stores (StoreName, Location, Email)
VALUES 
    ('Shoprite Soweto', 'Chris Hani Rd, Soweto', 'soweto@shoprite.co.za'),
    ('Checkers Rosebank', 'Rosebank Mall, JHB', 'rosebank@checkers.co.za'),
    ('Pick n Pay Waterfront', 'V&A Waterfront, CPT', 'waterfront@pnp.co.za');

-- 2. PRODUCTS
INSERT INTO Products (ProductName, Category, Price)
VALUES 
    ('Tastic Rice 2kg', 'Dry Goods', 36.99),
    ('Clover Milk 2L', 'Dairy', 38.50),
    ('Albany White Bread', 'Bakery', 18.90),
    ('Mrs Balls Chutney', 'Sauces', 45.00),
    ('Castle Lite 6-Pack', 'Beverages', 98.00);

-- 3. CUSTOMERS
INSERT INTO Customers (FirstName, LastName, Email)
VALUES 
    ('Thabo', 'Mokoena', 'thabo.m@mail.co.za'),
    ('Zanele', 'Khoza', 'zanele.k@webmail.co.za'),
    ('Pieter', 'Botha', 'pieter.b@outlook.com');


-- 4. INVENTORY (Setting initial stock levels)
INSERT INTO Inventory (StoreID, ProductID, StockLevel)
VALUES 
    (1, 1, 100), -- Soweto has 100 Rice
    (1, 2, 50),  -- Soweto has 50 Milk
    (2, 3, 200), -- Rosebank has 200 Bread
    (3, 4, 30),  -- Waterfront has 30 Chutney
    (3, 5, 80);  -- Waterfront has 80 Castle Lite

-- 5. SALES (Recording transactions)
-- Notice we only provide IDs and Quantities; the rest is automatic!
INSERT INTO Sales (StoreID, CustomerID, ProductID, Quantity)
VALUES 
    (1, 1, 1, 2), -- Thabo bought 2 Rice at Soweto
    (2, 2, 3, 1), -- Zanele bought 1 Bread at Rosebank
    (3, 3, 5, 2), -- Pieter bought 2 Castle Lite packs at Waterfront
    (1, 2, 2, 3); -- Zanele bought 3 Milks at Soweto

	SELECT 
    S.StoreName, 
    C.FirstName + ' ' + C.LastName AS Customer, 
    P.ProductName, 
    Sa.Quantity, 
    Sa.SaleDate
FROM Sales Sa
JOIN Stores S ON Sa.StoreID = S.StoreID
JOIN Customers C ON Sa.CustomerID = C.CustomerID
JOIN Products P ON Sa.ProductID = P.ProductID;

WITH MonthlySales AS (
    SELECT 
        S.StoreName,
        FORMAT(Sa.SaleDate, 'yyyy-MM') AS SaleMonth,
        SUM(Sa.Quantity * P.Price) AS TotalRevenue
    FROM Sales Sa
    JOIN Stores S ON Sa.StoreID = S.StoreID
    JOIN Products P ON Sa.ProductID = P.ProductID
    GROUP BY S.StoreName, FORMAT(Sa.SaleDate, 'yyyy-MM')
),
SalesTrends AS (
    SELECT 
        StoreName,
        SaleMonth,
        TotalRevenue,
        LAG(TotalRevenue) OVER (PARTITION BY StoreName ORDER BY SaleMonth) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT 
    StoreName,
    SaleMonth,
    TotalRevenue,
    CASE 
        WHEN PreviousMonthRevenue IS NULL THEN 'New Month/No Data'
        WHEN TotalRevenue > PreviousMonthRevenue THEN 'Growth'
        WHEN TotalRevenue < PreviousMonthRevenue THEN 'Losing Sales'
        ELSE 'Stable'
    END AS PerformanceStatus
FROM SalesTrends;

SELECT 
    C.FirstName + ' ' + C.LastName AS CustomerName,
    COUNT(S.SaleID) AS TotalVisits,
    SUM(S.Quantity) AS TotalItemsBought,
    -- Calculates the average spend per visit
    CAST(AVG(S.Quantity * P.Price) AS DECIMAL(10,2)) AS AvgSpendPerVisit,
    -- Labels customers based on their loyalty
    CASE 
        WHEN COUNT(S.SaleID) >= 3 THEN 'VIP / Loyal'
        WHEN COUNT(S.SaleID) BETWEEN 1 AND 2 THEN 'Regular'
        ELSE 'New'
    END AS LoyaltyStatus
FROM Customers C
LEFT JOIN Sales S ON C.CustomerID = S.CustomerID
LEFT JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.FirstName, C.LastName
ORDER BY TotalVisits DESC, AvgSpendPerVisit DESC;


SELECT 
    S.StoreName,
    P.ProductName,
    I.StockLevel,
    -- Calculate how many units have been sold in total
    ISNULL(SUM(Sa.Quantity), 0) AS UnitsSold,
    -- Determine the Stock Status
    CASE 
        WHEN I.StockLevel <= 10 THEN 'CRITICAL: Restock Urgent'
        WHEN I.StockLevel > 50 AND ISNULL(SUM(Sa.Quantity), 0) = 0 THEN 'Dead Stock: Remove/Discount'
        WHEN I.StockLevel BETWEEN 11 AND 50 THEN 'Healthy'
        ELSE 'Sufficient'
    END AS StockStatus
FROM Inventory I
JOIN Stores S ON I.StoreID = S.StoreID
JOIN Products P ON I.ProductID = P.ProductID
LEFT JOIN Sales Sa ON I.ProductID = Sa.ProductID AND I.StoreID = Sa.StoreID
GROUP BY S.StoreName, P.ProductName, I.StockLevel
ORDER BY I.StockLevel ASC;


