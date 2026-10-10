/*=================================================================
                    INVENTORY ANALYSIS
==================================================================*/

/*----------------------------------------------------------------
BQ1. Which products experience the highest number of stockouts?
------------------------------------------------------------------*/
SELECT i.Product_ID,
p.Product_Name,
p.Product_Category,
COUNT(*) AS Stockout_Count
FROM Fact_Inventory i
INNER JOIN Dim_Product p
ON i.Product_ID = p.Product_ID
WHERE i.Closing_Stock = 0
GROUP BY i.Product_ID,
p.Product_Name,
p.Product_Category
ORDER BY Stockout_Count DESC;

/*---------------------------------------------------------------------
BQ2. Which products and warehouses hold the highest inventory quantity?
-----------------------------------------------------------------------*/
SELECT
    i.Product_ID,
    p.Product_Name,
    w.Warehouse_ID,
    w.Warehouse_Name,
    SUM(i.Closing_Stock) AS Total_Inventory
FROM Fact_Inventory i
INNER JOIN Dim_Product p
    ON i.Product_ID = p.Product_ID
INNER JOIN Dim_Warehouse w
    ON i.Warehouse_ID = w.Warehouse_ID
GROUP BY
    i.Product_ID,
    p.Product_Name,
    w.Warehouse_ID,
    w.Warehouse_Name
ORDER BY Total_Inventory DESC;

/*---------------------------------------------------------------------
 BQ3. How does inventory change over time?
-----------------------------------------------------------------------*/
WITH Inventory_Movement_Base AS
(
SELECT
Product_ID,
Warehouse_ID,
Inventory_Date,
Closing_Stock,
LAG(Closing_Stock) OVER (
PARTITION BY Product_ID, Warehouse_ID
ORDER BY Inventory_Date
) AS Previous_Closing_Stock
FROM Fact_Inventory)
SELECT
Product_ID,
Warehouse_ID,
Inventory_Date,
Closing_Stock,
Previous_Closing_Stock,
Closing_Stock - Previous_Closing_Stock AS Inventory_Change
FROM Inventory_Movement_Base
ORDER BY Product_ID, Warehouse_ID, Inventory_Date;

/*----------------------------------------------------
BQ4. How does inventory vary across warehouses?
------------------------------------------------------*/

SELECT
w.Warehouse_ID,
w.Warehouse_Name,
w.Warehouse_Location,
SUM(i.Closing_Stock) AS Warehouse_Inventory_Quantity
FROM Fact_Inventory i
INNER JOIN Dim_Warehouse w
ON i.Warehouse_ID = w.Warehouse_ID
GROUP BY
w.Warehouse_ID,
w.Warehouse_Name,
w.Warehouse_Location
ORDER BY
Warehouse_Inventory_Quantity DESC;

/*--------------------------------------------------------------------------------
BQ5: Analyze monthly inventory movement and stock held by product and warehouse.
----------------------------------------------------------------------------------*/

WITH Monthly_Inventory AS (
SELECT
Product_ID,
Warehouse_ID,
Inventory_Date,
Opening_Stock,
Issued_or_Sold_Quantity,
Closing_Stock,
DATE_FORMAT(Inventory_Date, '%Y-%m') AS Inventory_Month,
ROW_NUMBER() OVER (
PARTITION BY Product_ID, Warehouse_ID, DATE_FORMAT(Inventory_Date, '%Y-%m')
ORDER BY Inventory_Date
) AS First_Row,
ROW_NUMBER() OVER (
PARTITION BY Product_ID, Warehouse_ID, DATE_FORMAT(Inventory_Date, '%Y-%m')
ORDER BY Inventory_Date DESC
) AS Last_Row
FROM Fact_Inventory
)
SELECT
Product_ID,
Warehouse_ID,
Inventory_Month,
MAX(CASE WHEN First_Row = 1 THEN Opening_Stock END) AS Month_Opening_Stock,
SUM(Issued_or_Sold_Quantity) AS Total_Issued_Sold,
AVG(Closing_Stock) AS Average_Closing_Stock,
MAX(CASE WHEN Last_Row = 1 THEN Closing_Stock END) AS Month_End_Closing_Stock
FROM Monthly_Inventory
GROUP BY
Product_ID,
Warehouse_ID,
Inventory_Month
ORDER BY
Product_ID,
Warehouse_ID,
Inventory_Month;


/*----------------------------------------------------------
BQ6:Identify warehouses with the highest stockout frequency.
----------------------------------------------------------*/

SELECT
i.Warehouse_ID,
w.Warehouse_Name,
w.Warehouse_Location,
COUNT(i.Closing_Stock) AS Stockout_Count
FROM Fact_Inventory i
INNER JOIN Dim_Warehouse w
ON i.Warehouse_ID = w.Warehouse_ID
WHERE i.Closing_Stock = 0
GROUP BY
i.Warehouse_ID,
w.Warehouse_Name,
w.Warehouse_Location
ORDER BY Stockout_Count DESC;


/*	---------------------------------------------------------
BQ7: Compare product availability across warehouses.
------------------------------------------------------------*/

SELECT
i.Product_ID,
p.Product_Name,
i.Warehouse_ID,
w.Warehouse_Name,
i.Inventory_Date,
i.Closing_Stock,
CASE
WHEN i.Closing_Stock = 0 THEN 'Out of Stock'
ELSE 'Stock Available'
END AS Stock_Status
FROM Fact_Inventory i
INNER JOIN Dim_Product p
ON i.Product_ID = p.Product_ID
INNER JOIN Dim_Warehouse w
ON i.Warehouse_ID = w.Warehouse_ID
WHERE i.Inventory_Date = (
SELECT MAX(Inventory_Date)
FROM Fact_Inventory
)
AND EXISTS (
SELECT 1
FROM Fact_Inventory other
WHERE other.Product_ID = i.Product_ID
AND other.Inventory_Date = i.Inventory_Date
AND other.Warehouse_ID <> i.Warehouse_ID
AND (
(i.Closing_Stock = 0 AND other.Closing_Stock > 0)
OR
(i.Closing_Stock > 0 AND other.Closing_Stock = 0)
)
)
ORDER BY
i.Product_ID,
i.Closing_Stock DESC,
i.Warehouse_ID;


/*-------------------------------------------------------
BQ8 — Inventory Availability vs Customer Order Demand
-------------------------------------------------------*/

SELECT
i.Product_ID AS Inventory_Product_ID,
i.Warehouse_ID AS Inventory_Warehouse_ID,
i.Inventory_Date,
i.Closing_Stock,
c.Product_ID AS Order_Product_ID,
c.Warehouse_ID AS Order_Warehouse_ID,
c.Order_Date,
c.Ordered_Quantity
FROM Fact_Inventory i
INNER JOIN Fact_Customer_Order c
ON i.Product_ID = c.Product_ID
AND i.Warehouse_ID = c.Warehouse_ID
AND i.Inventory_Date = c.Order_Date
ORDER BY
i.Product_ID,
i.Warehouse_ID,
i.Inventory_Date;

/*-------------------------------------------------------
BQ9: Which products appear overstocked?
-------------------------------------------------------*/
# Note: Requires an approved overstock threshold.