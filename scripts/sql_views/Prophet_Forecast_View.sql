/*
==========================================================
Create Forecast View
==========================================================
Purpose:
- Prepare data for Facebook 
- Rename columns required format
==========================================================
*/

IF OBJECT_ID('gold.vw_prophet_sales','V') IS NOT NULL
DROP VIEW gold.vw_prophet_sales;
GO
CREATE VIEW gold.vw_prophet_sales
AS
SELECT
    d.Full_Date AS ds,
    SUM(f.SalesAmount) AS y
FROM gold.fact_sales f
INNER JOIN gold.dim_date d
  ON f.Date_Key = d.Date_Key
GROUP BY
    d.Full_Date;
GO
