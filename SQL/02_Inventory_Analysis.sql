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
How does inventory vary across warehouses?
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

















