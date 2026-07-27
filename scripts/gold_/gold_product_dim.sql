/*
==========================================================
Create and Load Product Dimension
==========================================================
Purpose:
- Store unique product information
- Generate a surrogate key for each product
- Maintain product details for sales analysis
- Support product-based reporting and analytics
==========================================================
*


IF OBJECT_ID('gold.dim_product','U') IS NOT NULL
DROP TABLE gold.dim_product;
GO

CREATE TABLE gold.dim_product
(
    Product_Key INT IDENTITY(1,1) PRIMARY KEY,
    StockCode VARCHAR(30),
    Description VARCHAR(255)
);
GO

INSERT INTO gold.dim_product
(
StockCode,
Description
)
SELECT DISTINCT
StockCode,
Description
FROM silver.online_retail;