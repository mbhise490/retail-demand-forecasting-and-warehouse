/*
===============================================================================
DDL Script: Create Bronze Table
===============================================================================
*/

IF OBJECT_ID('bronze.online_retail','U') IS NOT NULL
    DROP TABLE bronze.online_retail;
GO

CREATE TABLE bronze.online_retail
(
    InvoiceNo      NVARCHAR(20),
    StockCode      NVARCHAR(20),
    Description    NVARCHAR(255),
    Quantity       NVARCHAR(20),
    InvoiceDate    NVARCHAR(30),
    UnitPrice      NVARCHAR(20),
    CustomerID     NVARCHAR(20),
    Country        NVARCHAR(100)
);
GO