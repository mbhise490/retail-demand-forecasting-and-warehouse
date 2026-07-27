/*
Load Data into Bronze Layer
Script Purpose:
    This script loads the raw Online Retail CSV data into the
    'bronze.online_retail' table using BULK INSERT.

Source File:
    D:\Mine\data_set\online_retail.csv
*/

USE Retail_DataWarehouse;
GO

BULK INSERT bronze.online_retail
FROM 'D:\Mine\data_set\online_retail.csv'
WITH
(
    FORMAT = 'CSV',              
    FIRSTROW = 2,                
    FIELDTERMINATOR = ',',      
    ROWTERMINATOR = '0x0A',      
    TABLOCK                      
);
GO

-- Verify the data load
SELECT COUNT(*) AS TotalRows
FROM bronze.online_retail;
GO
-- Preview the loaded data
SELECT *
FROM bronze.online_retail;