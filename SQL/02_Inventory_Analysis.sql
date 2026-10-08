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

