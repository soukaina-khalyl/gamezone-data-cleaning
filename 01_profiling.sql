/*
===================================================================================
  GAMEZONE ORDERS — DATA PROFILING & QUALITY CHECKS
  Step 1: Eyeball & Filter
===================================================================================
  Purpose:
    This script performs the first step of the data cleaning process for the
    gamezone_orders table. The goal is to profile each column by inspecting
    distinct values, data types, formats, and null counts to surface any
    inconsistencies before applying any fixes.
 
  Findings are documented separately in the Issues Log (Notion).
  No data is modified in this script.
===================================================================================
*/



-- =======================================================================
-- SECTION 1: CATEGORICAL COLUMNS
-- Check distinct values and their frequency to spot naming inconsistencies,
-- unexpected values, or multiple representations of missing data.
-- =======================================================================

-- 1.1 Purchase Platform
SELECT PURCHASE_PLATFORM, COUNT(*) AS row_count
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
GROUP BY PURCHASE_PLATFORM
ORDER BY row_count DESC;

-- 1.2 Marketing Channel
SELECT MARKETING_CHANNEL, COUNT(*) AS row_count
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
GROUP BY MARKETING_CHANNEL
ORDER BY row_count DESC;

-- 1.3 Account Creation Method
SELECT ACCOUNT_CREATION_METHOD, COUNT(*) AS row_count
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
GROUP BY ACCOUNT_CREATION_METHOD
ORDER BY row_count DESC;

-- 1.4 Product Name
SELECT PRODUCT_NAME, COUNT(*) AS count_row
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
GROUP BY PRODUCT_NAME 
ORDER BY count_row DESC;

-- =======================================================================
-- SECTION 2: DATA TYPES
-- Confirm that each column is stored as the expected type.
-- =======================================================================


SELECT column_name, data_type
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'gamezone_orders';

-- =======================================================================
-- SECTION 3: DATE & TIMESTAMP COLUMNS
-- PURCHASE_TS is stored as STRING — check for format inconsistencies,
-- whitespace, and impossible time values.
-- SHIP_TS is stored as DATE — check for NULLs only
-- =======================================================================

-- 3.1 Identify PURCHASE_TS values that do not follow the expected MM/DD/YYYY format
SELECT PURCHASE_TS, COUNT(*) AS row_count
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
WHERE NOT REGEXP_CONTAINS(PURCHASE_TS, r'^\d{2}/\d{2}/\d{4}$')
GROUP BY PURCHASE_TS;

-- 3.2 Check for NULL values in SHIP_TS
SELECT COUNT(*) AS row_count
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
WHERE SHIP_TS IS NULL;

-- =======================================================================
-- SECTION 4: NUMERIC COLUMNS
-- Check USD_PRICE for NULL values and zero-value transaction
-- =======================================================================

SELECT USD_PRICE, COUNT(*) AS row_count
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
GROUP BY USD_PRICE
HAVING USD_PRICE IS NULL OR USD_PRICE <= 0
ORDER BY row_count DESC;

-- =======================================================================
-- SECTION 5: GEOGRAPHIC COLUMNS
-- Check COUNTRY_CODE for NULL values.
-- =======================================================================

SELECT COUNT(*) AS null_country_code_count
FROM `project-a3965084-9ca1-4883-a5b`.`sql_practice`.`gamezone_orders`
WHERE COUNTRY_CODE IS NULL;

-- =======================================================================
-- SECTION 6: DUPLICATE CHECK
-- Check for duplicate ORDER_IDs which should be unique per transaction
-- =======================================================================

SELECT ORDER_ID, COUNT(*) AS row_count
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
GROUP BY ORDER_ID
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

SELECT *
FROM `project-a3965084-9ca1-4883-a5b.sql_practice.gamezone_orders`
WHERE ORDER_ID = 'fc07b9ccf6242020';



