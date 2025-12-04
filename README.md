# ☕ Coffee Shop Transaction Analysis

## 📌 Summary of the Case Study
This case study demonstrates how SQL queries can be applied to **clean, transform, and analyze transaction data** stored in the Snowflake table `MYDATA_COFFEE_SHOP.PUBLIC.ANALYSIS200`. The project focused on preparing raw transaction records for reporting by cleaning unit price values, calculating transaction totals, creating timestamps and time buckets, and aggregating sales metrics. The goal was to deliver **actionable insights** into sales performance, product trends, and customer behavior.

---

## 🔍 How the Case Study Was Done
1. **Data Preview**
   - Retrieved all records using `SELECT *` to understand the raw structure of the dataset.

2. **Data Cleaning**
   - Added a numeric column `unit_price_num` to store cleaned unit price values.  
   - Replaced commas with dots and cast values to numbers using `TRY_TO_NUMBER(REPLACE(...))`.

3. **Transaction Amount Calculation**
   - Added a new column `total_amount`.  
   - Populated with the formula: `unit_price_num * transaction_qty`.

4. **Timestamp Creation**
   - Added a column `transaction_ts`.  
   - Combined transaction date and time into a proper timestamp using `TO_TIMESTAMP_NTZ`.

5. **Time Bucketing**
   - Added a column `transaction_time_bucket`.  
   - Grouped transactions into 30-minute intervals using `TIME_SLICE`.

6. **Aggregations**
   - Generated metrics grouped by time bucket, product type, and product detail:  
     - `SUM(transaction_qty)` → Total Units Sold  
     - `SUM(unit_price_num * transaction_qty)` → Total Sales  
     - `AVG(unit_price_num)` → Average Unit Price  
   - Ordered results by time bucket and total sales for reporting clarity.

---

## 📊 Insights Found
- Cleaning unit price values ensured **accurate calculations** for transaction totals.  
- Transaction timestamps allowed grouping into **30-minute buckets**, revealing peak sales periods.  
- Aggregated metrics highlighted:  
  - **Top-selling products** by type and detail.  
  - **Revenue drivers** across different time intervals.  
  - **Average pricing trends**, useful for monitoring consistency and promotions.  
- The workflow transformed raw transactional data into **structured insights** ready for dashboards and BI tools.  

---

## 🎯 Summary of Findings
By applying SQL transformations and aggregations, the project uncovered:  
- **Sales performance trends** across time intervals.  
- **Product-level insights** into units sold, revenue, and pricing.  
- A reproducible workflow for cleaning and preparing transactional data.  

This demonstrates how SQL can be leveraged to deliver **business intelligence** that supports **sales reporting, inventory management, and operational decision-making** in a retail coffee shop environment.

---

## 🛠️ Tools Used
- **Snowflake Database** → Data storage and query execution.  
- **SQL functions** → `ALTER TABLE`, `UPDATE`, `SELECT`, `SUM`, `AVG`, `TIME_SLICE`, `CASE`, `GROUP BY`, `ORDER BY`.  
- **Execution Environments** → Snowflake Worksheet, Python connector, or BI tools (e.g., Power BI, Looker Studio).  

