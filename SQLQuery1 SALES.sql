--how do we add one or more columns to a table 
--use ALTER 

CREATE TABLE Sales
 (
   quotation_no INT IDENTITY PRIMARY KEY,
   valid_from DATE NOT NULL,
   valid_to DATE NOT NULL
   );
   --ADD NEW COLUMN
ALTER TABLE Sales
ADD
 amount DECIMAL (10,2) NOT NULL,
 customer_name VARCHAR (50) NOT NULL;

