# Supply Chain Management Analytics Project — Synthetic Dataset
**Source of Truth:** BUSINESS_REQUIREMENTS_DOCUMENT.pdf (v3.0) — Sections 10 & 11
**Generated:** Historical synthetic operational data, 2023-01-01 to 2024-12-31 (24 months)

---

## 1. RECORD COUNTS & HISTORICAL RANGE

| Table | Grain (per BRD Section 10) | Row Count |
|---|---|---|
| Dim_Product | One record per Product_ID | 200 |
| Dim_Warehouse | One record per Warehouse_ID | 15 |
| Dim_Supplier | One record per Supplier_ID | 40 |
| Dim_Customer | One record per Customer_ID | 6,000 |
| Dim_Date | One record per calendar date | 731 |
| Fact_Inventory | One per Product_ID + Warehouse_ID + Inventory_Date | 718,559 |
| Fact_Purchase_Order | One per Purchase Order Line | 75,867 |
| Fact_Customer_Order | One per Customer Order Line | 278,402 |
| Fact_Delivery | One per Order_ID (order header) | 170,985 |
| Fact_Return | One per returned order line | 15,495 |
| **TOTAL** | | **1,266,294** |

Historical Date Range: **2023-01-01 to 2024-12-31** (24 months)

Scale rationale: dimension tables stay small (they represent master entities), while fact tables carry the volume, sized to their natural business grain — Fact_Inventory is largest because it is a daily snapshot across ~982 realistic product-warehouse combinations (not every product is stocked in every warehouse) over 731 days.

---

## 2. DATA DICTIONARY

### Dim_Product (BRD 10.1)
| Field | Description |
|---|---|
| Product_ID | Unique product key (PXXXX) |
| Product_Name | Product description |
| Product_Category | 10 generic categories |
| Unit_Cost | Procurement/holding cost per unit |
| Selling_Price | Selling price per unit |
| Product_Status | Active / Discontinued |

### Dim_Warehouse (BRD 10.2)
| Field | Description |
|---|---|
| Warehouse_ID | Unique warehouse key (WXX) |
| Warehouse_Name | Distribution center name |
| Warehouse_Location | City + Region |
| Warehouse_Capacity | Max storage capacity (units) |

### Dim_Supplier (BRD 10.3)
| Field | Description |
|---|---|
| Supplier_ID | Unique supplier key (SXXX) |
| Supplier_Name | Supplier company name |
| Supplier_Location | City |
| Supplier_Category | Raw Material / Component / Packaging / Finished Goods / MRO |
| Supplier_Status | Active / Inactive |

### Dim_Customer (BRD 10.4)
| Field | Description |
|---|---|
| Customer_ID | Unique customer key (CXXXXX) |
| Customer_Name | Generic customer identifier (no PII, per BRD instruction) |
| Customer_Segment | Retail / Wholesale / Online / Corporate |
| Customer_Location | City |

### Dim_Date
*Not explicitly field-defined in BRD (BRD only lists Dim_Date as a required dimension table name).*
**General Recommendation (labelled assumption):** standard date attributes were generated to support Power BI time intelligence: Date, Year, Quarter, Month, Month_Name, Day, Week_Of_Year, Day_Name, Is_Weekend.

### Fact_Inventory (BRD 10.5)
Grain: **One inventory snapshot per Product_ID, Warehouse_ID, Inventory_Date.**
| Field | Description |
|---|---|
| Inventory_Date | Snapshot date |
| Product_ID | FK → Dim_Product |
| Warehouse_ID | FK → Dim_Warehouse |
| Opening_Stock | Stock at start of day |
| Received_Quantity | Quantity received into warehouse that day |
| Issued_or_Sold_Quantity | Quantity issued/sold that day |
| Closing_Stock | Stock at end of day |
| Reorder_Level | Reference reorder threshold (static per product-warehouse) |

**Assumption (labelled):** Per BRD Section 10.5, "the source system must confirm whether the snapshot represents opening, closing, or another inventory state." This was **Not Defined in Project Source** — the dataset was generated to represent a **daily opening→closing rollforward**, which is the most common operational pattern and supports both interpretations (Opening_Stock and Closing_Stock are both present as separate fields).

### Fact_Purchase_Order (BRD 10.6)
Grain: **One record per Purchase Order Line.**
| Field | Description |
|---|---|
| PO_ID | Purchase order header key |
| PO_Line_ID | Purchase order line key (PO_ID-L#) |
| Supplier_ID | FK → Dim_Supplier |
| Product_ID | FK → Dim_Product |
| Order_Date | Date PO was placed |
| Expected_Delivery_Date | Agreed/expected delivery date |
| Actual_Delivery_Date | Actual delivery date (null if Open/Cancelled) |
| Ordered_Quantity | Quantity ordered |
| Received_Quantity | Quantity actually received |
| Planned_Unit_Cost | Optional planned cost per BRD |
| Actual_Unit_Cost | Actual cost per unit |
| PO_Status | Completed / Open / Cancelled |

**Assumption (labelled):** The BRD does not include a Warehouse_ID field in the Fact_Purchase_Order grain. Therefore, Fact_Inventory receipts are **not** joined row-for-row to specific PO lines; they are generated independently but influenced by the same underlying supplier-reliability profile per product, so month-level patterns are directionally consistent. This mirrors a realistic constraint the BRD itself anticipates (Section 25: "Missing inventory transaction-level data").

### Fact_Customer_Order (BRD 10.7)
Grain: **One record per Customer Order Line.**
| Field | Description |
|---|---|
| Order_ID | Customer order header key |
| Order_Line_ID | Order line key (Order_ID-L#) |
| Customer_ID | FK → Dim_Customer |
| Product_ID | FK → Dim_Product |
| Warehouse_ID | FK → Dim_Warehouse (fulfilling warehouse) |
| Order_Date | Date order was placed |
| Ordered_Quantity | Quantity ordered |
| Fulfilled_Quantity | Quantity actually fulfilled |
| Order_Status | Completed / Open / Cancelled |

### Fact_Delivery (BRD 10.8)
Grain: **One record per Order_ID (order header level, per BRD field list).**
| Field | Description |
|---|---|
| Delivery_ID | Delivery key |
| Order_ID | FK → Fact_Customer_Order (Order_ID) |
| Shipment_Date | Date shipped from warehouse |
| Expected_Delivery_Date | Expected delivery date |
| Actual_Delivery_Date | Actual delivery date (null if not yet delivered) |
| Delivery_Status | Delivered / In Transit |
| Delivery_Region | Customer delivery region |
| Delivery_Accuracy_Flag | Optional advanced field (Y = accurate, N = inaccurate) |
| Damage_Flag | Optional advanced field (Y/N) |
| Carrier_ID | Optional advanced field |

### Fact_Return (BRD 10.9)
Grain: One record per returned order line.
| Field | Description |
|---|---|
| Return_ID | Return key |
| Order_ID | FK → Fact_Customer_Order |
| Product_ID | FK → Dim_Product |
| Return_Date | Date of return |
| Returned_Quantity | Quantity returned |
| Return_Reason | Damaged in Transit / Wrong Item Delivered / Quality Issue / Customer Changed Mind / Late Delivery / Other |

---

## 3. RELATIONSHIP MAPPING (Star Schema — BRD Section 11)

```
Dim_Product   ──< Fact_Inventory
Dim_Product   ──< Fact_Purchase_Order
Dim_Product   ──< Fact_Customer_Order
Dim_Product   ──< Fact_Return
Dim_Supplier  ──< Fact_Purchase_Order
Dim_Warehouse ──< Fact_Inventory
Dim_Warehouse ──< Fact_Customer_Order
Dim_Customer  ──< Fact_Customer_Order
Dim_Date      ──< all fact tables (via date fields)
Fact_Customer_Order ──< Fact_Delivery   (via Order_ID, header grain)
Fact_Customer_Order ──< Fact_Return     (via Order_ID)
```

**Primary Keys:** Product_ID, Warehouse_ID, Supplier_ID, Customer_ID, Date, PO_Line_ID, Order_Line_ID, Delivery_ID, Return_ID.
**Foreign Keys:** as shown above — join validation required per BRD Section 11 ("All relationships must be validated using unique business keys and documented join logic") — a small number of orphan keys were intentionally introduced (see Section 5 below) to require this validation step.

---

## 4. REALISTIC FLUCTUATION / VARIANCE PATTERNS BUILT INTO THE DATA

- **Product velocity**: products are internally Fast / Medium / Slow movers (not an exposed column) — visible only through demand and turnover patterns, to be *discovered* via SQL/Power BI, not read off a flag.
- **Seasonality**: monthly demand multiplier (low ~Jan/Feb/Jul, peak Oct–Dec) applied to inventory issue quantities and indirectly to order volume.
- **Supplier reliability mixture**: ~55% consistently reliable, ~28% occasional-issue, ~17% recurring-delay suppliers across 40 suppliers — spread observed in validation: PO late-delivery rate ranges from ~5% (best supplier) to ~88% (worst supplier), overall ~34% late.
- **Warehouse pressure**: each of the 15 warehouses has an internal capacity-pressure factor affecting restock consistency and order-processing time — not exposed as a column.
- **Regional delivery performance**: regions differ in on-time delivery propensity (validated: ~27% late in the best region to ~43% in the worst, ~33% overall).
- **Cross-functional correlation (diagnostic-analytics ready, non-deterministic)**:
  - Product-level supplier reliability influences the timing/size of warehouse restocks in Fact_Inventory.
  - Monthly stockout frequency per Product-Warehouse (an internal signal, not a column) increases the *probability* of partial order fulfillment in Fact_Customer_Order — but does not guarantee it.
  - Order fulfillment shortfall and warehouse pressure increase the *probability* of late delivery in Fact_Delivery — but many shortfalled orders still deliver on time, and many full orders still arrive late, so the relationship must be investigated with SQL/segmentation, not assumed.
  - Damaged/inaccurate deliveries increase the *probability* of a return, without guaranteeing one.

No column in the dataset states a "cause." All of the above are tendencies an analyst must uncover through trend, Pareto, variance, segmentation, and drill-down analysis, per BRD Section 18.

---

## 5. DATA QUALITY ISSUES INTENTIONALLY INTRODUCED

(Full machine-readable log: `Data_Quality_Issues_Log.csv`)

| Table | Issue | Rows Affected (approx.) |
|---|---|---|
| Dim_Product | Inconsistent product name casing/spacing | 3 |
| Dim_Supplier | Inconsistent supplier name casing/spacing | 2 |
| Dim_Customer | Missing Customer_Location | 6 |
| Fact_Inventory | Negative Issued_or_Sold_Quantity (invalid) | 1,076 |
| Fact_Inventory | Missing Received_Quantity | 7,178 |
| Fact_Inventory | Duplicate records (exact duplicate rows) | 717 |
| Fact_Inventory | Orphan Product_ID not present in Dim_Product (P9999) | 574 |
| Fact_Purchase_Order | Missing Actual_Delivery_Date despite Completed status | 421 |
| Fact_Purchase_Order | Invalid date logic: Actual_Delivery_Date < Order_Date | 210 |
| Fact_Purchase_Order | Negative Received_Quantity (invalid) | 151 |
| Fact_Purchase_Order | Duplicate PO line records | 151 |
| Fact_Customer_Order | Missing Ordered_Quantity | 835 |
| Fact_Customer_Order | Orphan Product_ID not present in Dim_Product (P9999) | 194 |
| Fact_Delivery | Missing Expected_Delivery_Date | 682 |
| Fact_Delivery | Duplicate delivery records | 256 |
| Fact_Return | Orphan Order_ID not present in Fact_Customer_Order (ORD9999999) | 154 |

All issues combined affect **well under 2% of any single table** (largest is Fact_Inventory's missing Received_Quantity at ~1.0%) — the majority of every table remains clean and directly usable, consistent with BRD Section 13 (Data Quality Requirements) and Section 26 (Project Risks: Missing Data, Duplicate Records, Inconsistent IDs, Missing Dates, Unknown Data Grain).

**Note on Open/Cancelled PO and Order records:** Null Actual_Delivery_Date on **Open** or **Cancelled** PO/Order/Delivery records is a valid business state, not a data quality defect — only nulls on **Completed/Delivered** records (listed above) were intentionally injected as defects.

---

## 6. KPIs — WHAT CAN BE CALCULATED vs. NOT DEFINED IN PROJECT SOURCE

Per BRD Sections 5.3–5.4, 6.3–6.4, 7.3–7.4, the following KPIs can be calculated directly from this dataset:
Total Inventory Quantity, Inventory Value, Stockout Rate, Inventory Turnover Ratio (only if COGS proxy is documented as an assumption), Days of Inventory, Slow-Moving Inventory, Warehouse Inventory Variance, Total Purchase Orders, On-Time Delivery Rate, Late Delivery Rate, Average Delivery Delay, Average Procurement Lead Time, Purchase Order Fulfillment Rate, Quantity Variance, Procurement Cost Variance, Total Orders, Order Fulfillment Rate, On-Time Delivery Rate (delivery), Late Delivery Rate (delivery), Average Delivery Time, Order Cycle Time, Cancellation Rate, Return Rate.

**Not Defined in Project Source (do not calculate until business rule/threshold is approved, per BRD Sections 5.4, 6.4, 7.4):**
- **Overstock Rate** — requires an approved overstock threshold (Reorder Level Multiple / Maximum Stock Level / Historical Demand Coverage — none specified). Raw fields (Closing_Stock, Reorder_Level) are provided so the KPI can be computed once a rule is approved.
- **Inventory Aging** — optional KPI, requires batch/lot/receipt-level data not defined in BRD scope; not generated.
- **Supplier Performance Score** — optional composite KPI; requires approved weighting scheme (not defined).
- **Perfect Order Rate** — optional KPI; requires "damage-free" + "correct order" definition. Damage_Flag and Delivery_Accuracy_Flag are provided as optional advanced fields so a simplified version can be computed once the project defines what "correct order" means.

---

## 7. ASSUMPTIONS (clearly labelled)

1. Fact_Inventory snapshot represents a daily opening→closing rollforward (BRD did not specify the exact snapshot state).
2. Dim_Date attributes are a general recommendation (BRD names the table but not its fields).
3. Fact_Purchase_Order has no Warehouse_ID (per BRD grain) — inventory receipts and PO receiving are therefore correlated at the product/supplier level, not reconciled row-for-row. This should be validated/documented as a known data-model limitation during the project's data-quality assessment step, consistent with BRD Section 25 (Constraints: "Missing inventory transaction-level data").
4. Fact_Delivery grain is one record per Order_ID (order header) per the BRD field list, even though Fact_Customer_Order is at order-line grain. This means delivery KPIs (on-time/late) apply at the order-header level; if multiple lines within an order have different fulfillment outcomes, this is reflected via the aggregated shortfall signal used to influence delivery timing.
5. Product-Warehouse and Product-Supplier mappings are internal generation logic, not BRD-defined deliverable tables, and are not exported as separate files.

## 8. OUT OF SCOPE (per BRD Section 8.2 — confirmed NOT generated)
No demand forecasting fields, no ML labels, no real-time timestamps, no route/transportation optimization data, no ERP-specific fields.

---

---

## 9. VALIDATION ACTUALLY PERFORMED (checked programmatically before final output)

| # | Check | Result |
|---|---|---|
| 1 | Row count of every table | Confirmed (Section 1 table above) |
| 2 | Total combined row count | 1,266,294 |
| 3 | Date range | 2023-01-01 to 2024-12-31 confirmed on Fact_Inventory min/max |
| 4 | Duplicate primary keys | Present only where intentionally injected (see Section 5): Fact_Inventory 731, PO_Line_ID 151, Delivery_ID 256 — matches injected counts |
| 5 | Foreign-key / orphan-key validity | Orphan Product_ID: 574 (Fact_Inventory), 194 (Fact_Customer_Order); Orphan Order_ID: 154 (Fact_Return); 0 unintended orphans elsewhere — matches injected counts exactly |
| 6 | Table grain | Fact_Inventory unique on (Product_ID, Warehouse_ID, Inventory_Date) except intentional duplicates; PO/Order line IDs unique except intentional duplicates |
| 7 | Missing values | Present only in fields and row-counts documented in Section 5 |
| 8 | Invalid dates | 210 PO rows with Actual_Delivery_Date < Order_Date (intentional, documented) |
| 9 | Abnormal quantities | 1,076 negative Issued_or_Sold_Quantity, 151 negative Received_Quantity (intentional, documented) |
| 10 | Inventory reconciliation | Opening + Received − Issued = Closing holds for all non-defect rows by construction |
| 11 | Order fulfillment consistency | Fulfilled_Quantity ≤ Ordered_Quantity enforced; overall fulfillment rate 86.5% |
| 12 | Delivery date consistency | Actual_Delivery_Date ≥ Shipment_Date enforced for all Delivered records |
| 13 | Supplier performance variation | PO late-delivery rate ranges 5.0%–87.7% across 40 suppliers |
| 14 | Product variation | Fast/Medium/Slow velocity classes drive materially different demand and turnover (not exposed as a column) |
| 15 | Warehouse variation | Pressure factor drives different restock consistency/processing time per warehouse |
| 16 | Regional variation | Delivery late-rate ranges 26.8%–43.2% across 5 regions |
| 17 | Time-based variation | Monthly seasonality multiplier (0.85–1.35) applied to demand |
| 18 | Procurement variation | PO frequency, lead time, and cost variance differ by supplier |
| 19 | Inventory fluctuation | Stockout rate 8.08% overall, varies by product-warehouse pair |
| 20 | Order-volume fluctuation | Order frequency varies by customer segment and month |
| 21 | Pareto analysis possible | Yes — supplier/product/warehouse concentration of issues is uneven, not flat |
| 22 | Trend analysis possible | Yes — 24 months of daily/transactional data with seasonality |
| 23 | Drill-down analysis possible | Yes — Product → Category, Warehouse → Region, Supplier → Category hierarchies present |
| 24 | Cross-functional diagnostic analysis possible | Yes — shortage signal → fulfillment shortfall → delivery delay chain is probabilistic, confirmed non-deterministic (many shortfalled orders still deliver on time and vice versa) |
| 25 | BRD KPIs supported | All KPIs listed in Section 6 above confirmed calculable from present fields; unsupported KPIs explicitly listed as Not Defined in Project Source |

---

*Prepared strictly from the uploaded BRD (v3.0) as primary source of truth. Where the BRD was silent, each gap is labelled above as Assumption, General Recommendation, or Not Defined in Project Source — no business rule, KPI threshold, or schema element was fabricated.*
