Create Database SARetail1

CREATE TABLE Stores;
---Which stores make the most money each month,
---Which ones are starting to lose sales?
CREATE TABLE Products();

CREATE TABLE Sales();

CREATE TABLE Inventory Levels();

---who are the loyal 'repeat' customers
--what is the average amount a person spends per visit? = AVG()
--- Which items are about to run out (stock-out-risk)
---Which items are just sitting on the self taking up space (dead stock)?

CREATE TABLE Stores

BULK INSERT Sample- Superstore 
FROM 'C:\Temp\Sample- Superstore data CSV.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);