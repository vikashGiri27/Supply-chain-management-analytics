# BUSINESS REQUIREMENTS DOCUMENT (BRD)

# SUPPLY CHAIN MANAGEMENT ANALYTICS PROJECT

---

## Document Information

| Item | Details |
|---|---|
| Project Name | Supply Chain Management Analytics Project |
| Document Type | Business Requirements Document (BRD) |
| Document Version | 3.0 |
| Project Type | Data Analytics – Descriptive and Diagnostic Analytics |
| Prepared By | Data Analyst / Business Analyst |
| Primary Tools | Microsoft Excel, SQL, Power BI |
| Optional Tool | Python |
| Document Status | Draft for Project Implementation |

---

# 1. DOCUMENT PURPOSE

The purpose of this Business Requirements Document (BRD) is to define the business, analytical, data, reporting, and technical requirements for the Supply Chain Management Analytics Project.

The project will analyze historical supply chain operational data to identify performance issues, measure key performance indicators (KPIs), investigate evidence-based contributing factors, and provide actionable business recommendations.

The project will focus on three selected high-impact supply chain problem areas:

1. Inventory Imbalance
2. Supplier and Procurement Performance
3. Order Fulfillment and Delivery Performance

The project will primarily use descriptive and diagnostic analytics.

Descriptive analytics will answer:

> **What happened?**

Diagnostic analytics will investigate:

> **What factors and operational patterns may have contributed to the observed performance issue?**

The initial project scope will not include predictive analytics or machine learning.

---

# 2. BUSINESS BACKGROUND

Supply Chain Management involves the coordination and movement of products, materials, and information across the supply chain.

For the purpose of this project, the operational flow is represented as:

```text
Supplier
   ↓
Procurement
   ↓
Warehouse and Inventory
   ↓
Customer Order Processing
   ↓
Order Fulfillment
   ↓
Shipment
   ↓
Customer Delivery
```

Supply chain performance can directly affect:

- Working capital
- Operational costs
- Product availability
- Procurement efficiency
- Customer service
- Revenue
- Customer satisfaction

Performance issues in one area may also affect downstream operations.

For example:

```text
Supplier Delivery Delay
        ↓
Late Inventory Availability
        ↓
Inventory Shortage
        ↓
Order Fulfillment Delay
        ↓
Late Customer Delivery
```

Therefore, this project will analyze selected supply chain performance areas both independently and across related operational processes where supporting data is available.

---

# 3. BUSINESS PROBLEM STATEMENT

The organization may experience operational inefficiencies across inventory management, procurement, supplier performance, order fulfillment, and delivery.

The three selected problem areas for this project are:

1. Inventory Imbalance
2. Supplier and Procurement Performance
3. Order Fulfillment and Delivery Performance

These problem areas were selected because they can significantly affect operational efficiency, cost, product availability, and customer service.

The project will use historical operational data to identify:

- Performance gaps
- Trends
- Exceptions
- Variations
- Concentrations of poor performance
- Relationships between operational factors where supported by available data

The project will not automatically claim causation from correlation or historical patterns. Findings will be presented as evidence-based observations and potential contributing factors unless causal relationships can be independently validated.

---

# 4. PROJECT OBJECTIVES

The objectives of this project are to:

1. Identify inventory imbalance across products and warehouses.
2. Identify products and locations experiencing recurring stockouts.
3. Identify potential overstock situations based on defined business thresholds.
4. Measure supplier delivery performance.
5. Measure procurement lead times and purchase order fulfillment.
6. Identify suppliers with recurring delivery or quantity performance issues.
7. Measure customer order fulfillment performance.
8. Measure on-time and late delivery performance.
9. Identify warehouses, products, regions, or suppliers associated with poor performance.
10. Investigate possible contributing factors using historical data.
11. Develop interactive Power BI dashboards.
12. Provide data-driven and actionable recommendations.

---

# 5. SELECTED BUSINESS PROBLEM AREA 1: INVENTORY IMBALANCE

## 5.1 Business Problem

Inventory imbalance occurs when inventory levels are not aligned with operational demand or are not appropriately distributed across locations.

The business may experience:

- Overstock
- Understock
- Stockouts
- Slow-moving inventory
- Uneven warehouse inventory distribution

### Overstock

Overstock occurs when inventory exceeds the defined business requirement or threshold.

Possible impacts include:

- Increased storage costs
- Working capital tied up in inventory
- Slow inventory movement
- Product obsolescence
- Increased waste or expiry risk where applicable

### Understock / Stockout

Understock occurs when available inventory is insufficient to support required demand.

A stockout occurs when available inventory reaches zero or another business-defined minimum threshold.

Possible impacts include:

- Lost sales opportunities
- Delayed order fulfillment
- Customer dissatisfaction
- Emergency procurement
- Higher operational costs

---

## 5.2 Inventory Business Questions

The analysis should answer:

1. Which products experience recurring stockouts?
2. Which products and warehouses have the highest inventory levels?
3. Which products show slow inventory movement?
4. Which warehouses experience the highest stockout frequency?
5. Which products appear overstocked based on approved business rules?
6. How does inventory vary across warehouses?
7. How does inventory change over time?
8. Is inventory availability aligned with observed sales or order demand?
9. Are there products that are overstocked in one warehouse while unavailable in another warehouse?

---

## 5.3 Inventory KPIs

| KPI | Business Purpose |
|---|---|
| Total Inventory Quantity | Measure total inventory availability |
| Inventory Value | Measure financial value tied to inventory |
| Stockout Rate | Measure frequency of inventory shortages |
| Overstock Rate | Measure frequency of inventory above approved thresholds |
| Inventory Turnover Ratio | Measure inventory movement efficiency |
| Days of Inventory | Estimate inventory coverage based on historical demand |
| Slow-Moving Inventory | Identify inventory with low movement |
| Warehouse Inventory Variance | Identify imbalance between warehouse inventory levels |

### Optional Advanced KPIs

The following KPIs will only be calculated if supporting data is available:

- Inventory Aging
- Expiry Risk
- Batch-Level Inventory Analysis
- Lot-Level Inventory Analysis

---

## 5.4 Inventory KPI Definitions

### Total Inventory Quantity

```text
Sum of Closing Stock
```

### Inventory Value

```text
Closing Stock × Unit Cost
```

### Stockout Rate

```text
Number of Product-Warehouse-Date Records
Where Closing Stock = 0
/
Total Valid Product-Warehouse-Date Records
× 100
```

### Overstock Rate

Overstock must be calculated using an approved threshold.

Example:

```text
Closing Stock > Overstock Threshold
```

The project must document the selected overstock rule.

Possible thresholds may include:

- Reorder Level Multiple
- Maximum Stock Level
- Historical Demand Coverage

No overstock KPI should be calculated until the business rule is defined.

### Inventory Turnover Ratio

Where Cost of Goods Sold data is available:

```text
Cost of Goods Sold
/
Average Inventory Value
```

If Cost of Goods Sold is not available, the project will not present the metric as a standard financial inventory turnover ratio.

An alternative operational inventory movement metric may be used and clearly labelled.

### Days of Inventory

```text
Current Inventory Quantity
/
Average Daily Demand or Sales Quantity
```

Demand calculation period must be documented.

### Inventory Aging

Inventory Aging is optional.

It requires supporting transaction, batch, lot, receipt, or inventory movement data.

It must not be calculated using unsupported assumptions.

---

# 6. SELECTED BUSINESS PROBLEM AREA 2: SUPPLIER AND PROCUREMENT PERFORMANCE

## 6.1 Business Problem

Supplier and procurement performance measures how efficiently suppliers fulfill purchase orders according to expected dates, quantities, and agreed commercial requirements.

Potential performance issues include:

- Late supplier deliveries
- Long procurement lead times
- Quantity shortages
- Purchase order fulfillment issues
- Cost variance where planned and actual cost data exists

Poor supplier performance may contribute to downstream inventory shortages and operational delays.

---

## 6.2 Supplier and Procurement Business Questions

The analysis should answer:

1. Which suppliers have the lowest on-time delivery performance?
2. Which suppliers generate the highest number of delayed purchase orders?
3. What is the average procurement lead time?
4. Which products have the longest procurement lead time?
5. Which suppliers frequently deliver less quantity than ordered?
6. What is the purchase order fulfillment rate?
7. How has supplier performance changed over time?
8. Are supplier delivery delays associated with inventory shortages?
9. Which suppliers should be reviewed based on defined performance criteria?
10. Is there a significant difference between planned and actual procurement cost where data is available?

---

## 6.3 Supplier and Procurement KPIs

| KPI | Business Purpose |
|---|---|
| Total Purchase Orders | Measure procurement activity |
| On-Time Delivery Rate | Measure supplier delivery reliability |
| Late Delivery Rate | Measure delayed deliveries |
| Average Delivery Delay | Measure severity of delays |
| Average Procurement Lead Time | Measure procurement cycle duration |
| Purchase Order Fulfillment Rate | Measure quantity fulfillment |
| Quantity Variance | Measure difference between ordered and received quantity |
| Procurement Cost Variance | Measure planned versus actual cost, if supported |
| Supplier Performance Score | Optional composite performance KPI |

---

## 6.4 Supplier KPI Definitions

### On-Time Delivery Rate

```text
Completed Purchase Orders Delivered
On or Before Expected Delivery Date
/
Total Completed Purchase Orders
With Valid Expected and Actual Delivery Dates
× 100
```

Open and cancelled purchase orders must be excluded unless the business defines otherwise.

### Late Delivery Rate

```text
Completed Purchase Orders Delivered
After Expected Delivery Date
/
Total Completed Purchase Orders
With Valid Expected and Actual Delivery Dates
× 100
```

### Average Delivery Delay

```text
Average
(Actual Delivery Date - Expected Delivery Date)
For Late Deliveries
```

### Average Procurement Lead Time

```text
Actual Delivery Date - Purchase Order Date
```

Only valid completed purchase orders should be included.

### Purchase Order Fulfillment Rate

```text
Total Received Quantity
/
Total Ordered Quantity
× 100
```

### Quantity Variance

```text
Received Quantity - Ordered Quantity
```

### Procurement Cost Variance

This KPI will only be calculated when the dataset includes both:

- Planned or Expected Cost
- Actual Procurement Cost

Example:

```text
Actual Purchase Cost - Planned Purchase Cost
```

The data source and cost definition must be documented.

### Supplier Performance Score

This is an optional KPI.

A composite supplier score must not use arbitrary weights without documented business approval.

Possible components may include:

- On-Time Delivery
- Purchase Order Fulfillment
- Quantity Accuracy
- Quality Performance, if data is available

Weights must be documented as project assumptions or approved business rules.

---

# 7. SELECTED BUSINESS PROBLEM AREA 3: ORDER FULFILLMENT AND DELIVERY PERFORMANCE

## 7.1 Business Problem

Order fulfillment and delivery performance measures how effectively customer orders are processed, fulfilled, shipped, and delivered.

Potential issues include:

- Incomplete orders
- Delayed fulfillment
- Late deliveries
- Warehouse processing delays
- Regional delivery variation
- Order cancellations
- Customer returns

These issues can affect customer experience and operational performance.

---

## 7.2 Order Fulfillment and Delivery Business Questions

The analysis should answer:

1. What percentage of customer orders are fully fulfilled?
2. What percentage of completed deliveries are on time?
3. Which warehouses have the highest fulfillment issues?
4. Which regions have the highest delivery delays?
5. Which products experience recurring fulfillment shortages?
6. What is the average order-to-delivery cycle time?
7. How does delivery performance change over time?
8. Are inventory shortages associated with incomplete order fulfillment?
9. Are supplier delays associated with downstream delivery performance?
10. Which operational segments should be prioritized for improvement?

---

## 7.3 Order Fulfillment and Delivery KPIs

| KPI | Business Purpose |
|---|---|
| Total Orders | Measure customer order volume |
| Order Fulfillment Rate | Measure fulfillment performance |
| On-Time Delivery Rate | Measure delivery reliability |
| Late Delivery Rate | Measure delayed delivery performance |
| Average Delivery Time | Measure shipment-to-delivery duration |
| Order Cycle Time | Measure order-to-delivery duration |
| Cancellation Rate | Measure cancelled orders |
| Return Rate | Measure returned orders |
| Perfect Order Rate | Optional KPI subject to required data availability |

---

## 7.4 Order and Delivery KPI Definitions

### Order Fulfillment Rate

```text
Total Fulfilled Quantity
/
Total Ordered Quantity
× 100
```

### On-Time Delivery Rate

```text
Completed Deliveries
Delivered On or Before Expected Delivery Date
/
Total Completed Deliveries
With Valid Expected and Actual Delivery Dates
× 100
```

### Late Delivery Rate

```text
Completed Deliveries
Delivered After Expected Delivery Date
/
Total Completed Deliveries
With Valid Expected and Actual Delivery Dates
× 100
```

### Average Delivery Time

```text
Actual Delivery Date - Shipment Date
```

### Order Cycle Time

```text
Actual Delivery Date - Order Date
```

### Cancellation Rate

```text
Cancelled Orders
/
Total Orders
× 100
```

### Return Rate

The return rate will only be calculated if return records can be reliably linked to the original order.

```text
Returned Orders or Returned Quantity
/
Eligible Delivered Orders or Quantity
× 100
```

The numerator and denominator definition must be clearly documented.

### Perfect Order Rate

Perfect Order Rate is optional.

It will only be calculated when all required supporting fields are available.

Possible required conditions include:

- Delivered on time
- Delivered in full
- Correct order
- Damage-free delivery

If accuracy or damage information is unavailable, the project must use a simplified metric and clearly label it.

---

# 8. PROJECT SCOPE

## 8.1 In Scope

The project will include:

- Historical data analysis
- Inventory analysis
- Warehouse performance analysis
- Supplier performance analysis
- Procurement analysis
- Purchase order analysis
- Customer order analysis
- Order fulfillment analysis
- Delivery performance analysis
- KPI development
- Data quality assessment
- Root cause investigation
- SQL analysis
- Power BI dashboards
- Excel-based data review and validation
- Optional Python-based advanced analysis

---

## 8.2 Out of Scope

The initial project will not include:

- Demand forecasting
- Machine learning models
- Predictive analytics
- Real-time streaming analytics
- ERP implementation
- Supplier contract negotiation
- Transportation route optimization
- Automated operational decision systems

---

# 9. STAKEHOLDERS

| Stakeholder | Role |
|---|---|
| Senior Management | Uses insights for strategic decisions |
| Supply Chain Manager | Reviews overall supply chain performance |
| Procurement Manager | Reviews supplier and procurement performance |
| Warehouse Manager | Reviews inventory and warehouse performance |
| Operations Manager | Reviews operational efficiency |
| Logistics Manager | Reviews shipment and delivery performance |
| Data Analyst | Performs analysis and develops dashboards |
| Business Analyst | Defines and validates business requirements |

---

# 10. DATA REQUIREMENTS

The project requires data from selected supply chain operational areas.

---

## 10.1 Product Master

| Field |
|---|
| Product_ID |
| Product_Name |
| Product_Category |
| Unit_Cost |
| Selling_Price |
| Product_Status |

**Recommended Grain:** One record per Product_ID.

---

## 10.2 Warehouse Master

| Field |
|---|
| Warehouse_ID |
| Warehouse_Name |
| Warehouse_Location |
| Warehouse_Capacity |

**Recommended Grain:** One record per Warehouse_ID.

---

## 10.3 Supplier Master

| Field |
|---|
| Supplier_ID |
| Supplier_Name |
| Supplier_Location |
| Supplier_Category |
| Supplier_Status |

**Recommended Grain:** One record per Supplier_ID.

---

## 10.4 Customer Master

| Field |
|---|
| Customer_ID |
| Customer_Name |
| Customer_Segment |
| Customer_Location |

Customer personal information should not be included unless required for analysis.

**Recommended Grain:** One record per Customer_ID.

---

## 10.5 Inventory Fact Data

| Field |
|---|
| Inventory_Date |
| Product_ID |
| Warehouse_ID |
| Opening_Stock |
| Received_Quantity |
| Issued_or_Sold_Quantity |
| Closing_Stock |
| Reorder_Level |

### Required Data Grain

For this project, inventory data should be treated as:

> One inventory snapshot per Product_ID, Warehouse_ID, and Inventory_Date.

The source system must confirm whether the snapshot represents opening, closing, or another inventory state.

---

## 10.6 Purchase Order Fact Data

| Field |
|---|
| PO_ID |
| PO_Line_ID |
| Supplier_ID |
| Product_ID |
| Order_Date |
| Expected_Delivery_Date |
| Actual_Delivery_Date |
| Ordered_Quantity |
| Received_Quantity |
| Planned_Unit_Cost (Optional) |
| Actual_Unit_Cost |
| PO_Status |

### Required Data Grain

Preferred grain:

> One record per Purchase Order Line.

This allows a single purchase order to contain multiple products.

---

## 10.7 Customer Order Fact Data

| Field |
|---|
| Order_ID |
| Order_Line_ID |
| Customer_ID |
| Product_ID |
| Warehouse_ID |
| Order_Date |
| Ordered_Quantity |
| Fulfilled_Quantity |
| Order_Status |

### Required Data Grain

Preferred grain:

> One record per Customer Order Line.

---

## 10.8 Delivery Fact Data

| Field |
|---|
| Delivery_ID |
| Order_ID |
| Shipment_Date |
| Expected_Delivery_Date |
| Actual_Delivery_Date |
| Delivery_Status |
| Delivery_Region |

Optional advanced fields:

| Field |
|---|
| Delivery_Accuracy_Flag |
| Damage_Flag |
| Carrier_ID |

---

## 10.9 Returns Data

Returns data is required only if Return Rate or return analysis is included.

| Field |
|---|
| Return_ID |
| Order_ID |
| Product_ID |
| Return_Date |
| Returned_Quantity |
| Return_Reason |

---

# 11. DATA MODEL REQUIREMENTS

The recommended analytical model will follow a star schema where practical.

## Dimension Tables

```text
Dim_Product
Dim_Supplier
Dim_Warehouse
Dim_Customer
Dim_Date
```

## Fact Tables

```text
Fact_Inventory
Fact_Purchase_Order
Fact_Customer_Order
Fact_Delivery
Fact_Return
```

Recommended relationships include:

```text
Dim_Product
   ├── Fact_Inventory
   ├── Fact_Purchase_Order
   ├── Fact_Customer_Order
   └── Fact_Return

Dim_Supplier
   └── Fact_Purchase_Order

Dim_Warehouse
   ├── Fact_Inventory
   └── Fact_Customer_Order

Dim_Customer
   └── Fact_Customer_Order

Fact_Customer_Order
   └── Fact_Delivery
```

All relationships must be validated using unique business keys and documented join logic.

---

# 12. KPI-TO-DATA REQUIREMENT MAPPING

Every KPI used in the project must have:

```text
Business Question
       ↓
KPI
       ↓
Business Definition
       ↓
Calculation Formula
       ↓
Required Columns
       ↓
Source Table
       ↓
Analysis Output
```

No KPI should be included in the final dashboard unless the required data and calculation logic are available and documented.

---

# 13. DATA QUALITY REQUIREMENTS

Before analysis, data must be checked for:

- Duplicate records
- Missing values
- Invalid dates
- Incorrect data types
- Negative quantities where not valid
- Invalid identifiers
- Inconsistent product names
- Inconsistent supplier names
- Missing expected delivery dates
- Missing actual delivery dates
- Invalid table relationships

Examples:

```text
Actual Delivery Date < Order Date
```

This must be investigated.

```text
Received Quantity < 0
```

This must be investigated unless negative quantities represent a documented business transaction.

```text
Product_ID does not exist in Product Master
```

This must be treated as a data integrity issue.

All cleaning decisions must be documented.

---

# 14. EXCEL REQUIREMENTS

Excel will primarily be used for:

- Initial data review
- Data profiling
- Duplicate checks
- Missing value review
- Basic cleaning
- Data formatting
- Date standardization
- Pivot tables
- Spot checking
- Validation of selected KPI calculations

Excel will not be the primary tool for large-scale relational analysis.

---

# 15. SQL REQUIREMENTS

SQL will be the primary analytical tool for structured analysis.

SQL activities will include:

- Data cleaning where appropriate
- Data transformation
- Table joins
- Aggregations
- KPI calculations
- Time-based analysis
- Product analysis
- Warehouse analysis
- Supplier analysis
- Delivery analysis
- Root cause investigation

SQL concepts may include:

```text
SELECT
WHERE
GROUP BY
HAVING
JOIN
CASE WHEN
CTE
Subqueries
Aggregate Functions
Date Functions
Window Functions
```

---

# 16. POWER BI REQUIREMENTS

Power BI will be used to:

- Build the analytical data model
- Create KPI measures
- Develop interactive dashboards
- Provide filters and slicers
- Support drill-down analysis
- Present trends and performance comparisons

SQL should remain the primary source for detailed analytical logic where appropriate, while Power BI will focus on reporting, visualization, and approved measure calculations.

---

# 17. DASHBOARD REQUIREMENTS

## Dashboard 1: Inventory Performance

### KPI Cards

- Total Inventory Quantity
- Inventory Value
- Stockout Rate
- Overstock Rate
- Slow-Moving Inventory

### Analysis

- Inventory trend
- Warehouse comparison
- Product category analysis
- Top stockout products
- Top overstock products
- Inventory distribution

---

## Dashboard 2: Supplier and Procurement Performance

### KPI Cards

- Total Purchase Orders
- On-Time Delivery Rate
- Late Delivery Rate
- Average Procurement Lead Time
- Purchase Order Fulfillment Rate

### Analysis

- Supplier ranking
- Delayed purchase orders
- Lead time trends
- Supplier comparison
- Quantity fulfillment analysis

---

## Dashboard 3: Order Fulfillment and Delivery Performance

### KPI Cards

- Total Orders
- Order Fulfillment Rate
- On-Time Delivery Rate
- Late Delivery Rate
- Average Order Cycle Time

### Analysis

- Delivery trend
- Regional performance
- Warehouse performance
- Product fulfillment issues
- Late delivery analysis

---

# 18. ROOT CAUSE INVESTIGATION METHODOLOGY

The project will use historical data to investigate contributing factors.

The recommended approach is:

```text
Business Problem
        ↓
Measure Performance Gap
        ↓
Segment the Data
        ↓
Trend Analysis
        ↓
Pareto Analysis
        ↓
Drill-Down Analysis
        ↓
Cross-Functional Comparison
        ↓
Identify Evidence-Based Contributing Factors
        ↓
Business Recommendation
```

Analytical methods may include:

- Trend Analysis
- Pareto Analysis
- Variance Analysis
- Cross-tabulation
- Segmentation
- Correlation Analysis
- Drill-down Analysis

Correlation or association must not automatically be presented as causation.

---

# 19. OPTIONAL PYTHON REQUIREMENTS

Python is optional and should be used only after the core project has been completed using Excel, SQL, and Power BI.

Possible use cases include:

- Advanced exploratory data analysis
- Outlier detection
- Statistical analysis
- Correlation analysis
- Data validation automation
- Advanced visualizations
- Automated reporting

Python must provide additional analytical value and should not unnecessarily duplicate analysis already completed in SQL or Power BI.

---

# 20. PROJECT WORKFLOW

```text
STEP 1
Business Understanding
        ↓
STEP 2
Business Requirements Definition
        ↓
STEP 3
Data Collection
        ↓
STEP 4
Data Profiling
        ↓
STEP 5
Excel Review and Validation
        ↓
STEP 6
Data Cleaning and Preparation
        ↓
STEP 7
SQL Data Analysis
        ↓
STEP 8
KPI Calculation
        ↓
STEP 9
Root Cause Investigation
        ↓
STEP 10
Power BI Data Model
        ↓
STEP 11
Dashboard Development
        ↓
STEP 12
Business Insights
        ↓
STEP 13
Recommendations
        ↓
STEP 14
Optional Python Advanced Analysis
```

---

# 21. BUSINESS INSIGHT AND RECOMMENDATION FRAMEWORK

Insights must follow the structure:

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

Example:

### Observation

Product X experienced repeated stockouts.

### Evidence

Historical inventory records show multiple periods where Closing Stock was zero while customer order demand existed.

### Business Impact

Potential order fulfillment delays and lost sales opportunities.

### Potential Contributing Factors

Possible contributing factors may include supplier delays, high demand, or insufficient inventory replenishment.

### Recommendation

Review replenishment rules and investigate supplier lead-time performance for the affected product.

Recommendations must be linked to analytical findings.

---

# 22. PROJECT DELIVERABLES

The final project deliverables will include:

1. Business Requirements Document
2. Data Dictionary
3. Data Quality Assessment
4. Cleaned and Prepared Dataset
5. SQL Database Schema
6. SQL Analysis Scripts
7. KPI Definition Document
8. KPI-to-Data Mapping
9. Root Cause Analysis Findings
10. Power BI Data Model
11. Inventory Dashboard
12. Supplier and Procurement Dashboard
13. Order Fulfillment and Delivery Dashboard
14. Business Insights Report
15. Final Recommendations
16. Optional Python Analysis Notebook

---

# 23. ACCEPTANCE CRITERIA

The project will be considered complete when:

1. Required datasets are loaded and validated.
2. Key business relationships between tables are documented.
3. Data quality issues are assessed and documented.
4. KPI definitions are documented.
5. KPI calculations are validated against source data or SQL outputs.
6. Inventory analysis identifies stockout and imbalance patterns.
7. Supplier performance analysis is completed.
8. Procurement lead-time analysis is completed.
9. Order fulfillment analysis is completed.
10. Delivery performance analysis is completed.
11. Three Power BI dashboards are developed.
12. Dashboard KPIs reconcile with approved SQL calculations.
13. Business insights are supported by analytical evidence.
14. Recommendations are linked to identified findings.
15. Data limitations and assumptions are documented.

---

# 24. ASSUMPTIONS

The project assumes:

- Historical operational data is available.
- Product identifiers can be consistently mapped.
- Supplier identifiers are available for procurement records.
- Warehouse identifiers are available for inventory records.
- Expected and actual delivery dates are available for delivery performance analysis.
- Order quantities and fulfillment quantities are available.
- Data grain can be confirmed or reasonably documented.
- Missing data treatment can be defined.

---

# 25. CONSTRAINTS

Potential constraints include:

- Limited historical data
- Missing data
- Inconsistent identifiers
- Limited root cause data
- No real-time integration
- Missing transportation details
- Missing supplier quality data
- Missing inventory transaction-level data

---

# 26. PROJECT RISKS

| Risk | Impact | Mitigation |
|---|---|---|
| Missing Data | Incomplete KPI calculation | Document limitations and exclude unsupported KPIs |
| Poor Data Quality | Incorrect insights | Perform validation and reconciliation |
| Duplicate Records | KPI inflation | Apply duplicate identification rules |
| Inconsistent IDs | Incorrect joins | Create data mapping rules |
| Missing Dates | Inaccurate delivery KPIs | Exclude invalid records based on documented rules |
| Unknown Data Grain | Incorrect aggregation | Confirm or document grain before analysis |
| Unsupported KPI | Incorrect reporting | Apply KPI-to-data mapping validation |
| Assumed Causation | Misleading conclusions | Use evidence-based contributing factor language |

---

# 27. PROJECT DEPENDENCIES

The project depends on:

- Availability of required datasets
- Availability of historical dates
- Consistent identifiers
- Defined business rules
- Data access
- KPI calculation approval
- Data model validation

---

# 28. FUTURE ENHANCEMENTS

Future phases may include:

- Demand forecasting
- Inventory forecasting
- Safety stock optimization
- Supplier risk prediction
- Delivery delay prediction
- Machine learning models
- Automated ETL pipelines
- Real-time dashboards
- Advanced Python analytics
- Transportation optimization

---

# 29. FINAL PROJECT OUTCOME

The Supply Chain Management Analytics Project will provide a structured analytical solution for understanding selected operational performance issues across:

- Inventory
- Warehousing
- Suppliers
- Procurement
- Customer orders
- Order fulfillment
- Delivery

The final analytical solution will provide:

- KPI visibility
- Historical performance trends
- Product analysis
- Warehouse analysis
- Supplier analysis
- Procurement analysis
- Delivery analysis
- Evidence-based contributing factor investigation
- Actionable recommendations

The project lifecycle will follow:

```text
Business Problem
        ↓
Business Requirements
        ↓
Data Requirements
        ↓
Data Collection
        ↓
Data Quality Assessment
        ↓
Excel Validation
        ↓
SQL Analysis
        ↓
KPI Calculation
        ↓
Root Cause Investigation
        ↓
Power BI Dashboard
        ↓
Business Insights
        ↓
Recommendations
```

The overall purpose of the project is to transform historical supply chain operational data into meaningful analytical insights that support improved decision-making across inventory management, procurement, supplier performance, order fulfillment, and delivery operations.

---

# 30. APPROVAL AND SIGN-OFF

| Stakeholder | Role | Approval |
|---|---|---|
| Project Owner | Business Requirements Owner | Pending |
| Data Analyst | Analytics Implementation | Pending |
| Supply Chain Representative | Business Validation | Pending |
| Project Reviewer | Final Review | Pending |

---

**END OF DOCUMENT**
