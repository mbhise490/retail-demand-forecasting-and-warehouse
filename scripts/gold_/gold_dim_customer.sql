/*
==========================================================
Create and Load Customer Dimension
==========================================================
Purpose:
- Store unique customer information
- Generate a surrogate key for each customer
- Classify customers as Guest or Registered
- Support customer-based analysis and reporting
==========================================================
*/


IF OBJECT_ID('gold.dim_customer','U') IS NOT NULL
DROP TABLE gold.dim_customer;
GO

CREATE TABLE gold.dim_customer
(
    Customer_Key INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    Customer_Type VARCHAR(20)
);
GO

INSERT INTO gold.dim_customer
(
CustomerID,
Customer_Type
)
    SELECT DISTINCT
    CustomerID,
    CASE
        WHEN CustomerID=-1 THEN 'Guest'
        ELSE 'Registered'
    END
FROM silver.online_retail;