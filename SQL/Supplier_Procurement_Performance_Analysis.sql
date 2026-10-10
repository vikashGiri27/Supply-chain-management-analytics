/*=================================================================
                    SUPPLIER & PROCUREMENT ANALYSIS
==================================================================*/

/*----------------------------------------------------------------
BQ10. Which suppliers have the lowest on-time delivery performance?
------------------------------------------------------------------*/
SELECT s.Supplier_ID,
s.Supplier_Name,
COUNT(*) AS Total_Orders,
SUM(CASE WHEN p.Actual_Delivery_Date <= p.Expected_Delivery_Date THEN 1 ELSE 0 END) AS On_Time_Orders,
ROUND(SUM(CASE WHEN p.Actual_Delivery_Date <= p.Expected_Delivery_Date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS On_Time_Delivery_Rate
FROM Fact_Purchase_Order p
INNER JOIN Dim_Supplier s
ON p.Supplier_ID = s.Supplier_ID
WHERE REPLACE(REPLACE(p.PO_Status, CHAR(13), ''), CHAR(10), '') = 'Completed'
AND p.Actual_Delivery_Date IS NOT NULL
AND p.Expected_Delivery_Date IS NOT NULL
GROUP BY s.Supplier_ID,
s.Supplier_Name
ORDER BY On_Time_Delivery_Rate ASC;