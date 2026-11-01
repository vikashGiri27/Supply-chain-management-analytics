# Supply Chain Management Analytics Project

## Supply Chain Management Analytics | SQL | Power BI | Excel

## 1. Project Overview

The **Supply Chain Management Analytics Project** is a Descriptive and Diagnostic Analytics project designed to analyze historical supply chain operations and identify performance gaps, operational trends, variations, and potential contributing factors.

The project focuses on three major business areas:

1. Inventory Imbalance
2. Supplier & Procurement Performance
3. Order Fulfillment & Delivery Performance

The objective is to transform raw operational data into meaningful business insights using SQL analysis and interactive Power BI dashboards.

---

## 2. Business Objectives

- Analyze inventory levels and identify stockout patterns across products and warehouses.
- Evaluate supplier reliability and procurement performance.
- Monitor purchase order fulfillment, delivery delays, and procurement lead time.
- Analyze customer order fulfillment and delivery performance.
- Identify operational trends, exceptions, and potential contributing factors.
- Develop business-focused KPIs and interactive dashboards to support data-driven decisions.

---

## 3. Project Scope

### In Scope

- Historical supply chain data analysis
- Inventory performance analysis
- Warehouse performance analysis
- Supplier performance analysis
- Procurement and purchase order analysis
- Customer order fulfillment analysis
- Delivery performance analysis
- KPI development and reporting
- Data quality assessment
- Root-cause investigation using historical data
- SQL analysis and Power BI dashboards
- Excel-based profiling and validation

### Out of Scope

- Demand forecasting
- Machine learning
- Predictive analytics
- Real-time data streaming
- ERP implementation
- Transportation route optimization
- Automated operational decision systems

---

## 4. Dataset Description

The project uses a synthetic historical supply chain dataset designed to represent realistic operational variations and business scenarios.

**Historical Period:** January 2023 – December 2024

### Dimension Tables

| Table | Description |
|---|---|
| Dim_Product | Product master information |
| Dim_Warehouse | Warehouse details and capacity |
| Dim_Supplier | Supplier master information |
| Dim_Customer | Customer information |
| Dim_Date | Calendar and date attributes |

### Fact Tables

| Table | Description |
|---|---|
| Fact_Inventory | Daily inventory snapshots |
| Fact_Purchase_Order | Purchase order and procurement transactions |
| Fact_Customer_Order | Customer order line transactions |
| Fact_Delivery | Shipment and delivery information |
| Fact_Return | Customer return records |

The dataset contains realistic variations in product demand, inventory movement, supplier reliability, procurement lead time, warehouse performance, and delivery outcomes.

---

## 5. Tools & Technologies

| Tool | Purpose |
|---|---|
| MySQL-compatible SQL | Data cleaning, joins, aggregations, KPI calculations, and business analysis |
| Microsoft Power BI | Data modeling, DAX measures, KPI cards, and interactive dashboards |
| Microsoft Excel | Data profiling, validation, reconciliation, and exploratory review |
| Git & GitHub | Version control and project documentation |
| VS Code | SQL and Markdown editing |

**Primary Technologies:** SQL and Power BI.

---

## 6. Project Methodology

The project follows a structured analytics workflow:

1. **Business Understanding:** Reviewed the Business Requirements Document (BRD) and identified business problems, objectives, KPIs, and scope.
2. **Data Understanding:** Reviewed the data dictionary, table structures, columns, and business grain.
3. **Data Profiling:** Used Excel to inspect row counts, data types, missing values, duplicates, invalid values, and key uniqueness.
4. **Data Quality Assessment:** Identified missing values, duplicate records, inconsistent values, invalid quantities, and orphan keys.
5. **SQL Analysis:** Used SQL queries for data validation, joins, aggregations, KPI calculations, and business-question analysis.
6. **Data Modeling:** Organized the analytical data model around dimension and fact tables.
7. **Power BI Development:** Created DAX measures, KPI cards, slicers, and business-focused visualizations.
8. **Business Insights:** Used trends, comparisons, rankings, and segmentation to identify performance gaps and potential contributing factors.

---

## 7. SQL Analysis

SQL was used as the primary analytical technology to investigate business questions across the three focus areas.

### Inventory Analysis

- Total inventory quantity and inventory value.
- Stockout frequency and stockout rate.
- Product-wise and warehouse-wise inventory performance.
- Inventory movement and historical trends.
- Identification of products with frequent stockout issues.

### Supplier & Procurement Analysis

- Total purchase orders.
- Supplier-wise purchase order performance.
- On-time and late delivery analysis.
- Average procurement lead time.
- Purchase order fulfillment and quantity shortfall analysis.
- Identification of suppliers with delivery delays.

### Order Fulfillment & Delivery Analysis

- Total customer orders.
- Order fulfillment rate.
- On-time and late delivery rates.
- Average order cycle time.
- Warehouse-wise fulfillment performance.
- Regional delivery performance.
- Identification of products with high unfulfilled order quantities.

---

## 8. Power BI Dashboards

Three interactive dashboards were developed based on the project requirements.

### Dashboard 1: Inventory Performance

**Objective:** Monitor inventory availability, stock levels, and warehouse performance.

Key KPIs:
- Total Inventory Quantity
- Inventory Value
- Stockout Rate
- Stockout Rows

Key Analysis:
- Monthly inventory trend
- Warehouse-wise inventory comparison
- Product and warehouse inventory distribution
- Product category contribution
- Top stockout products

### Dashboard 2: Supplier & Procurement Performance

**Objective:** Evaluate supplier reliability and procurement efficiency.

Key KPIs:
- Total Purchase Orders
- On-Time Delivery Rate
- Late Delivery Rate
- Average Procurement Lead Time
- Purchase Order Fulfillment Rate

Key Analysis:
- Procurement lead time trend
- Supplier-wise purchase order comparison
- Delayed purchase order analysis
- Monthly supplier delivery performance
- Ordered versus received quantity
- Purchase order quantity shortfall

### Dashboard 3: Order Fulfillment & Delivery Performance

**Objective:** Monitor customer order fulfillment and delivery performance.

Key KPIs:
- Total Orders
- Order Fulfillment Rate
- On-Time Delivery Rate
- Late Delivery Rate
- Average Order Cycle Time

Key Analysis:
- Monthly order fulfillment trend
- On-time versus late delivery comparison
- Bottom-performing warehouses by fulfillment rate
- Top products by unfulfilled order quantity
- Regional delivery performance
- Monthly average order cycle time

### Dashboard Interactivity

The dashboards include interactive filters such as:
- Date / Month-Year
- Warehouse
- Product
- Product Category
- Order Status, where applicable

Visuals include trend charts, clustered and stacked column charts, horizontal bar charts, and KPI cards to support different types of business analysis.

---

## 9. Data Quality Considerations

The dataset includes documented data quality scenarios to support realistic validation and analytical practice.

Examples include:

- Missing values in selected columns.
- Duplicate records in selected fact tables.
- Orphan foreign keys.
- Negative or invalid quantity values.
- Inconsistent text formatting.
- Invalid date combinations.

These issues were considered during data profiling and validation.

**Important:** Missing actual delivery dates for open or in-transit records can represent a valid business state. They should not automatically be classified as data quality errors.

Data quality issues must be evaluated according to the relevant business context and record status.

---

## 10. Business Insights & Recommendations

The dashboards support business users in identifying:

- Products and warehouses experiencing frequent stockouts.
- Inventory distribution differences across warehouses.
- Suppliers with comparatively higher delivery delays.
- Procurement lead time variations.
- Purchase orders with quantity shortfalls.
- Warehouses with comparatively lower order fulfillment rates.
- Regional differences in on-time delivery performance.
- Products contributing to unfulfilled order quantities.

Recommendations should be based on actual analytical findings, not assumptions. Observed relationships are treated as potential contributing factors rather than proven causes.

---

## 11. Expected Business Value

The project provides an analytical view of supply chain operations and helps stakeholders:

- Improve visibility into inventory performance.
- Identify supplier and procurement performance gaps.
- Monitor order fulfillment and delivery efficiency.
- Understand operational trends and exceptions.
- Support evidence-based business discussions and decisions.

---

## 12. Project Documentation

The project documentation is based on the following source materials:

- **Supply Chain Management Analytics BRD Version 3.0:** Business requirements, scope, business problems, KPI definitions, and dashboard requirements.
- **Implementation Guide:** Data understanding, business questions, SQL analysis approach, and Power BI implementation guidance.
- **README / Data Dictionary:** Table structures, column definitions, table grain, relationship mapping, data quality scenarios, and dataset validation details.

---

## 13. Conclusion

This project demonstrates an end-to-end Supply Chain Management Analytics workflow using Excel, SQL, and Power BI.

It converts historical operational data into structured analysis, business KPIs, and interactive dashboards across inventory management, supplier and procurement performance, and order fulfillment and delivery.

The project follows a Descriptive and Diagnostic Analytics approach, with a focus on data quality, business understanding, analytical accuracy, and practical business insights.

---

**Project Category:** Supply Chain Management Analytics  
**Analytics Type:** Descriptive & Diagnostic Analytics  
**Primary Tools:** SQL, Microsoft Power BI  
**Supporting Tool:** Microsoft Excel  
**Documentation:** Markdown (README.md)