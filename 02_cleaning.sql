/*
===================================================================================
  GAMEZONE ORDERS — DATA CLEANING
  Step 2: Standardize & Fix
===================================================================================
  Purpose:
    This script applies fixes to the issues identified in the profiling script
    (gamezone_profiling.sql).

  Fixes applied:
    - PURCHASE_TS: normalized to YYYY-MM-DD and cast to DATE
    - PRODUCT_NAME: standardized inconsistent monitor name
    - MARKETING_CHANNEL: unified NULL and blank values to 'unknown'
    - ACCOUNT_CREATION_METHOD: unified NULL and blank values to 'unknown'
    - STRING_FIELD_12 / STRING_FIELD_13: empty columns dropped from output
    - ORDER_ID: 145 duplicates flagged, deduplication in Step 3 (commented out)

===================================================================================
*/

-- Step 1: clean PURCHASE_TS
WITH purchase_ts_cleaned AS (
  SELECT *,
    CASE WHEN REGEXP_CONTAINS(PURCHASE_TS, r'^\d{2}/\d{2}/\d{4}$')
          THEN SAFE.PARSE_DATE('%m/%d/%Y', PURCHASE_TS)
        ELSE SAFE.PARSE_DATE('%m/%d/%Y', REPLACE(SUBSTR(PURCHASE_TS, 1, 10), '-', '/'))
    END AS purchase_date_cleaned 
  FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
),

-- Step 2: fix PRODUCT_NAME + ACCOUNT_CREATION_METHOD + MARKETING_CHANNEL
cleaned_columns AS(
  SELECT *,
    CASE WHEN PRODUCT_NAME = '27inches 4k gaming monitor'
         THEN '27in 4K gaming monitor'
    ELSE PRODUCT_NAME 
    END AS cleaned_product_name,

    CASE
      WHEN TRIM(MARKETING_CHANNEL) = '' OR MARKETING_CHANNEL IS NULL THEN 'unknown'
      ELSE MARKETING_CHANNEL
    END AS cleaned_marketing_channel,

    CASE
      WHEN TRIM(ACCOUNT_CREATION_METHOD) = '' OR ACCOUNT_CREATION_METHOD IS NULL THEN 'unknown'
      ELSE ACCOUNT_CREATION_METHOD
    END AS cleaned_account_creation
  FROM purchase_ts_cleaned
)

-- Step 3: deduplicate ORDER_ID
-- NOTE: 145 duplicate ORDER_IDs found with different USER_IDs.
-- Deduplication strategy pending business clarification on which USER_ID to trust.
-- Uncomment when ready to apply.

-- , deduplicated AS (
--   SELECT *
--   FROM (
--     SELECT *,
--       ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY USER_ID) AS row_num
--     FROM cleaned_columns
--   )
--   WHERE row_num = 1
-- )

SELECT
  USER_ID,
  ORDER_ID,
  purchase_date_cleaned AS PURCHASE_TS,
  SHIP_TS,
  REFUND_TS,
  cleaned_product_name AS PRODUCT_NAME,
  PRODUCT_ID,
  USD_PRICE,
  PURCHASE_PLATFORM,
  cleaned_marketing_channel AS MARKETING_CHANNEL,
  cleaned_account_creation AS ACCOUNT_CREATION_METHOD,
  COUNTRY_CODE
FROM cleaned_columns

