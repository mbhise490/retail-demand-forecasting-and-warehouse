/*
==========================================================
Create and Load Sales Fact Table
==========================================================
Purpose:
- Store all sales transactions from the Silver layer
- Link all dimension tables using foreign keys
- Store business measures such as Quantity, Unit Price,
  and Sales Amount
- Serve as the central table for reporting and analytics
==========================================================
*/


IF OBJECT_ID('gold.fact_sales','U') IS NOT NULL
DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales
(
    Sales_Key INT IDENTITY(1,1) PRIMARY KEY,
    Date_Key INT,
    Product_Key INT,
    Customer_Key INT,
    Country_Key INT,
    InvoiceNo VARCHAR(20),
    InvoiceType VARCHAR(30),
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    SalesAmount DECIMAL(18,2)
);
GO

INSERT INTO gold.fact_sales
(
Date_Key,
Product_Key,
Customer_Key,
Country_Key,
InvoiceNo,
InvoiceType,
Quantity,
UnitPrice,
SalesAmount
)

SELECT

CONVERT(INT,FORMAT(CAST(s.InvoiceDate AS DATE),'yyyyMMdd')),
p.Product_Key,
c.Customer_Key,
co.Country_Key,
s.InvoiceNo,
s.InvoiceType,
s.Quantity,
s.UnitPrice,
s.Quantity*s.UnitPrice
FROM silver.online_retail s
JOIN gold.dim_product p
ON s.StockCode=p.StockCode
AND s.Description=p.Description
JOIN gold.dim_customer c
ON s.CustomerID=c.CustomerID
JOIN gold.dim_country co
ON s.Country=co.Country;


ALTER TABLE gold.fact_sales
ADD CONSTRAINT FK_Date
FOREIGN KEY(Date_Key)
REFERENCES gold.dim_date(Date_Key);

ALTER TABLE gold.fact_sales
ADD CONSTRAINT FK_Product
FOREIGN KEY(Product_Key)
REFERENCES gold.dim_product(Product_Key);

ALTER TABLE gold.fact_sales
ADD CONSTRAINT FK_Customer
FOREIGN KEY(Customer_Key)
REFERENCES gold.dim_customer(Customer_Key);

ALTER TABLE gold.fact_sales
ADD CONSTRAINT FK_Country
FOREIGN KEY(Country_Key)
REFERENCES gold.dim_country(Country_Key);

