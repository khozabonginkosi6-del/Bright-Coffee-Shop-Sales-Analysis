---#: Preview all data in the table
SELECT
  *
FROM
  "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200";

---#: Add a numeric column for unit_price (to clean up string values like '3,1')
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN unit_price_num NUMBER;

---#: Populate the new numeric column by replacing commas with dots and casting to number
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET unit_price_num = TRY_TO_NUMBER(REPLACE(unit_price, ',', '.'));

---#: Add a new column to store total transaction amount
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN total_amount NUMBER;

---#: Calculate total_amount = unit_price_num * transaction_qty
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET total_amount = unit_price_num * transaction_qty;

---#: Add a timestamp column combining transaction_date + transaction_time
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN transaction_ts TIMESTAMP;

---#: Populate transaction_ts with proper timestamp values
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET transaction_ts = TO_TIMESTAMP_NTZ(transaction_date || ' ' || transaction_time);

---#: Add a column for 30-minute time buckets
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN transaction_time_bucket TIMESTAMP;

---#: Populate time bucket column using TIME_SLICE (30-minute intervals)
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET transaction_time_bucket = TIME_SLICE(transaction_ts, 30, 'MINUTE');

---#: Aggregate results by time bucket, product type, and product detail
-- Metrics: total units sold, total sales, average unit price
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
