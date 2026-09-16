# Data Quality Assessment

## 1. Purpose

The purpose of this Data Quality Assessment is to evaluate the quality and reliability of the supply chain dataset before SQL analysis and Power BI reporting.

The assessment identifies data quality issues such as missing values, duplicate records, invalid dates, negative quantities, inconsistent names, and invalid or unmatched identifiers.

The identified issues and their treatment decisions are documented to maintain transparency and support reliable downstream analysis.

---

## 2. Scope

The assessment covers the following project tables:

### Dimension Tables
- Dim_Product
- Dim_Warehouse
- Dim_Supplier
- Dim_Customer
- Dim_Date

### Fact Tables
- Fact_Inventory
- Fact_Purchase_Order
- Fact_Customer_Order
- Fact_Delivery
- Fact_Return

The assessment follows the data quality requirements defined in the project BRD and supporting project documentation.

---

## 3. Data Quality Checks Performed

The dataset was reviewed for:

- Missing values
- Duplicate records
- Invalid date logic
- Negative quantities
- Invalid or unmatched identifiers
- Product name consistency
- Supplier name consistency
- Delivery date completeness
- Basic data and relationship integrity
- Table grain and duplicate business records

Excel was used for initial profiling, review, duplicate checks, cleaning, and validation.

SQL validation will be used later for relational integrity and analytical validation.

---

## 4. Data Quality Issue Log

| Table | Data Quality Issue | Source Count | Excel Observed / Cleaned | Treatment | Status |
|---|---|---:|---:|---|---|
| Dim_Product | Inconsistent Product_Name casing/spacing | 3 | 3 | Spacing cleaned; no unsupported casing changes applied | Resolved |
| Dim_Supplier | Inconsistent Supplier_Name casing/spacing | 2 | 2 | Spacing cleaned; no unsupported casing changes applied | Resolved |
| Dim_Customer | Missing Customer_Location | 6 | 6 | Kept blank; no value was inferred | Documented |
| Fact_Inventory | Negative Issued_or_Sold_Quantity | 1,076 | 1,013 | Retained and flagged for investigation | Investigation |
| Fact_Inventory | Missing Received_Quantity | 7,178 | 7,183 | Kept blank; no value was inferred | Documented |
| Fact_Inventory | Exact duplicate records | 717 | 716 removed | Exact duplicate rows removed | Resolved |
| Fact_Inventory | Orphan Product_ID (P9999) | 574 | 574 | Retained and flagged for investigation | Investigation |
| Fact_Purchase_Order | Missing Actual_Delivery_Date for Completed records | 421 | 5,929 | Kept blank; no date was inferred | Revalidation Required |
| Fact_Purchase_Order | Actual_Delivery_Date < Order_Date | 210 | 6,139 | Retained and flagged for investigation | Revalidation Required |
| Fact_Purchase_Order | Negative Received_Quantity | 151 | 151 | Retained and flagged for investigation | Investigation |
| Fact_Purchase_Order | Duplicate PO line records | 151 | 151 removed | Exact duplicate rows removed | Resolved |
| Fact_Customer_Order | Missing Ordered_Quantity | 835 | 835 | Kept blank; no value was inferred | Documented |
| Fact_Customer_Order | Orphan Product_ID (P9999) | 194 | 194 | Retained and flagged for investigation | Investigation |
| Fact_Delivery | Missing Expected_Delivery_Date | 682 | 685 | Kept blank; no date was inferred | Documented |
| Fact_Delivery | Duplicate delivery records | 256 | 256 removed | Exact duplicate rows removed | Resolved |
| Fact_Return | Orphan Order_ID (ORD9999999) | 154 | 154 | Retained and flagged for investigation | Investigation |

---

## 5. Cleaning Treatment Principles

The following principles were followed during data cleaning:

1. Raw data was preserved without modification.

2. Exact duplicate records were removed only when the complete record was duplicated.

3. Missing values were not replaced with guessed, average, mode, or zero values unless an approved business rule existed.

4. Invalid or negative quantities were retained and flagged when no approved correction rule was available.

5. Orphan or unmatched identifiers were retained and flagged rather than deleted or replaced.

6. Product and supplier name spacing inconsistencies were cleaned where the correction was clear.

7. Data quality issues that could not be safely corrected were documented for further investigation.

---

## 6. Data Quality Observations

### 6.1 Dimension Tables

Dim_Product and Dim_Supplier contained minor product/supplier name consistency issues.

Dim_Customer contained missing Customer_Location values.

Dim_Warehouse and Dim_Date did not have a documented cleaning issue requiring modification.

---

### 6.2 Fact_Inventory

Fact_Inventory contained:

- Missing Received_Quantity values
- Negative Issued_or_Sold_Quantity values
- Exact duplicate records
- Orphan Product_ID values

Exact duplicate records were removed.

Missing quantities, negative quantities, and orphan Product_ID values were retained and flagged because no approved correction rule was defined.

---

### 6.3 Fact_Purchase_Order

Fact_Purchase_Order contained:

- Missing Actual_Delivery_Date values for records marked Completed
- Invalid date sequences where Actual_Delivery_Date was earlier than Order_Date
- Negative Received_Quantity values
- Duplicate PO line records

Exact duplicate PO line records were removed.

Missing dates and invalid quantities/date sequences were not artificially corrected and remain documented for investigation.

---

### 6.4 Fact_Customer_Order

Fact_Customer_Order contained:

- Missing Ordered_Quantity values
- Orphan Product_ID values

Missing quantities were retained as blank.

Orphan Product_ID records were retained and flagged for investigation.

---

### 6.5 Fact_Delivery

Fact_Delivery contained:

- Missing Expected_Delivery_Date values
- Duplicate delivery records

Exact duplicate records were removed.

Missing Expected_Delivery_Date values were retained as blank.

---

### 6.6 Fact_Return

Fact_Return contained orphan Order_ID values that could not be matched to Fact_Customer_Order.

These records were retained and flagged for investigation.

---

## 7. Count Discrepancies

Some issue counts observed during Excel validation differ from the counts documented in the project source documentation.

Examples include:

- Fact_Inventory missing Received_Quantity
- Fact_Inventory negative Issued_or_Sold_Quantity
- Fact_Inventory duplicate records
- Fact_Purchase_Order missing Actual_Delivery_Date
- Fact_Purchase_Order invalid date logic
- Fact_Delivery missing Expected_Delivery_Date

These differences were not artificially reconciled.

The Excel observations are recorded as the current working validation results. Further SQL-level validation will be used to confirm the final counts before analytical reporting.

---

## 8. Data Quality Limitations

The following limitations remain relevant to the project:

- Some records contain missing values.
- Some invalid quantities require further investigation.
- Some unmatched identifiers remain in the dataset.
- Some delivery and procurement records contain date-quality issues.
- Fact_Purchase_Order does not contain Warehouse_ID, so purchase-order receiving cannot be directly reconciled to a specific warehouse.
- Root-cause fields are not directly available in the dataset.

These limitations must be considered when calculating KPIs and interpreting analytical results.

---

## 9. Data Quality Status

The dataset has undergone initial Excel-based profiling, validation, and cleaning.

The cleaned dataset is prepared for the next analytical phase, while unresolved data quality issues remain documented and flagged for further SQL-level validation and investigation.

No unsupported values were invented to force data completeness.

---

## 10. Next Phase

The next project phase is:

Data Quality Validation
        ↓
SQL Database Schema
        ↓
SQL Data Quality Checks
        ↓
SQL Analysis
        ↓
KPI Calculation
        ↓
Diagnostic Analysis
        ↓
Power BI Development