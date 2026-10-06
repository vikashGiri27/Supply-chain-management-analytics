/*==============================================================
	 DIMENSION RELATIONSHIP VALIDATION
==============================================================*/
/* 1. Product → Inventory */
SELECT COUNT(*) AS Orphan_Product_Inventory
FROM Fact_Inventory fi
LEFT JOIN Dim_Product dp
    ON fi.Product_ID = dp.Product_ID
WHERE dp.Product_ID IS NULL;


/* 2. Product → Purchase Order */
SELECT COUNT(*) AS Orphan_Product_PO
FROM Fact_Purchase_Order po
LEFT JOIN Dim_Product dp
    ON po.Product_ID = dp.Product_ID
WHERE dp.Product_ID IS NULL;


/* 3. Product → Customer Order */
SELECT COUNT(*) AS Orphan_Product_Customer_Order
FROM Fact_Customer_Order co
LEFT JOIN Dim_Product dp
    ON co.Product_ID = dp.Product_ID
WHERE dp.Product_ID IS NULL;


/* 4. Product → Return */
SELECT COUNT(*) AS Orphan_Product_Return
FROM Fact_Return r
LEFT JOIN Dim_Product dp
    ON r.Product_ID = dp.Product_ID
WHERE dp.Product_ID IS NULL;


/* 5. Supplier → Purchase Order */
SELECT COUNT(*) AS Orphan_Supplier_PO
FROM Fact_Purchase_Order po
LEFT JOIN Dim_Supplier ds
    ON po.Supplier_ID = ds.Supplier_ID
WHERE ds.Supplier_ID IS NULL;


/* 6. Warehouse → Inventory */
SELECT COUNT(*) AS Orphan_Warehouse_Inventory
FROM Fact_Inventory fi
LEFT JOIN Dim_Warehouse dw
    ON fi.Warehouse_ID = dw.Warehouse_ID
WHERE dw.Warehouse_ID IS NULL;


/* 7. Warehouse → Customer Order */
SELECT COUNT(*) AS Orphan_Warehouse_Customer_Order
FROM Fact_Customer_Order co
LEFT JOIN Dim_Warehouse dw
    ON co.Warehouse_ID = dw.Warehouse_ID
WHERE dw.Warehouse_ID IS NULL;


/* 8. Customer → Customer Order */
SELECT COUNT(*) AS Orphan_Customer_Order
FROM Fact_Customer_Order co
LEFT JOIN Dim_Customer dc
    ON co.Customer_ID = dc.Customer_ID
WHERE dc.Customer_ID IS NULL;

/* 9. Date → Purchase Order Expected Delivery Date */
/* Date Coverage Validation */

SELECT COUNT(*) AS Missing_Date_In_Dim_Date
FROM Fact_Purchase_Order po
LEFT JOIN Dim_Date dd
    ON po.Expected_Delivery_Date = dd.Date
WHERE po.Expected_Delivery_Date IS NOT NULL
  AND dd.Date IS NULL;
  
/* 10. Date → Purchase Order Actual Delivery Date */
/* Date Coverage Validation */

SELECT COUNT(*) AS Missing_Date_In_Dim_Date
FROM Fact_Purchase_Order po
LEFT JOIN Dim_Date dd
    ON po.Actual_Delivery_Date = dd.Date
WHERE po.Actual_Delivery_Date IS NOT NULL
  AND dd.Date IS NULL;

/*==============================================================
   FINAL DATA QUALITY REVALIDATION
   Run after the Dim_Date extension through 2025-03-24.
==============================================================*/

/* 11. PO — Completed records missing Actual_Delivery_Date */
SELECT COUNT(*) AS Missing_Actual_Delivery_Completed
FROM Fact_Purchase_Order
WHERE PO_Status = 'Completed'
  AND Actual_Delivery_Date IS NULL;


/* 12. PO — Actual_Delivery_Date earlier than Order_Date */
SELECT COUNT(*) AS Invalid_Actual_Delivery_Before_Order
FROM Fact_Purchase_Order
WHERE Actual_Delivery_Date IS NOT NULL
  AND Order_Date IS NOT NULL
  AND Actual_Delivery_Date < Order_Date;


/* 13. Dim_Date — current coverage */
SELECT MIN(Date) AS Dim_Date_Min,
       MAX(Date) AS Dim_Date_Max,
       COUNT(*) AS Dim_Date_Row_Count
FROM Dim_Date;


/* 14. Inventory — date coverage */
SELECT COUNT(*) AS Missing_Inventory_Date_In_Dim_Date
FROM Fact_Inventory fi
LEFT JOIN Dim_Date dd
    ON fi.Inventory_Date = dd.Date
WHERE fi.Inventory_Date IS NOT NULL
  AND dd.Date IS NULL;


/* 15. PO — Order_Date coverage */
SELECT COUNT(*) AS Missing_PO_Order_Date_In_Dim_Date
FROM Fact_Purchase_Order po
LEFT JOIN Dim_Date dd
    ON po.Order_Date = dd.Date
WHERE po.Order_Date IS NOT NULL
  AND dd.Date IS NULL;


/* 16. Customer Order — Order_Date coverage */
SELECT COUNT(*) AS Missing_Customer_Order_Date_In_Dim_Date
FROM Fact_Customer_Order co
LEFT JOIN Dim_Date dd
    ON co.Order_Date = dd.Date
WHERE co.Order_Date IS NOT NULL
  AND dd.Date IS NULL;


/* 17. Delivery — Shipment_Date coverage */
SELECT COUNT(*) AS Missing_Shipment_Date_In_Dim_Date
FROM Fact_Delivery fd
LEFT JOIN Dim_Date dd
    ON fd.Shipment_Date = dd.Date
WHERE fd.Shipment_Date IS NOT NULL
  AND dd.Date IS NULL;


/* 18. Delivery — Expected_Delivery_Date coverage */
SELECT COUNT(*) AS Missing_Delivery_Expected_Date_In_Dim_Date
FROM Fact_Delivery fd
LEFT JOIN Dim_Date dd
    ON fd.Expected_Delivery_Date = dd.Date
WHERE fd.Expected_Delivery_Date IS NOT NULL
  AND dd.Date IS NULL;


/* 19. Delivery — Actual_Delivery_Date coverage */
SELECT COUNT(*) AS Missing_Delivery_Actual_Date_In_Dim_Date
FROM Fact_Delivery fd
LEFT JOIN Dim_Date dd
    ON fd.Actual_Delivery_Date = dd.Date
WHERE fd.Actual_Delivery_Date IS NOT NULL
  AND dd.Date IS NULL;


/* 20. Return — Return_Date coverage */
SELECT COUNT(*) AS Missing_Return_Date_In_Dim_Date
FROM Fact_Return fr
LEFT JOIN Dim_Date dd
    ON fr.Return_Date = dd.Date
WHERE fr.Return_Date IS NOT NULL
  AND dd.Date IS NULL;


/* 21. Return -> Customer Order logical Order_ID validation */
SELECT COUNT(*) AS Orphan_Order_Return
FROM Fact_Return r
LEFT JOIN (
    SELECT DISTINCT Order_ID
    FROM Fact_Customer_Order
) co
    ON r.Order_ID = co.Order_ID
WHERE co.Order_ID IS NULL;


/* 22. Delivery -> Customer Order logical Order_ID validation */
SELECT COUNT(*) AS Orphan_Order_Delivery
FROM Fact_Delivery d
LEFT JOIN (
    SELECT DISTINCT Order_ID
    FROM Fact_Customer_Order
) co
    ON d.Order_ID = co.Order_ID
WHERE co.Order_ID IS NULL;


/* 23. Inventory — negative Issued_or_Sold_Quantity */
SELECT COUNT(*) AS Negative_Issued_or_Sold_Quantity
FROM Fact_Inventory
WHERE Issued_or_Sold_Quantity < 0;


/* 24. Inventory — missing Received_Quantity */
SELECT COUNT(*) AS Missing_Received_Quantity
FROM Fact_Inventory
WHERE Received_Quantity IS NULL;


/* 25. Purchase Order — negative Received_Quantity */
SELECT COUNT(*) AS Negative_Received_Quantity_PO
FROM Fact_Purchase_Order
WHERE Received_Quantity < 0;


/* 26. Customer Order — missing Ordered_Quantity */
SELECT COUNT(*) AS Missing_Ordered_Quantity_Customer_Order
FROM Fact_Customer_Order
WHERE Ordered_Quantity IS NULL;


/* 27. Delivery — missing Expected_Delivery_Date */
SELECT COUNT(*) AS Missing_Expected_Delivery_Date_Delivery
FROM Fact_Delivery
WHERE Expected_Delivery_Date IS NULL;


/* 28. Final Dim_Date coverage status */
SELECT CASE
         WHEN MIN(Date) = '2023-01-01'
          AND MAX(Date) = '2025-03-24'
         THEN 'PASS'
         ELSE 'REVIEW'
       END AS Dim_Date_Coverage_Status,
       MIN(Date) AS Min_Date,
       MAX(Date) AS Max_Date,
       COUNT(*) AS Total_Dim_Date_Rows
FROM Dim_Date;