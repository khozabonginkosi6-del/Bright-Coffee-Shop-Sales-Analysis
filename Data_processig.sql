---#: Preview all data in the table
SELECT
  *
FROM
  "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200";

-- Add a new numeric column for unit_price
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN unit_price_num NUMBER;

-- Populate the numeric column by replacing commas with dots and casting to number
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET unit_price_num = TRY_TO_NUMBER(REPLACE(unit_price, ',', '.'));

-- Add a new timestamp column
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN transaction_ts TIMESTAMP;

-- Populate with combined date + time
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET transaction_ts = TO_TIMESTAMP_NTZ(transaction_date || ' ' || transaction_time);

-- Add a new column for time buckets
ALTER TABLE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
ADD COLUMN transaction_time_bucket TIMESTAMP;

-- Populate with 30-minute buckets
UPDATE "MYDATA_COFFEE_SHOP"."PUBLIC"."ANALYSIS200"
SET transaction_time_bucket = TIME_SLICE(transaction_ts, 30, 'MINUTE');
