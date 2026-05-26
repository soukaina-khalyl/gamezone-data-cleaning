# Issues log

| # | Column | Issue type | Description | Suggested fix |
| --- | --- | --- | --- | --- |
| 1 | ACCOUNT_CREATION_METHOD | Inconsistent missing value representation | Two representations of missing data: `null` (83) and `unknown` (743) | Unify to a single value (e.g. `unknown`) — pending business clarification |
| 2 | MARKETING_CHANNEL | Inconsistent missing value representation | Same pattern: `null` (83) and `unknown` (47) coexist | Same as above |
| 3 | PURCHASE_TS & SHIP_TS | Different types | represent the same kind of data (timestamps) but are stored as different types. PURCHASE_TS(string) | Once PURCHADR_TS normalized and cast to DATE, both columns will match types |
| 4 | PURCHASE_TS | Wrong data type + Format inconsistency | Stored as STRING instead of DATE. Multiple formats coexist, whitespace, and impossible time values (minutes = 62) in 11 rows | Normalize all valid formats to `YYYY-MM-DD`, cast to DATE |
| 5 | PRODUCT_NAME | Inconsistent naming | Same product appears under two different names. `"27in 4K gaming monitor"` vs `"27inches 4k gaming monitor"` (61 rows) | Standardize to one name “27in 4K gaming monitor” |
| 6 | USD_PRICE | Missing and $0 transactions | 29 rows have a price of `0.0` , 5 rows have NULL price  | Flag for business clarification |
| 7 | COUNTRY_CODE | Missing country_code | 37 rows |  |
| 8 | ORDER_ID | Duplicate key | 145 ORDER_IDs appear twice with different USER_IDs but identical values in all other columns | Flag for engineering. For analysis, deduplicate by keeping one row per ORDER_ID — pending decision on which USER_ID to trust |
