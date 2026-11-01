# Supply Chain Management Analytics

### End-to-End Business Analytics Project | SQL | Microsoft Power BI | Excel

![Project](https://img.shields.io/badge/Project-Supply%20Chain%20Analytics-1F4E79)
![SQL](https://img.shields.io/badge/SQL-MySQL%20Compatible-4479A1)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811)
![Analytics](https://img.shields.io/badge/Analytics-Descriptive%20%26%20Diagnostic-198754)

## 1. Project Overview

The **Supply Chain Management Analytics Project** is an end-to-end Descriptive and Diagnostic Analytics project focused on understanding historical supply chain operations, identifying performance gaps, and generating actionable business insights.

The project analyzes three major business areas:

1. **Inventory Performance** – Inventory availability, stockouts, and warehouse-level inventory distribution.
2. **Supplier & Procurement Performance** – Supplier delivery reliability, procurement lead time, and purchase order fulfillment.
3. **Order Fulfillment & Delivery Performance** – Customer order fulfillment, delivery reliability, regional performance, and order cycle time.

The objective is to transform historical operational data into meaningful business KPIs and interactive Power BI dashboards that support data-driven business decisions.

## 2. Business Objectives

- Monitor inventory availability and identify stockout patterns across products and warehouses.
- Evaluate supplier reliability and procurement efficiency.
- Analyze purchase order delivery performance and quantity shortfalls.
- Measure customer order fulfillment and delivery performance.
- Compare warehouse and regional operational performance.
- Identify trends, exceptions, and potential contributing factors behind performance gaps.
- Present business findings through interactive Power BI dashboards.

## 3. Project Scope

### In Scope

- Historical supply chain data analysis.
- Inventory and warehouse performance analysis.
- Supplier and procurement performance analysis.
- Purchase order fulfillment and delivery analysis.
- Customer order fulfillment analysis.
- Delivery performance and order cycle-time analysis.
- KPI calculations and business reporting.
- Data profiling and quality assessment.
- SQL-based analytical investigation.
- Power BI data modeling, DAX measures, and dashboards.
- Excel-based profiling, reconciliation, and validation.

### Out of Scope

The following activities are outside the approved project scope:

- Demand forecasting.
- Machine learning and predictive analytics.
- Real-time data streaming.
- ERP implementation.
- Transportation route optimization.
- Automated operational decision systems.

## 4. Dataset Description

The project uses a **synthetic historical supply chain dataset** designed to represent realistic operational scenarios and variations.

- **Historical Period:** January 2023 – December 2024.
- **Data Type:** Synthetic operational data.
- **Data Structure:** Dimension tables and fact tables.
- **Analytical Approach:** Historical, descriptive, and diagnostic analysis.

### Dimension Tables

| Table | Business Purpose |
|---|---|
| `Dim_Product` | Product master information |
| `Dim_Warehouse` | Warehouse details and capacity |
| `Dim_Supplier` | Supplier master information |
| `Dim_Customer` | Customer information and segments |
| `Dim_Date` | Calendar and date attributes |

### Fact Tables

| Table | Business Purpose |
|---|---|
| `Fact_Inventory` | Daily inventory snapshots and stock movements |
| `Fact_Purchase_Order` | Purchase order and procurement transactions |
| `Fact_Customer_Order` | Customer order line transactions |
| `Fact_Delivery` | Shipment and delivery information |
| `Fact_Return` | Customer return records |

The tables follow their documented business grain. For example, inventory is recorded at product–warehouse–date level, purchase orders and customer orders are recorded at line level, and delivery records are maintained at order-header level.

## 5. Tools & Technologies

| Technology | Project Usage |
|---|---|
| **MySQL-compatible SQL** | Data exploration, joins, aggregations, data quality checks, KPI calculations, and business analysis |
| **Microsoft Power BI** | Data modeling, DAX measures, KPI cards, interactive filters, and dashboards |
| **Microsoft Excel** | Data profiling, duplicate checks, missing-value analysis, reconciliation, and validation |
| **Git & GitHub** | Version control, project organization, and documentation |
| **Visual Studio Code** | SQL and Markdown editing |

**Primary technologies:** SQL and Microsoft Power BI.  
**Supporting technology:** Microsoft Excel.

## 6. Project Methodology

The project follows a structured business analytics workflow:

1. **Business Understanding:** Reviewed the BRD to understand business problems, objectives, scope, KPIs, and dashboard requirements.
2. **Data Understanding:** Reviewed the data dictionary, table structures, columns, relationships, and data grain.
3. **Data Profiling:** Used Excel to inspect record counts, data types, missing values, duplicates, key uniqueness, and unusual values.
4. **Data Quality Assessment:** Identified data quality concerns such as missing values, invalid quantities, inconsistent values, and orphan keys.
5. **SQL Analysis:** Used SQL for data validation, joins, aggregations, KPI calculations, and investigation of business questions.
6. **Data Modeling:** Organized the data using dimension and fact tables according to the documented relationship design.
7. **Power BI Development:** Created DAX measures, KPI cards, interactive slicers, and analytical visualizations.
8. **Business Insights:** Used trends, comparisons, rankings, and segmentation to identify performance gaps and potential contributing factors.

## 7. SQL Analysis

SQL was used as the primary analytical technology to investigate business questions across the three focus areas.

### Inventory Performance

- Total inventory quantity and inventory value.
- Stockout frequency and stockout rate.
- Product-wise and warehouse-wise inventory performance.
- Inventory movement and historical trends.
- Identification of products with stockout issues.

### Supplier & Procurement Performance

- Total purchase orders.
- Supplier-wise purchase order performance.
- On-time and late delivery analysis.
- Average procurement lead time.
- Purchase order fulfillment rate.
- Ordered versus received quantity analysis.
- Identification of suppliers with delivery delays and quantity shortfalls.

### Order Fulfillment & Delivery Performance

- Total customer orders.
- Order fulfillment rate.
- On-time and late delivery rates.
- Average order cycle time.
- Warehouse-wise fulfillment performance.
- Regional delivery performance.
- Identification of products with high unfulfilled order quantities.

## 8. Power BI Dashboards

Three interactive dashboards were developed around the approved project focus areas.

### Dashboard 1 — Inventory Performance

**Objective:** Monitor inventory availability, stock levels, stockout patterns, and warehouse performance.

**Implemented KPI Cards**

- Total Inventory Quantity
- Inventory Value
- Stockout Rate
- Stockout Rows

**Key Visualizations**

- Monthly inventory trend.
- Warehouse-wise inventory comparison.
- Product and warehouse inventory distribution.
- Product category contribution.
- Top stockout products.

**Business Questions Addressed**

- How is inventory changing over time?
- Which warehouses hold comparatively higher or lower inventory?
- Which products and categories contribute to inventory distribution?
- Which products experience stockout issues?

![Inventory Performance Dashboard](Power%20BI/Dashboard%20Screenshots/01_Inventory_Performance.png)

### Dashboard 2 — Supplier & Procurement Performance

**Objective:** Evaluate supplier reliability, purchase order performance, and procurement efficiency.

**Implemented KPI Cards**

- Total Purchase Orders
- On-Time Delivery Rate
- Late Delivery Rate
- Average Procurement Lead Time
- Purchase Order Fulfillment Rate

**Key Visualizations**

- Procurement lead time trend.
- Supplier-wise purchase order comparison.
- Delayed purchase order analysis.
- Monthly supplier delivery performance.
- Ordered versus received quantity.
- Purchase order quantity shortfall.

**Business Questions Addressed**

- Which suppliers have comparatively higher delivery delays?
- How does supplier delivery performance change over time?
- Which suppliers contribute to delayed purchase orders?
- Where are quantity shortfalls occurring?
- How efficiently are purchase orders being fulfilled?

![Supplier & Procurement Performance Dashboard](Power%20BI/Dashboard%20Screenshots/02_Supplier_Procurement_Performance.png)

### Dashboard 3 — Order Fulfillment & Delivery Performance

**Objective:** Monitor customer order fulfillment, delivery reliability, warehouse performance, and order cycle time.

**Implemented KPI Cards**

- Total Orders
- Order Fulfillment Rate
- On-Time Delivery Rate
- Late Delivery Rate
- Average Order Cycle Time

**Key Visualizations**

- Monthly order fulfillment trend.
- On-time versus late delivery comparison.
- Bottom 5 warehouses by order fulfillment rate.
- Top 5 products by unfulfilled order quantity.
- On-time versus late delivery rate by region.
- Monthly average order cycle time.

**Business Questions Addressed**

- How efficiently are customer orders being fulfilled?
- How does fulfillment performance change over time?
- Which warehouses have comparatively lower fulfillment rates?
- Which products contribute most to unfulfilled order quantity?
- Which regions experience higher late-delivery rates?
- How does average order cycle time vary over time?

![Order Fulfillment & Delivery Performance Dashboard](Power%20BI/Dashboard%20Screenshots/03_Order_Fulfillment_Delivery.png)

### Dashboard Interactivity & Design

The dashboards include interactive slicers, including:

- Month Year / Date
- Warehouse
- Product
- Product Category
- Order Status, where applicable

Visuals were selected according to the analytical purpose:

- **Line and area charts:** Historical trends.
- **Clustered and stacked column charts:** Performance comparisons and composition.
- **Horizontal bar charts:** Product, supplier, and warehouse rankings.
- **KPI cards:** High-level performance indicators.
- **Matrix / heatmap-style analysis:** Multi-dimensional comparisons.

The dashboards use a consistent visual theme and navigation structure to provide a clear and connected view of supply chain performance.

## 9. Data Quality Assessment

Data profiling and quality assessment were important parts of the project.

The checks included:

- Record counts and column structure.
- Data types and numeric values.
- Primary key uniqueness.
- Missing and NULL values.
- Duplicate records.
- Orphan foreign keys.
- Negative or unusual quantity values.
- Date consistency.
- Fact table grain and relationship checks.
- Inventory quantity reconciliation.

Examples of data quality scenarios identified in the dataset include missing inventory receipt quantities, negative issued or sold quantities, and orphan product identifiers.

Data quality issues were evaluated in their business context. For example, a missing actual delivery date for an order that is still in transit can be a valid operational state rather than a data defect.

**Important:** Data profiling, issue identification, and data cleaning are separate activities. Only corrections actually performed and verified should be reported as completed.

## 10. KPI & Business Analysis Approach

The project follows a structured approach:

**Business Question → KPI → Definition → Required Data → SQL Logic → Power BI Measure → Validation**

KPI definitions follow the BRD. For example:

**Stockout Rate**

Number of valid product–warehouse–date records where Closing Stock = 0  
÷ Total valid product–warehouse–date records × 100

**On-Time Delivery Rate**

Completed deliveries delivered on or before the expected delivery date  
÷ Completed deliveries with valid expected and actual delivery dates × 100

**Late Delivery Rate**

Completed deliveries delivered after the expected delivery date  
÷ Completed deliveries with valid expected and actual delivery dates × 100

KPIs requiring additional business rules or thresholds are not treated as approved metrics until those rules are defined. Examples include Overstock Rate, Inventory Aging, Supplier Performance Score, and Perfect Order Rate.

## 11. Business Insights & Recommendations

The dashboards support evidence-based investigation of:

- Products and warehouses experiencing recurring stockouts.
- Differences in inventory distribution across warehouses.
- Suppliers with comparatively higher delivery delays.
- Procurement lead-time variations.
- Purchase orders with quantity shortfalls.
- Warehouses with comparatively lower fulfillment rates.
- Regional differences in on-time delivery performance.
- Products contributing to unfulfilled order quantities.

Business recommendations should be based on actual analytical findings. Observed relationships are treated as potential contributing factors, not proven causes.

The recommended insight structure is:

**Observation → Evidence → Business Impact → Potential Contributing Factors → Recommended Action**

## 12. Project Deliverables

| Deliverable | Description |
|---|---|
| Business Requirements Document | BRD Version 3.0 |
| Synthetic Dataset | Historical supply chain dimension and fact tables |
| Data Dictionary | Table structures, fields, grain, and relationships |
| Data Profiling | Excel-based profiling and review |
| SQL Analysis | SQL queries for data analysis and KPI calculations |
| Power BI File | Interactive Power BI report (`.pbix`) |
| Power BI Dashboards | Three business-focused dashboard pages |
| Dashboard Screenshots | PNG previews of the three dashboards |
| Project Documentation | README and implementation documentation |

## 13. Repository Structure

```text
Supply-Chain-Management-Analytics/
│
├── README.md
│
├── Power BI/
│   ├── Supply_Chain_Management_Analytics.pbix
│   └── Dashboard Screenshots/
│       ├── 01_Inventory_Performance.png
│       ├── 02_Supplier_Procurement_Performance.png
│       └── 03_Order_Fulfillment_Delivery.png
│
├── SQL/
│   └── SQL analysis scripts
│
└── Documentation/
    ├── BRD_Version_3.0.md
    ├── Implementation_Guide.md
    └── Data_Dictionary.md
```

*The folder and file names above are the recommended repository organization. Adjust the paths if your actual filenames differ.*

## 14. Project Limitations & Considerations

- The project is based on synthetic historical data, not live company operational data.
- Analysis is limited to the fields, business rules, and historical period defined in the project sources.
- Fact tables have different grains; joins and aggregations must respect those grains to avoid duplicate counting.
- Some data quality issues are intentionally present and require context-aware handling.
- Inventory receipts and purchase order lines cannot be reconciled row-for-row where the required transaction-level relationship is not available.
- Optional KPIs requiring additional thresholds, weights, or business definitions remain outside the implemented KPI scope.
- Findings describe historical patterns and potential contributing factors; they do not establish causation.

## 15. Expected Business Value

This project provides a consolidated analytical view of supply chain operations and helps stakeholders:

- Improve visibility into inventory availability and stockout patterns.
- Identify supplier and procurement performance gaps.
- Monitor customer order fulfillment and delivery efficiency.
- Compare warehouse and regional performance.
- Understand operational trends and exceptions.
- Support evidence-based business discussions and decisions.

## 16. Conclusion

The Supply Chain Management Analytics Project demonstrates an end-to-end business analytics workflow using SQL, Microsoft Power BI, and Excel.

By combining data profiling, SQL-based analysis, KPI development, and interactive dashboards, the project provides insights across inventory performance, supplier and procurement performance, and order fulfillment and delivery performance.

The project follows a Descriptive and Diagnostic Analytics approach, emphasizing business understanding, data quality, analytical accuracy, and practical decision support.

---

### Project Information

| Attribute | Details |
|---|---|
| Project | Supply Chain Management Analytics |
| Analytics Type | Descriptive & Diagnostic Analytics |
| Business Areas | Inventory, Supplier & Procurement, Order Fulfillment & Delivery |
| Historical Period | January 2023 – December 2024 |
| Primary Technologies | SQL, Microsoft Power BI |
| Supporting Technology | Microsoft Excel |
| Documentation Format | Markdown |
