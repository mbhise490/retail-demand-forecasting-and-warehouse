-- ==========================================================
-- Load cleaned data from Bronze to Silver
-- Steps:
-- 1. Remove leading/trailing spaces
-- 2. Remove duplicate records
-- 3. Extract InvoiceType and clean InvoiceNo
-- 4. Convert data types
-- 5. Handle NULL values
-- 6. Load data into Silver table
-- ==========================================================
USE Retail_DataWarehouse;
GO

WITH String_Cleaning AS                   --1. Remove leading/trailing spaces       
(
    SELECT
        TRIM(InvoiceNo)   AS InvoiceNo,
        TRIM(StockCode)   AS StockCode,
        TRIM(Description) AS Description,
        TRIM(Quantity)    AS Quantity,
        TRIM(InvoiceDate) AS InvoiceDate,
        TRIM(UnitPrice)   AS UnitPrice,
        TRIM(CustomerID)  AS CustomerID,
        TRIM(Country)     AS Country
    FROM bronze.online_retail
),
Duplicate_Record AS                       -- 2. Remove duplicate records
(
    SELECT
        InvoiceNo,
        StockCode,
        Description,
        TRY_CAST(Quantity AS INT) AS Quantity,
        TRY_CAST(InvoiceDate AS DATETIME2) AS InvoiceDate,
        TRY_CAST(UnitPrice AS DECIMAL(10,2)) AS UnitPrice,
        CAST(TRY_CAST(CustomerID AS FLOAT) AS INT) AS CustomerID,
        Country,
        ROW_NUMBER() OVER
        (
            PARTITION BY
                InvoiceNo,
                StockCode,
                Description,
                Quantity,
                InvoiceDate,
                UnitPrice,
                CustomerID,
                Country
            ORDER BY InvoiceNo
        ) AS Row_No
    FROM String_Cleaning
),

Column_Extraction AS                    -- 3. Extract InvoiceType and clean InvoiceNo
(
    SELECT
        CASE
            WHEN InvoiceNo LIKE '[CA]%' THEN SUBSTRING(InvoiceNo,2,LEN(InvoiceNo))
            ELSE InvoiceNo
        END AS InvoiceNo,

        CASE
            WHEN InvoiceNo LIKE 'C%' THEN 'Cancellation'
            WHEN InvoiceNo LIKE 'A%' THEN 'Accounting Adjustment'
            ELSE 'Sale'
        END AS InvoiceType,

        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        UnitPrice,
        CustomerID,
        Country,
        Row_No
    FROM Duplicate_Record
),

Null_Handling AS                        -- 5. Handle NULL values
(
    SELECT
        InvoiceNo,
        InvoiceType,
        StockCode,
        ISNULL(NULLIF(Description,''), 'NO Description') AS Description,
        Quantity,
        InvoiceDate,
        UnitPrice,
        ISNULL(CustomerID,-1) AS CustomerID,
        Country
    FROM Column_Extraction
    WHERE Row_No = 1
)

INSERT INTO silver.online_retail      ---- 6. Load data into Silver table
(
    InvoiceNo,
    InvoiceType,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
)
SELECT
    InvoiceNo,
    InvoiceType,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
FROM Null_Handling;

SELECT DISTINCT TOP 500 * FROM silver.online_retail;