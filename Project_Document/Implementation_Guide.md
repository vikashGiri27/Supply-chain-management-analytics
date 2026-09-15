# Supply Chain Data Analytics Project — Implementation Guide

## 1. Project Objective

The objective of this project is to analyze historical supply chain operational data and identify performance gaps, trends, exceptions, variations, and potential contributing factors across three major business areas:

1. **Inventory Imbalance**
2. **Supplier & Procurement Performance**
3. **Order Fulfillment & Delivery Performance**

The project will use:

- **Excel** → Data profiling, review, reconciliation, and validation
- **SQL** → Primary data analysis and business-question solving
- **Power BI** → Data modeling, KPI reporting, dashboards, and visualization

The analysis should answer:

- **What happened?** → Descriptive Analytics
- **What operational patterns or factors may have contributed?** → Diagnostic Analytics

The project should not claim causation merely from correlation or historical association.

---

# 2. Data Dictionary Understanding

The project data model consists of master/dimension tables and operational fact tables.

## 2.1 Dimension / Master Tables

| Table | Business Purpose | Grain |
|---|---|---|
| `Dim_Product` | Product information | One record per `Product_ID` |
| `Dim_Warehouse` | Warehouse information | One record per `Warehouse_ID` |
| `Dim_Supplier` | Supplier information | One record per `Supplier_ID` |
| `Dim_Customer` | Customer information | One record per `Customer_ID` |

## 2.2 Fact Tables

| Table | Business Process | Grain |
|---|---|---|
| `Fact_Inventory` | Inventory snapshots | Product + Warehouse + Inventory Date |
| `Fact_Purchase_Order` | Procurement activity | Purchase Order Line |
| `Fact_Customer_Order` | Customer order activity | Customer Order Line |
| `Fact_Delivery` | Shipment and delivery | Delivery record linked to `Order_ID` |
| `Fact_Return` | Returns analysis | Return record |

> `Fact_Return` is optional and should only be included if return analysis is required.

---

# 3. Available Tables & Important Columns

## 3.1 Dim_Product

### Columns

- `Product_ID`
- `Product_Name`
- `Product_Category`
- `Unit_Cost`
- `Selling_Price`
- `Product_Status`

### Main Analysis

- Product-level inventory
- Inventory value
- Product category comparison
- Stockout analysis
- Procurement analysis
- Order fulfillment issues

---

## 3.2 Dim_Warehouse

### Columns

- `Warehouse_ID`
- `Warehouse_Name`
- `Warehouse_Location`
- `Warehouse_Capacity`

### Main Analysis

- Inventory distribution
- Warehouse stockouts
- Warehouse comparison
- Fulfillment performance

---

## 3.3 Dim_Supplier

### Columns

- `Supplier_ID`
- `Supplier_Name`
- `Supplier_Location`
- `Supplier_Category`
- `Supplier_Status`

### Main Analysis

- Supplier delivery performance
- Delayed purchase orders
- Procurement lead time
- Quantity fulfillment

---

## 3.4 Dim_Customer

### Columns

- `Customer_ID`
- `Customer_Name`
- `Customer_Segment`
- `Customer_Location`

### Main Analysis

- Order volume
- Fulfillment by customer segment/location where appropriate

---

## 3.5 Fact_Inventory

### Columns

- `Inventory_Date`
- `Product_ID`
- `Warehouse_ID`
- `Opening_Stock`
- `Received_Quantity`
- `Issued_or_Sold_Quantity`
- `Closing_Stock`
- `Reorder_Level`

### Grain

> One inventory snapshot per `Product_ID + Warehouse_ID + Inventory_Date`.

### Main Analysis

- Stockouts
- Inventory quantity
- Inventory value
- Warehouse inventory distribution
- Inventory movement
- Inventory versus demand
- Potential overstock

---

## 3.6 Fact_Purchase_Order

### Columns

- `PO_ID`
- `PO_Line_ID`
- `Supplier_ID`
- `Product_ID`
- `Order_Date`
- `Expected_Delivery_Date`
- `Actual_Delivery_Date`
- `Ordered_Quantity`
- `Received_Quantity`
- `Planned_Unit_Cost`
- `Actual_Unit_Cost`
- `PO_Status`

### Grain

> One record per Purchase Order Line.

### Main Analysis

- Supplier performance
- Procurement lead time
- On-time delivery
- Late deliveries
- Quantity variance
- PO fulfillment
- Procurement cost variance

> Because one `PO_ID` can contain multiple lines, PO-level KPIs must be designed carefully to avoid duplicate counting.

---

## 3.7 Fact_Customer_Order

### Columns

- `Order_ID`
- `Order_Line_ID`
- `Customer_ID`
- `Product_ID`
- `Warehouse_ID`
- `Order_Date`
- `Ordered_Quantity`
- `Fulfilled_Quantity`
- `Order_Status`

### Grain

> One record per Customer Order Line.

### Main Analysis

- Order volume
- Order fulfillment
- Fulfillment shortages
- Product-level shortages
- Warehouse fulfillment

---

## 3.8 Fact_Delivery

### Columns

- `Delivery_ID`
- `Order_ID`
- `Shipment_Date`
- `Expected_Delivery_Date`
- `Actual_Delivery_Date`
- `Delivery_Status`
- `Delivery_Region`

### Optional Columns

- `Delivery_Accuracy_Flag`
- `Damage_Flag`
- `Carrier_ID`

> Optional columns should only be used if they actually exist in the dataset.

### Main Analysis

- On-time delivery
- Late delivery
- Delivery time
- Order cycle time
- Regional performance

---

## 3.9 Fact_Return

### Columns

- `Return_ID`
- `Order_ID`
- `Product_ID`
- `Return_Date`
- `Returned_Quantity`
- `Return_Reason`

### Main Analysis

- Return quantity
- Return rate
- Return reasons
- Product return patterns

> Return analysis should only be performed if return records can be reliably linked to the original order.

---

# 4. Data Relationships

The recommended analytical relationships are:

```text
Dim_Product
    │
    ├── Fact_Inventory
    ├── Fact_Purchase_Order
    ├── Fact_Customer_Order
    └── Fact_Return

Dim_Supplier
    │
    └── Fact_Purchase_Order

Dim_Warehouse
    │
    ├── Fact_Inventory
    └── Fact_Customer_Order

Dim_Customer
    │
    └── Fact_Customer_Order

Fact_Customer_Order
    │
    └── Fact_Delivery
```

## Relationship Validation

Before analysis:

- Validate unique keys.
- Check duplicate IDs.
- Confirm fact-table grain.
- Validate foreign-key relationships.
- Check unmatched `Product_ID`.
- Check unmatched `Supplier_ID`.
- Check unmatched `Warehouse_ID`.
- Check unmatched `Customer_ID`.
- Prevent duplicate-row multiplication during joins.

---

# 5. Key Business Problems

## 5.1 Inventory Imbalance

The analysis should investigate:

- Recurring stockouts
- High inventory concentration
- Slow inventory movement
- Uneven warehouse distribution
- Potential overstock
- Inventory versus observed order demand

---

## 5.2 Supplier & Procurement Performance

The analysis should investigate:

- Late supplier deliveries
- Long procurement lead times
- Quantity shortages
- Low PO fulfillment
- Supplier performance variation
- Potential procurement cost variance

---

## 5.3 Order Fulfillment & Delivery Performance

The analysis should investigate:

- Incomplete orders
- Fulfillment shortages
- Late deliveries
- Long order cycle time
- Warehouse performance differences
- Regional delivery variation

---

# 6. Business Questions

The project should focus on approximately **25 meaningful Business Questions** rather than unnecessary analysis.

---

# 6.1 Inventory Imbalance — 9 Questions

## BQ1. Which products experience the highest number of stockouts?

### Required Columns

- `Inventory_Date`
- `Product_ID`
- `Warehouse_ID`
- `Closing_Stock`
- `Product_Name`
- `Product_Category`

### SQL Analysis

1. Filter valid inventory records.
2. Identify records where `Closing_Stock = 0`.
3. Group by product.
4. Count stockout occurrences.
5. Rank products.

### KPI

- Stockout Frequency
- Stockout Rate

### Power BI Visual

- Top N horizontal bar chart
- Product × Warehouse matrix

### Expected Insight

Identify products with recurring inventory availability problems.

---

## BQ2. Which warehouses have the highest stockout frequency?

### Required Columns

- `Warehouse_ID`
- `Inventory_Date`
- `Closing_Stock`

### SQL Analysis

- Identify stockout records.
- Group by warehouse.
- Calculate stockout count and rate.
- Rank warehouses.

### KPI

- Warehouse Stockout Rate

### Power BI Visual

- Ranked bar chart
- KPI card

### Expected Insight

Identify warehouses with the highest inventory availability problems.

---

## BQ3. Which products and warehouses hold the highest inventory quantity?

### Required Columns

- `Product_ID`
- `Warehouse_ID`
- `Inventory_Date`
- `Closing_Stock`

### SQL Analysis

- Determine the appropriate inventory reporting snapshot.
- Aggregate inventory.
- Rank products and warehouses.

### KPI

- Total Inventory Quantity

### Power BI Visual

- Bar chart
- Treemap

### Expected Insight

Identify inventory concentration across products and warehouses.

---

## BQ4. How does inventory change over time?

### Required Columns

- `Inventory_Date`
- `Closing_Stock`
- `Product_ID`
- `Warehouse_ID`

### SQL Analysis

- Aggregate inventory by day/month.
- Calculate historical trends.
- Compare periods.

### KPI

- Total Inventory Quantity

### Power BI Visual

- Line chart

### Expected Insight

Identify periods of increasing, decreasing, or unstable inventory.

---

## BQ5. How does inventory vary across warehouses?

### Required Columns

- `Warehouse_ID`
- `Warehouse_Name`
- `Warehouse_Location`
- `Closing_Stock`

### SQL Analysis

- Aggregate inventory by warehouse.
- Compare warehouse distribution.
- Drill down by product if required.

### KPI

- Warehouse Inventory Quantity
- Warehouse Inventory Variance

### Power BI Visual

- Column chart
- Matrix

### Expected Insight

Identify uneven inventory distribution.

---

## BQ6. Which products show low inventory movement?

### Required Columns

- `Product_ID`
- `Inventory_Date`
- `Opening_Stock`
- `Issued_or_Sold_Quantity`
- `Closing_Stock`

### SQL Analysis

- Aggregate issued/sold quantity over a documented period.
- Compare movement against inventory held.
- Rank low-movement products.

### KPI

- Inventory Movement Metric
- Slow-Moving Inventory

### Power BI Visual

- Scatter chart
- Ranked bar chart

### Expected Insight

Identify products where inventory remains available but movement is relatively low.

---

## BQ7. Is inventory availability aligned with observed customer order demand?

### Required Columns

#### Inventory

- `Product_ID`
- `Warehouse_ID`
- `Inventory_Date`
- `Closing_Stock`

#### Customer Orders

- `Product_ID`
- `Warehouse_ID`
- `Order_Date`
- `Ordered_Quantity`

### SQL Analysis

- Aggregate inventory and order demand at a compatible time grain.
- Compare inventory availability with observed demand.
- Analyze product and warehouse differences.

### KPI

- Inventory Quantity
- Ordered Quantity
- Inventory-to-Demand Comparison

### Power BI Visual

- Clustered column chart
- Matrix
- Scatter chart

### Expected Insight

Identify potential understock or excess inventory relative to observed demand.

---

## BQ8. Are products overstocked in one warehouse while unavailable in another?

### Required Columns

- `Product_ID`
- `Warehouse_ID`
- `Inventory_Date`
- `Closing_Stock`

### SQL Analysis

- Compare the same product across warehouses.
- Identify warehouses with high inventory.
- Identify other warehouses where the same product reaches zero.

### KPI

- Warehouse Inventory Variance

### Power BI Visual

- Product × Warehouse matrix
- Conditional formatting

### Expected Insight

Identify potential inventory distribution imbalance.

---

## BQ9. Which products appear overstocked?

### Required Columns

- `Closing_Stock`
- `Reorder_Level`
- `Product_ID`
- `Warehouse_ID`

### SQL Analysis

This analysis must only be performed after an approved overstock rule is defined.

### KPI

- Overstock Rate

### Power BI Visual

- Top overstock products bar chart

### Expected Insight

Identify products exceeding the approved inventory threshold.

> **Important:** A universal overstock threshold is not defined in the project source. Therefore, Overstock Rate is **Not Defined in Project Source** until a business rule is approved.

---

# 6.2 Supplier & Procurement Performance — 8 Questions

## BQ10. Which suppliers have the lowest on-time delivery performance?

### Required Columns

- `Supplier_ID`
- `Supplier_Name`
- `Expected_Delivery_Date`
- `Actual_Delivery_Date`
- `PO_Status`

### SQL Analysis

- Include valid completed POs.
- Compare actual and expected delivery dates.
- Calculate supplier-level on-time rate.
- Rank suppliers.

### KPI

- On-Time Delivery Rate

### Power BI Visual

- Supplier ranking bar chart

### Expected Insight

Identify suppliers with relatively poor delivery reliability.

---

## BQ11. Which suppliers generate the highest number of delayed purchase orders?

### Required Columns

- `Supplier_ID`
- `PO_ID`
- `Expected_Delivery_Date`
- `Actual_Delivery_Date`
- `PO_Status`

### SQL Analysis

- Filter completed late records.
- Count delayed POs by supplier.
- Rank suppliers.

### KPI

- Late Delivery Count
- Late Delivery Rate

### Power BI Visual

- Ranked bar chart
- Pareto chart

### Expected Insight

Determine whether supplier delays are concentrated among a small number of suppliers.

---

## BQ12. What is the average procurement lead time?

### Required Columns

- `Order_Date`
- `Actual_Delivery_Date`
- `PO_Status`

### SQL Analysis

Calculate:

```text
Actual_Delivery_Date - Order_Date
```

for valid completed purchase orders.

### KPI

- Average Procurement Lead Time

### Power BI Visual

- KPI card
- Trend line

### Expected Insight

Measure the average procurement cycle duration and its variation over time.

---

## BQ13. Which products have the longest procurement lead time?

### Required Columns

- `Product_ID`
- `Product_Name`
- `Order_Date`
- `Actual_Delivery_Date`

### SQL Analysis

1. Calculate lead time at PO-line level.
2. Aggregate by product.
3. Rank products.

### KPI

- Average Procurement Lead Time by Product

### Power BI Visual

- Ranked bar chart

### Expected Insight

Identify products with slower replenishment cycles.

---

## BQ14. Which suppliers frequently deliver less quantity than ordered?

### Required Columns

- `Supplier_ID`
- `Ordered_Quantity`
- `Received_Quantity`

### SQL Analysis

Calculate:

```text
Received_Quantity - Ordered_Quantity
```

Identify negative quantity variance.

### KPI

- Quantity Variance
- PO Fulfillment Rate

### Power BI Visual

- Supplier comparison chart
- Variance bar chart

### Expected Insight

Identify suppliers associated with recurring quantity shortages.

---

## BQ15. What is the purchase order fulfillment rate by supplier?

### Required Columns

- `Supplier_ID`
- `Ordered_Quantity`
- `Received_Quantity`

### SQL Analysis

```text
SUM(Received_Quantity)
/
SUM(Ordered_Quantity)
× 100
```

### KPI

- Purchase Order Fulfillment Rate

### Power BI Visual

- Supplier ranking
- KPI card

### Expected Insight

Identify suppliers consistently under-delivering against ordered quantities.

---

## BQ16. How has supplier performance changed over time?

### Required Columns

- `Order_Date`
- `Actual_Delivery_Date`
- `Supplier_ID`
- `Expected_Delivery_Date`

### SQL Analysis

- Aggregate supplier performance by month.
- Compare suppliers over time.
- Identify improving or deteriorating performance.

### KPI

- Monthly On-Time Delivery Rate
- Monthly Late Delivery Rate

### Power BI Visual

- Line chart
- Supplier trend comparison

### Expected Insight

Identify supplier performance trends.

---

## BQ17. Is there a potential association between supplier delays and inventory shortages?

### Required Columns

#### Purchase Orders

- `Product_ID`
- `Actual_Delivery_Date`
- `Expected_Delivery_Date`

#### Inventory

- `Product_ID`
- `Inventory_Date`
- `Closing_Stock`

### SQL Analysis

1. Identify delayed procurement.
2. Identify inventory shortages for affected products.
3. Align the analysis using appropriate dates.
4. Compare patterns.

### KPI

- Late PO Count
- Stockout Frequency

### Power BI Visual

- Drill-through analysis
- Product-level matrix

### Expected Insight

Identify historical patterns where supplier delays and inventory shortages occur around the same products or periods.

> This should be presented as a **potential contributing factor**, not proven causation.

---

# 6.3 Order Fulfillment & Delivery Performance — 8 Questions

## BQ18. What percentage of customer order quantity is fulfilled?

### Required Columns

- `Ordered_Quantity`
- `Fulfilled_Quantity`

### SQL Analysis

```text
SUM(Fulfilled_Quantity)
/
SUM(Ordered_Quantity)
× 100
```

### KPI

- Order Fulfillment Rate

### Power BI Visual

- KPI card
- Trend chart

### Expected Insight

Measure overall customer order fulfillment performance.

---

## BQ19. Which warehouses have the highest fulfillment shortages?

### Required Columns

- `Warehouse_ID`
- `Ordered_Quantity`
- `Fulfilled_Quantity`

### SQL Analysis

- Calculate unfulfilled quantity.
- Aggregate by warehouse.
- Calculate fulfillment rate.
- Rank warehouses.

### KPI

- Order Fulfillment Rate
- Unfulfilled Quantity

### Power BI Visual

- Ranked bar chart

### Expected Insight

Identify warehouses requiring operational investigation.

---

## BQ20. Which products experience recurring fulfillment shortages?

### Required Columns

- `Product_ID`
- `Ordered_Quantity`
- `Fulfilled_Quantity`

### SQL Analysis

Calculate:

```text
Fulfilled_Quantity - Ordered_Quantity
```

Aggregate by product and identify recurring shortages.

### KPI

- Unfulfilled Quantity
- Product Fulfillment Rate

### Power BI Visual

- Top N bar chart

### Expected Insight

Identify products driving customer fulfillment gaps.

---

## BQ21. What percentage of completed deliveries are on time?

### Required Columns

- `Expected_Delivery_Date`
- `Actual_Delivery_Date`
- `Delivery_Status`

### SQL Analysis

Compare actual and expected delivery dates for valid completed deliveries.

### KPI

- On-Time Delivery Rate

### Power BI Visual

- KPI card
- Trend line

### Expected Insight

Measure overall delivery reliability.

---

## BQ22. Which regions have the highest delivery delays?

### Required Columns

- `Delivery_Region`
- `Expected_Delivery_Date`
- `Actual_Delivery_Date`
- `Delivery_Status`

### SQL Analysis

- Identify late deliveries.
- Aggregate by region.
- Calculate delay rate.
- Rank regions.

### KPI

- Late Delivery Rate
- Average Delivery Delay

### Power BI Visual

- Ranked bar chart
- Map, if location data supports it

### Expected Insight

Identify regions with relatively poor delivery performance.

---

## BQ23. What is the average shipment-to-delivery time?

### Required Columns

- `Shipment_Date`
- `Actual_Delivery_Date`

### SQL Analysis

Calculate:

```text
Actual_Delivery_Date - Shipment_Date
```

### KPI

- Average Delivery Time

### Power BI Visual

- KPI card
- Trend line

### Expected Insight

Measure the time required to deliver an order after shipment.

---

## BQ24. What is the average order-to-delivery cycle time?

### Required Columns

#### Customer Order

- `Order_ID`
- `Order_Date`

#### Delivery

- `Order_ID`
- `Actual_Delivery_Date`

### SQL Analysis

1. Validate the `Order_ID` relationship.
2. Ensure the join does not multiply rows.
3. Join order and delivery information.
4. Calculate:

```text
Actual_Delivery_Date - Order_Date
```

### KPI

- Average Order Cycle Time

### Power BI Visual

- KPI card
- Trend line

### Expected Insight

Measure the end-to-end customer order cycle.

---

## BQ25. Are inventory shortages associated with incomplete order fulfillment?

### Required Columns

#### Inventory

- `Product_ID`
- `Warehouse_ID`
- `Inventory_Date`
- `Closing_Stock`

#### Orders

- `Product_ID`
- `Warehouse_ID`
- `Order_Date`
- `Ordered_Quantity`
- `Fulfilled_Quantity`

### SQL Analysis

- Identify inventory shortages.
- Identify fulfillment gaps.
- Align product, warehouse and time dimensions.
- Compare fulfillment performance during shortage periods.

### KPI

- Stockout Frequency
- Order Fulfillment Rate
- Unfulfilled Quantity

### Power BI Visual

- Matrix
- Drill-through page
- Scatter chart

### Expected Insight

Identify historical patterns suggesting inventory availability may contribute to fulfillment problems.

---

# 7. KPI List

## 7.1 Inventory KPIs

| KPI | Definition |
|---|---|
| Total Inventory Quantity | `SUM(Closing_Stock)` |
| Inventory Value | `Closing_Stock × Unit_Cost` |
| Stockout Rate | Stockout records ÷ valid inventory records × 100 |
| Overstock Rate | Requires approved overstock threshold |
| Slow-Moving Inventory | Requires documented movement logic |
| Days of Inventory | Current Inventory ÷ Average Daily Demand |
| Warehouse Inventory Variance | Comparison of inventory levels across warehouses |

### Important

Standard Inventory Turnover Ratio should not be presented unless the required COGS information is available.

---

## 7.2 Supplier & Procurement KPIs

| KPI | Definition |
|---|---|
| Total Purchase Orders | Count according to documented PO grain |
| On-Time Delivery Rate | On-time completed POs ÷ valid completed POs |
| Late Delivery Rate | Late completed POs ÷ valid completed POs |
| Average Delivery Delay | Average actual date − expected date for late deliveries |
| Average Procurement Lead Time | Actual Delivery Date − Order Date |
| PO Fulfillment Rate | Received Quantity ÷ Ordered Quantity |
| Quantity Variance | Received Quantity − Ordered Quantity |
| Procurement Cost Variance | Actual Cost − Planned Cost, if supported |

> Supplier Performance Score requires documented business rules and approved weights.

---

## 7.3 Order Fulfillment & Delivery KPIs

| KPI | Definition |
|---|---|
| Total Orders | Count according to documented order grain |
| Order Fulfillment Rate | Fulfilled Quantity ÷ Ordered Quantity |
| On-Time Delivery Rate | On-time completed deliveries ÷ valid completed deliveries |
| Late Delivery Rate | Late deliveries ÷ valid completed deliveries |
| Average Delivery Time | Actual Delivery Date − Shipment Date |
| Order Cycle Time | Actual Delivery Date − Order Date |
| Cancellation Rate | Cancelled Orders ÷ Total Orders |
| Return Rate | Only if returns can be reliably linked |

> Perfect Order Rate should only be included if all required supporting fields are available.

---

# 8. SQL Analysis Required

SQL should be the **primary analytical technology** for this project.

## 8.1 Phase 1 — Data Quality SQL

Create SQL checks for:

- Duplicate records
- NULL values
- Invalid identifiers
- Negative quantities
- Invalid dates
- Missing delivery dates
- Invalid status values
- Master/fact relationship issues
- Duplicate business keys
- Invalid date sequences

Example:

```text
Actual_Delivery_Date < Order_Date
```

should be investigated.

Example:

```text
Product_ID not found in Dim_Product
```

should be treated as a data integrity issue.

---

# 8.2 Phase 2 — Exploratory SQL

Analyze:

- Total row counts
- Distinct products
- Distinct warehouses
- Distinct suppliers
- Distinct customers
- Date ranges
- Status distributions
- Quantity distributions
- Product category distributions

---

# 8.3 Phase 3 — KPI SQL

Create reusable SQL queries, CTEs or views for:

```text
Inventory KPIs
        ↓
Supplier KPIs
        ↓
Procurement KPIs
        ↓
Order KPIs
        ↓
Delivery KPIs
```

---

# 8.4 Phase 4 — Diagnostic SQL

Use:

- `JOIN`
- `GROUP BY`
- `HAVING`
- `CASE WHEN`
- `CTE`
- Subqueries
- Aggregate functions
- Date functions
- Window functions
- Ranking
- Variance analysis

Recommended diagnostic structure:

```text
Performance Issue
        ↓
Measure KPI
        ↓
Identify Poor Segment
        ↓
Rank Contributors
        ↓
Trend Analysis
        ↓
Product / Supplier / Warehouse Drill-down
        ↓
Cross-functional Comparison
        ↓
Potential Contributing Factor
```

---

# 9. Power BI Dashboard Structure

The project should contain **three primary dashboards**.

---

# Dashboard 1 — Inventory Performance

## KPI Cards

- Total Inventory Quantity
- Inventory Value
- Stockout Rate
- Overstock Rate — only after approved rule
- Slow-Moving Inventory

## Main Visuals

- Inventory trend
- Warehouse inventory comparison
- Product category inventory
- Top stockout products
- Top overstock products
- Inventory distribution
- Inventory versus observed demand

## Recommended Slicers

- Date
- Product Category
- Product
- Warehouse
- Warehouse Location

---

# Dashboard 2 — Supplier & Procurement Performance

## KPI Cards

- Total Purchase Orders
- On-Time Delivery Rate
- Late Delivery Rate
- Average Procurement Lead Time
- PO Fulfillment Rate

## Main Visuals

- Supplier ranking
- Delayed PO analysis
- Procurement lead-time trend
- Supplier comparison
- Quantity fulfillment variance
- Supplier performance trend

## Recommended Slicers

- Date
- Supplier
- Supplier Category
- Product
- PO Status

---

# Dashboard 3 — Order Fulfillment & Delivery Performance

## KPI Cards

- Total Orders
- Order Fulfillment Rate
- On-Time Delivery Rate
- Late Delivery Rate
- Average Order Cycle Time

## Main Visuals

- Fulfillment trend
- Delivery trend
- Regional performance
- Warehouse fulfillment performance
- Product shortages
- Late delivery analysis
- Order cycle-time analysis

## Recommended Slicers

- Date
- Warehouse
- Product
- Product Category
- Delivery Region
- Order Status
- Delivery Status

---

# 10. Recommended Charts / Visuals

| Business Analysis | Recommended Visual |
|---|---|
| KPI summary | Card |
| Monthly performance | Line chart |
| Top products | Horizontal bar chart |
| Supplier ranking | Ranked bar chart |
| Warehouse comparison | Clustered column chart |
| Product category analysis | Column chart / Treemap |
| Inventory by warehouse/product | Matrix |
| Stockout concentration | Pareto chart |
| Inventory vs demand | Scatter chart |
| Regional delivery performance | Bar chart / Map |
| Supplier performance trend | Line chart |
| Quantity/cost variance | Bar chart |
| Root-cause analysis | Matrix + Drill-through |
| Product-Warehouse imbalance | Matrix + Conditional Formatting |

Every visual should answer a specific business question.

---

# 11. Key Insights to Look For

## 11.1 Inventory Insights

Look for:

- Products responsible for a large proportion of stockouts.
- Warehouses with recurring shortages.
- Products with high inventory in one warehouse and zero inventory in another.
- Products with high inventory but low movement.
- Inventory availability that appears misaligned with observed demand.
- Large differences in inventory distribution between warehouses.

---

## 11.2 Supplier & Procurement Insights

Look for:

- Suppliers with consistently low on-time delivery.
- Suppliers contributing a large share of late POs.
- Products with unusually long procurement lead times.
- Suppliers with recurring quantity shortages.
- Suppliers whose performance is improving or deteriorating.
- Procurement cost differences where planned and actual cost data is available.

---

## 11.3 Fulfillment & Delivery Insights

Look for:

- Warehouses with lower fulfillment rates.
- Products responsible for large unfulfilled quantities.
- Regions with high late-delivery rates.
- Long order-to-delivery cycle times.
- Increasing or decreasing delivery performance.
- Concentration of delivery issues within particular operational segments.

---

# 12. Business Recommendations

Recommendations should follow this structure:

```text
Observation
      ↓
Evidence
      ↓
Business Impact
      ↓
Potential Contributing Factors
      ↓
Recommended Action
```

## 12.1 Inventory Recommendation Example

### Finding

A product repeatedly experiences stockouts at selected warehouses.

### Potential Action

- Review replenishment rules.
- Investigate warehouse inventory distribution.
- Review procurement lead-time patterns.
- Compare inventory availability with observed demand.

---

## 12.2 Supplier Recommendation Example

### Finding

A supplier consistently has low on-time delivery performance.

### Potential Action

- Prioritize supplier performance review.
- Investigate delayed products and PO patterns.
- Monitor procurement lead-time trends.
- Review quantity fulfillment performance.

---

## 12.3 Fulfillment Recommendation Example

### Finding

A warehouse has high unfulfilled quantity.

### Potential Action

- Drill down by product.
- Compare inventory availability.
- Review stockout patterns.
- Investigate potential inventory imbalance.

---

## 12.4 Delivery Recommendation Example

### Finding

A region consistently has high late-delivery performance.

### Potential Action

- Prioritize regional performance investigation.
- Analyze delivery trends.
- Compare shipment-to-delivery time.
- Compare order cycle time.
- Determine whether the issue is concentrated by product or warehouse.

> Final recommendations must be based on actual analytical findings rather than generic assumptions.

---

# 13. Final Project Workflow

## 13.1 End-to-End Workflow

```text
Data Dictionary
      ↓
Data Understanding
      ↓
Data Profiling
      ↓
Data Cleaning
      ↓
Data Quality Validation
      ↓
SQL Data Analysis
      ↓
Business Questions
      ↓
KPI Calculation
      ↓
Diagnostic / Root Cause Analysis
      ↓
Power BI Data Model
      ↓
DAX Measures
      ↓
Dashboard Development
      ↓
SQL vs Power BI Validation
      ↓
Business Insights
      ↓
Business Recommendations
```

---

## 13.2 Step-by-Step Implementation

### Step 1 — Understand Business Requirements

Review:

- Inventory Imbalance
- Supplier & Procurement Performance
- Order Fulfillment & Delivery Performance
- Approved KPI definitions
- Business rules
- Scope and constraints

---

### Step 2 — Understand the Data Dictionary

Document:

- Table names
- Table grain
- Primary keys
- Foreign keys
- Relationships
- Date columns
- Quantity columns
- Cost columns
- Status fields

---

### Step 3 — Data Profiling

Use Excel and SQL to check:

- Row counts
- NULL values
- Duplicates
- Date ranges
- Invalid dates
- Negative quantities
- Unique identifiers
- Relationship integrity

---

### Step 4 — Data Cleaning

Perform only justified cleaning activities.

Document:

- Issue
- Impact
- Cleaning rule
- Number of affected records
- Final treatment

---

### Step 5 — Build SQL Analysis

Recommended SQL file structure:

```text
01_Data_Quality.sql
02_Inventory_Analysis.sql
03_Supplier_Procurement_Analysis.sql
04_Order_Fulfillment_Analysis.sql
05_Delivery_Analysis.sql
06_Diagnostic_Analysis.sql
07_KPI_Validation.sql
```

---

### Step 6 — Answer Business Questions

Implement the approved 20–25 Business Questions using SQL.

---

### Step 7 — Calculate and Validate KPIs

For each KPI:

```text
Business Question
        ↓
KPI Definition
        ↓
Formula
        ↓
Required Columns
        ↓
Source Table
        ↓
SQL Query
        ↓
Power BI Measure
        ↓
Validation
```

---

### Step 8 — Build Power BI Data Model

Recommended structure:

```text
Dimension Tables
       ↓
Fact Tables
       ↓
Relationships
       ↓
Date Table
       ↓
Measures
       ↓
Visuals
```

Use a star-schema approach where practical.

---

### Step 9 — Build Dashboards

Create:

1. **Inventory Performance Dashboard**
2. **Supplier & Procurement Performance Dashboard**
3. **Order Fulfillment & Delivery Performance Dashboard**

---

### Step 10 — Generate Insights

Use:

```text
Observation
→ Evidence
→ Business Impact
→ Potential Contributing Factors
→ Recommended Action
```

---

### Step 11 — Validate

Compare selected Power BI KPI results with SQL outputs.

Validate:

- KPI values
- Filters
- Aggregations
- Relationships
- Date logic
- Duplicate handling

---

# 14. Final Project Architecture

```text
                         SUPPLY CHAIN DATA
                                │
                ┌───────────────┴───────────────┐
                │                               │
          EXCEL REVIEW                     SQL DATABASE
                │                               │
       Profiling / Validation             Cleaning / Analysis
                                                │
                                                ▼
                                      BUSINESS QUESTIONS
                                                │
                                                ▼
                                         KPI CALCULATION
                                                │
                                                ▼
                                      DIAGNOSTIC ANALYSIS
                                                │
                                                ▼
                                      POWER BI DATA MODEL
                                                │
                       ┌────────────────────────┼───────────────────────┐
                       │                        │                       │
                       ▼                        ▼                       ▼
                  INVENTORY                SUPPLIER &              ORDER &
                  DASHBOARD               PROCUREMENT              DELIVERY
                                           DASHBOARD               DASHBOARD
                       │                        │                       │
                       └────────────────────────┼───────────────────────┘
                                                ▼
                                        BUSINESS INSIGHTS
                                                │
                                                ▼
                                       RECOMMENDATIONS
```

---

# 15. Final Project Focus

The project should remain focused on:

```text
Inventory Performance
        +
Supplier & Procurement Performance
        +
Order Fulfillment & Delivery Performance
```

The project should use:

```text
~5% Excel
     +
~95% SQL + Power BI
```

with Excel primarily used for validation and review.

The project should **not** introduce:

- Machine Learning
- Demand Forecasting
- Predictive Analytics
- Real-time Streaming
- ERP Implementation
- Route Optimization
- Automated Operational Decision Systems

These are outside the current project scope.

---

# 16. Final Implementation Sequence

```text
Business Problem
       ↓
Data Dictionary
       ↓
Data Understanding
       ↓
Data Quality Assessment
       ↓
Data Cleaning
       ↓
SQL Analysis
       ↓
Business Questions
       ↓
KPI Calculation
       ↓
Diagnostic Analysis
       ↓
Power BI Data Model
       ↓
DAX Measures
       ↓
Dashboard Development
       ↓
SQL-Power BI Reconciliation
       ↓
Business Insights
       ↓
Business Recommendations
       ↓
Final Project Presentation
```

---

# 17. Final Outcome

The completed project should transform historical supply chain data into actionable business intelligence covering:

- Inventory availability
- Inventory imbalance
- Stockout patterns
- Warehouse performance
- Supplier reliability
- Procurement lead time
- Purchase order fulfillment
- Customer order fulfillment
- Delivery performance
- Regional performance
- Potential contributing factors
- Business recommendations

The final solution should demonstrate the complete Data Analyst workflow:

```text
Data
→ Analysis
→ KPI
→ Business Question
→ Diagnostic Analysis
→ Visualization
→ Insight
→ Recommendation
```

This provides a practical beginner/intermediate portfolio project using **Excel, SQL and Power BI**, while remaining within the approved Supply Chain Management Analytics scope.