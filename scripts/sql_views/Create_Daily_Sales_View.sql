/*
==========================================================
Create Daily Sales View for Time Series Forecasting
==========================================================
Purpose:
- Aggregate daily sales from the fact table
- Prepare data for forecasting models
- Support Prophet, ARIMA, LSTM and other time series models
==========================================================
*/

IF OBJECT_ID('gold.vw_daily_sales','V') IS NOT NULL
DROP VIEW gold.vw_daily_sales;
GO
CREATE VIEW gold.vw_daily_sales
AS

SELECT

    d.Full_Date,
    SUM(f.SalesAmount) AS TotalSales,
    SUM(f.Quantity) AS TotalQuantity,
    COUNT(DISTINCT f.InvoiceNo) AS TotalOrders,
    COUNT(DISTINCT c.CustomerID) AS TotalCustomers
FROM gold.fact_sales f
INNER JOIN gold.dim_date d
ON f.Date_Key = d.Date_Key
INNER JOIN gold.dim_customer c
ON f.Customer_Key = c.Customer_Key
GROUP BY
    d.Full_Date;
GO
