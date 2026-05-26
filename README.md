# Gamezone Orders — Data Cleaning Project

## Overview
Data profiling and cleaning project using BigQuery SQL on a gaming e-commerce orders dataset (~22,000 rows).
The company sells new and refurbished gaming products all around the world

## Files
- `01_profiling.sql` — Eyeball and filter: distinct values, data types, null counts, format checks
- `02_cleaning.sql` — Fixes applied via CTEs: date normalization, column standardization, deduplication

## Issues Found
| Column | Issue |
|---|---|
| PURCHASE_TS | Stored as STRING, mixed formats |
| PRODUCT_NAME | Inconsistent naming for same product |
| MARKETING_CHANNEL | NULL and blank coexist |
| ACCOUNT_CREATION_METHOD | NULL and blank coexist |
| ORDER_ID | 145 duplicate IDs with different USER_IDs |
| USD_PRICE | 29 zero-value and 5 NULL rows |
| COUNTRY_CODE | 37 NULL rows |

## Tools
- Google BigQuery (SQL)
- Notion (Issues Log)
