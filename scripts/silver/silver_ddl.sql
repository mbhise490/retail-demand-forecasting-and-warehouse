-- ==========================================================
-- Silver Layer : Cleaned Online Retail Table
-- Stores cleaned and standardized data from the Bronze layer
-- ==========================================================

IF OBJECT_ID('silver.online_retail','U') IS NOT NULL
    DROP TABLE silver.online_retail;
GO

CREATE TABLE silver.online_retail
(
    InvoiceNo INT NOT NULL,
    InvoiceType NVARCHAR(30) NOT NULL,
    StockCode NVARCHAR(20) NOT NULL,
    Description NVARCHAR(255) NOT NULL,
    Quantity   INT NOT NULL,
    InvoiceDate DATETIME2 NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CustomerID INT NOT NULL,
    Country NVARCHAR(100) NOT NULL
);

