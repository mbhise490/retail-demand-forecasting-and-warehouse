/*
==========================================================
Create and Load Country Dimension
==========================================================
Purpose:
- Store unique countries from the sales data
- Generate a surrogate key for each country
- Reduce data redundancy in the fact table
- Support country-wise sales analysis and reporting
==========================================================
*/


IF OBJECT_ID('gold.dim_country','U') IS NOT NULL
DROP TABLE gold.dim_country;
GO

CREATE TABLE gold.dim_country
(
    Country_Key INT IDENTITY(1,1) PRIMARY KEY,
    Country VARCHAR(100)
);
GO

INSERT INTO gold.dim_country
(
Country
)
SELECT DISTINCT
Country
FROM silver.online_retail;