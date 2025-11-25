☕ Coffee Shop Transaction Analysis
📌 Overview
This project focuses on cleaning, transforming, and analyzing transaction data stored in the Snowflake table:

Code
MYDATA_COFFEE_SHOP.PUBLIC.ANALYSIS200
The workflow includes:

Data preview

Cleaning unit price values

Calculating transaction totals

Creating timestamps and time buckets

Aggregating sales metrics for reporting

🛠️ Requirements
Snowflake Database with access to schema MYDATA_COFFEE_SHOP.PUBLIC

SQL execution environment (Snowflake Worksheet, Python connector, or BI tool)

Proper permissions to ALTER TABLE, UPDATE, and SELECT

📂 Steps
1. Preview Data
sql
SELECT * 
FROM "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200";
This retrieves all records to understand the raw structure.

2. Clean Unit Price
Add a numeric column for unit price:

sql
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN unit_price_num NUMBER;
Populate with cleaned values (replace commas with dots, cast to number):

sql
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET unit_price_num = TRY_TO_NUMBER(REPLACE(unit_price, ',', '.'));
3. Calculate Transaction Amount
Add a new column:

sql
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN total_amount NUMBER;
Populate with calculation:

sql
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET total_amount = unit_price_num * transaction_qty;
4. Create Transaction Timestamp
Add timestamp column:

sql
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN transaction_ts TIMESTAMP;
Populate with combined date + time:

sql
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET transaction_ts = TO_TIMESTAMP_NTZ(transaction_date || ' ' || transaction_time);
5. Create 30-Minute Time Buckets
Add bucket column:

sql
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN transaction_time_bucket TIMESTAMP;
Populate using TIME_SLICE:

sql
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET transaction_time_bucket = TIME_SLICE(transaction_ts, 30, 'MINUTE');
6. Aggregate Results
Generate metrics by time bucket, product type, and product detail:

sql
SELECT
  transaction_time_bucket,
  product_type,
  product_detail,
  SUM(transaction_qty) AS total_units,
  SUM(unit_price_num * transaction_qty) AS total_sales,
  AVG(unit_price_num) AS avg_price
FROM "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
GROUP BY transaction_time_bucket, product_type, product_detail
ORDER BY transaction_time_bucket, total_sales DESC;
📊 Metrics Produced
Total Units Sold → SUM(transaction_qty)

Total Sales → SUM(unit_price_num * transaction_qty)

Average Unit Price → AVG(unit_price_num)

Time Buckets → Transactions grouped into 30-minute intervals
