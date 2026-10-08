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

