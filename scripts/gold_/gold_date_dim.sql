/*
==========================================================
Create and Load Date Dimension
==========================================================
Purpose:
- Store unique dates from the Silver layer
- Support time-based analysis and reporting
- Create a surrogate date key for the fact table
==========================================================
*/


IF OBJECT_ID('gold.dim_date','U') IS NOT NULL
DROP TABLE gold.dim_date;
GO

CREATE TABLE gold.dim_date
(
    Date_Key INT PRIMARY KEY,
    Full_Date DATE,
    Day INT,
    Month_Name VARCHAR(20),
    Weekday VARCHAR(20),
    Is_Weekend BIT
);
GO

INSERT INTO gold.dim_date
SELECT DISTINCT

    CONVERT(INT, FORMAT(CAST(InvoiceDate AS DATE),'yyyyMMdd')) AS Date_Key,
    CAST(InvoiceDate AS DATE),
    DAY(InvoiceDate),
    DATENAME(MONTH,InvoiceDate),
    DATENAME(WEEKDAY,InvoiceDate),
    CASE
        WHEN DATENAME(WEEKDAY,InvoiceDate) IN ('Saturday','Sunday')
        THEN 1
        ELSE 0
    END
FROM silver.online_retail;