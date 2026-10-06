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
- Date-dimension coverage for fact-table date fields

Excel was used for initial profiling, review, duplicate checks, cleaning, and validation.

SQL validation is being used for relational integrity and analytical validation.

---

## 4. Data Quality Issue Log

| Table | Data Quality Issue | Source Count | Excel / SQL Observed | Treatment | Status |
|---|---|---:|---:|---|---|
| Dim_Product | Inconsistent Product_Name casing/spacing | 3 | 3 | Spacing cleaned; no unsupported casing changes applied | Resolved |
| Dim_Supplier | Inconsistent Supplier_Name casing/spacing | 2 | 2 | Spacing cleaned; no unsupported casing changes applied | Resolved |
| Dim_Customer | Missing Customer_Location | 6 | 6 | Kept blank; no value was inferred | Documented |
| Fact_Inventory | Negative Issued_or_Sold_Quantity | 1,076 | 1,011 (latest SQL) | Retained and flagged for investigation; source/earlier observed counts differ and are documented | Investigation |
| Fact_Inventory | Missing Received_Quantity | 7,178 | 7,178 (latest SQL) | Kept blank; no value was inferred | Documented |
| Fact_Inventory | Exact duplicate records | 717 | 716 removed | Exact duplicate rows removed | Resolved |
| Fact_Inventory | Orphan Product_ID (P9999) | 574 | 574 | Retained and flagged for investigation | Investigation |
| Fact_Purchase_Order | Missing Actual_Delivery_Date for Completed records | 421 | 0 (latest SQL) | No Completed records currently missing Actual_Delivery_Date | Resolved / Revalidated |
| Fact_Purchase_Order | Actual_Delivery_Date < Order_Date | 210 | 210 (latest SQL) | Retained and flagged for investigation; invalid date sequence remains | Investigation |
| Fact_Purchase_Order | Negative Received_Quantity | 151 | 151 | Retained and flagged for investigation | Investigation |
| Fact_Purchase_Order | Duplicate PO line records | 151 | 151 removed | Exact duplicate PO line records removed | Resolved |
| Fact_Purchase_Order | Dim_Date coverage — Expected_Delivery_Date | 1,080 rows / 22 dates | SQL validation: 0 missing after extension to 2025-01-22 | Dim_Date extended; fact data not modified | Resolved |
| Fact_Purchase_Order | Dim_Date coverage — Actual_Delivery_Date | 103 rows / 15 distinct dates | 0 unmatched dates (latest SQL) | Dim_Date extended through 2025-03-24; fact data not modified | Resolved / Revalidated |
| Fact_Customer_Order | Missing Ordered_Quantity | 835 | 835 | Kept blank; no value was inferred | Documented |
| Fact_Customer_Order | Orphan Product_ID (P9999) | 194 | 194 | Retained and flagged for investigation | Investigation |
| Fact_Delivery | Missing Expected_Delivery_Date | 682 | 682 (latest SQL) | Kept blank; no value was inferred | Documented |
| Fact_Delivery | Duplicate delivery records | 256 | 256 removed | Exact duplicate records removed | Resolved |
| Fact_Return | Orphan Order_ID (ORD9999999) | 154 | 154 | Retained and flagged for investigation | Investigation |

---

## 5. Date Dimension Coverage Adjustment

The project source documents define the generated historical dataset as 2023-01-01 to 2024-12-31. During SQL relationship validation, `Fact_Purchase_Order` was found to contain additional delivery-date values in 2025.

### Expected_Delivery_Date

`Fact_Purchase_Order.Expected_Delivery_Date` contained:

- 1,080 affected records
- 22 distinct dates
- Date range: 2025-01-01 to 2025-01-22

These dates were retained because they exist in the fact data. `Dim_Date` was extended through 2025-01-22 so the date relationship could be validated.

After the extension, the missing-date validation returned 0 unmatched dates.

### Actual_Delivery_Date

`Fact_Purchase_Order.Actual_Delivery_Date` contains:

- 103 affected records
- 15 distinct dates
- Date range: 2025-01-23 to 2025-03-24

The `Dim_Date` table has now been extended in one consolidated step through **2025-03-24**.

The consolidated 2025 extension covers:

> **2025-01-01 through 2025-03-24 inclusive — 83 dates**

The previously added `2025-01-01` through `2025-01-22` dates remain valid and were not duplicated.

This is a **Dim_Date coverage/model adjustment**, not source-data cleaning. No `Fact_Purchase_Order` date values are being changed, deleted, or inferred.

The `Fact_Purchase_Order.Actual_Delivery_Date` coverage validation was executed after the consolidated extension and returned **0 unmatched dates**.

### Important distinction

The source README describes the generated historical dataset as 2023-01-01 to 2024-12-31. The SQL model now requires additional calendar coverage because the loaded `Fact_Purchase_Order` contains 2025 delivery dates. This implementation adjustment does not change the original source-data description.

---

## 6. SQL Revalidation Results

The final SQL revalidation queries were executed after the relationship setup and Dim_Date extension. The executed results are recorded below.

| Validation | Latest SQL Result | Status |
|---|---:|---|
| Completed PO records missing `Actual_Delivery_Date` | 0 | PASS |
| PO `Actual_Delivery_Date < Order_Date` | 210 | Investigation |
| PO `Expected_Delivery_Date` → `Dim_Date` unmatched | 0 | PASS |
| PO `Actual_Delivery_Date` → `Dim_Date` unmatched | 0 | PASS |
| `Dim_Date` coverage | 2023-01-01 to 2025-03-24; 814 rows | PASS |
| Inventory → `Dim_Date` unmatched | 0 | PASS |
| PO `Order_Date` → `Dim_Date` unmatched | 0 | PASS |
| Customer Order `Order_Date` → `Dim_Date` unmatched | 0 | PASS |
| Delivery `Shipment_Date` → `Dim_Date` unmatched | 0 | PASS |
| Delivery `Expected_Delivery_Date` → `Dim_Date` unmatched | 0 | PASS |
| Delivery `Actual_Delivery_Date` → `Dim_Date` unmatched | 0 | PASS |
| Return `Return_Date` → `Dim_Date` unmatched | 0 | PASS |
| Delivery `Order_ID` → Customer Order logical match | 0 unmatched | PASS |
| Return `Order_ID` → Customer Order logical match | 154 unmatched | Investigation |
| Inventory negative `Issued_or_Sold_Quantity` | 1,011 | Investigation |
| Inventory missing `Received_Quantity` | 7,178 | Documented |
| PO negative `Received_Quantity` | 151 | Investigation |
| Customer Order missing `Ordered_Quantity` | 835 | Documented |
| Delivery missing `Expected_Delivery_Date` | 682 | Documented |

**Important:** SQL validation being complete does not mean every data-quality issue is zero. Residual issues are intentionally retained and documented where the project has no approved correction rule.

## 6. Cleaning Treatment Principles

The following principles were followed during data cleaning:

1. Raw data was preserved without modification.
2. Exact duplicate records were removed only when the complete record was duplicated.
3. Missing values were not replaced with guessed, average, mode, or zero values unless an approved business rule existed.
4. Invalid or negative quantities were retained and flagged when no approved correction rule was available.
5. Orphan or unmatched identifiers were retained and flagged rather than deleted or replaced.
6. Product and supplier name spacing inconsistencies were cleaned where the correction was clear.
7. Data quality issues that could not be safely corrected were documented for further investigation.
8. Date-dimension extensions were treated separately from fact-data cleaning; dates were added to `Dim_Date` only to provide calendar coverage for existing fact records.

---

## 7. Data Quality Observations

### 7.1 Dimension Tables

Dim_Product and Dim_Supplier contained minor product/supplier name consistency issues.

Dim_Customer contained missing Customer_Location values.

Dim_Warehouse did not have a documented cleaning issue requiring modification.

Dim_Date required a **coverage adjustment** during SQL relationship validation because Fact_Purchase_Order contained 2025 delivery dates.

### 7.2 Fact_Inventory

Fact_Inventory contained:

- Missing Received_Quantity values
- Negative Issued_or_Sold_Quantity values
- Exact duplicate records
- Orphan Product_ID values

Exact duplicate records were removed.

Missing quantities, negative quantities, and orphan Product_ID values were retained and flagged because no approved correction rule was defined.

### 7.3 Fact_Purchase_Order

Fact_Purchase_Order contained:

- Missing Actual_Delivery_Date values for records marked Completed
- Invalid date sequences where Actual_Delivery_Date was earlier than Order_Date
- Negative Received_Quantity values
- Duplicate PO line records
- 2025 Expected_Delivery_Date and Actual_Delivery_Date values requiring extended Dim_Date coverage

Exact duplicate PO line records were removed.

Missing dates and invalid quantities/date sequences were not artificially corrected and remain documented for investigation.

The 2025 delivery dates were not modified. Only the calendar dimension is being extended to support the required analytical relationship.

### 7.4 Fact_Customer_Order

Fact_Customer_Order contained:

- Missing Ordered_Quantity values
- Orphan Product_ID values

Missing quantities were retained as blank.

Orphan Product_ID records were retained and flagged for investigation.

### 7.5 Fact_Delivery

Fact_Delivery contained:

- Missing Expected_Delivery_Date values
- Duplicate delivery records

Exact duplicate records were removed.

Missing Expected_Delivery_Date values were retained as blank.

### 7.6 Fact_Return

Fact_Return contained orphan Order_ID values that could not be matched to Fact_Customer_Order.

These records were retained and flagged for investigation.

---

## 8. Count Discrepancies

Some issue counts observed during Excel validation differ from the counts documented in the project source documentation.

Examples include:

- Fact_Inventory missing Received_Quantity
- Fact_Inventory negative Issued_or_Sold_Quantity
- Fact_Inventory duplicate records
- Fact_Purchase_Order missing Actual_Delivery_Date
- Fact_Purchase_Order invalid date logic
- Fact_Delivery missing Expected_Delivery_Date

These differences were not artificially reconciled.

The Excel observations are recorded as the current working validation results. SQL-level validation is being used to confirm relational integrity and final analytical counts.

---

## 9. Data Quality Limitations

The following limitations remain relevant to the project:

- Some records contain missing values.
- Some invalid quantities require further investigation.
- Some unmatched identifiers remain in the dataset.
- Some delivery and procurement records contain date-quality issues.
- Fact_Purchase_Order does not contain Warehouse_ID, so purchase-order receiving cannot be directly reconciled to a specific warehouse.
- Root-cause fields are not directly available in the dataset.
- The source documentation states a 2023-01-01 to 2024-12-31 historical range, while loaded purchase-order delivery dates require Dim_Date coverage through 2025-03-24.

These limitations must be considered when calculating KPIs and interpreting analytical results.

---

## 10. Data Quality Status

The dataset has undergone initial Excel-based profiling, validation, and cleaning.

SQL relationship validation and final SQL data-quality revalidation have been completed for the documented model relationships and date coverage checks.

The 2025 dates are being handled by extending the calendar dimension rather than modifying fact records.

No unsupported fact values were invented to force data completeness.

**Final DQ phase status:** Validation is complete, with residual documented/investigation issues remaining. These issues are not silently corrected or deleted because no approved business correction rule is defined in the project source.

---

## 11. Next Phase

The following phases are now complete:

Data Quality Validation
        ↓
SQL Database Schema
        ↓
SQL Relationship Validation
        ↓
SQL Data Quality Checks

### Next project phase

**SQL Data Analysis**

Approved analysis sequence:

1. Inventory Analysis
2. Supplier & Procurement Analysis
3. Order Fulfillment Analysis
4. Delivery Analysis
5. Diagnostic Analysis
6. KPI Validation
7. Power BI Data Model
8. DAX Measures
9. Dashboard Development
10. SQL vs Power BI Validation
11. Business Insights
12. Business Recommendations

No additional relationship is currently required by the BRD, Data Dictionary, or Implementation Guide relationship mapping. The current model is covered by the implemented physical relationships plus the documented logical relationships where physical FK constraints are inappropriate because of orphan keys or non-unique `Order_ID` grain.
