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
BQ9: Analyze monthly inventory movement and stock held by product and warehouse.
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