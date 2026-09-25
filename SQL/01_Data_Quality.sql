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