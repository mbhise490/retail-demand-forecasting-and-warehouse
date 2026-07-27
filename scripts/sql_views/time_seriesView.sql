/*
==========================================================
Create Time Series Analysis View
==========================================================
Purpose:
- Prepare daily data for time series analysis
- Support EDA and feature engineering
- Ready for Prophet, ARIMA, LSTM and XGBoost
==========================================================
*/

IF OBJECT_ID('gold.vw_time_series','V') IS NOT NULL
DROP VIEW gold.vw_time_series;
GO

CREATE VIEW gold.vw_time_series
AS

SELECT
    TOP 1000
    d.Full_Date AS SalesDate,
    SUM(f.SalesAmount) AS DailySales,
    SUM(f.Quantity) AS TotalQuantity,
    COUNT(DISTINCT f.InvoiceNo) AS TotalOrders,
    COUNT(DISTINCT c.CustomerID) AS TotalCustomers,
    AVG(f.UnitPrice) AS AvgUnitPrice,
    -- Calendar features
    YEAR(d.Full_Date) AS Year,
    MONTH(d.Full_Date) AS Month,
    DATENAME(MONTH, d.Full_Date) AS MonthName,
    DAY(d.Full_Date) AS Day,
    DATENAME(WEEKDAY, d.Full_Date) AS Weekday,
    DATEPART(WEEK, d.Full_Date) AS WeekNumber,
    DATEPART(QUARTER, d.Full_Date) AS Quarter,
    CASE
        WHEN DATENAME(WEEKDAY, d.Full_Date) IN ('Saturday','Sunday')
        THEN 1
        ELSE 0
    END AS IsWeekend

FROM gold.fact_sales f
INNER JOIN gold.dim_date d
    ON f.Date_Key = d.Date_Key
INNER JOIN gold.dim_customer c
    ON f.Customer_Key = c.Customer_Key
GROUP BY
    d.Full_Date
ORDER BY SalesDate;
GO
