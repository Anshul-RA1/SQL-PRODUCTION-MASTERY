# Day 04 — String, Numeric & Date Functions

**Phase:** 1 — Foundations
**Date Completed:**

---

## String Functions Reference

| Function                   | Purpose                  | Example                            |
| -------------------------- | ------------------------ | ---------------------------------- |
| `LENGTH(str)`              | Count characters         | `LENGTH('hello')` → 5              |
| `UPPER(str)`               | To uppercase             | `UPPER('hello')` → `'HELLO'`       |
| `LOWER(str)`               | To lowercase             | `LOWER('HELLO')` → `'hello'`       |
| `TRIM(str)`                | Remove spaces both sides | `TRIM('  hi  ')` → `'hi'`          |
| `REPLACE(str,from,to)`     | Find and replace         | `REPLACE('a-b','-','')` → `'ab'`   |
| `SUBSTRING(str,start,len)` | Extract substring        | `SUBSTRING('hello',1,3)` → `'hel'` |
| `CONCAT(s1,s2,...)`        | Join strings safely      | NULL treated as empty string       |
| `LEFT(str,n)`              | First n chars            | `LEFT('hello',3)` → `'hel'`        |
| `RIGHT(str,n)`             | Last n chars             | `RIGHT('hello',3)` → `'llo'`       |
| `SPLIT_PART(str,del,n)`    | Split by delimiter       | `SPLIT_PART('a@b','@',2)` → `'b'`  |
| `POSITION(sub IN str)`     | Find position            | `POSITION('@' IN 'a@b')` → 2       |

## Numeric Functions Reference

| Function      | Purpose             | Example                 |
| ------------- | ------------------- | ----------------------- |
| `ROUND(n, d)` | Round to d decimals | `ROUND(2.567,2)` → 2.57 |
| `CEIL(n)`     | Round UP always     | `CEIL(2.1)` → 3         |
| `FLOOR(n)`    | Round DOWN always   | `FLOOR(2.9)` → 2        |
| `ABS(n)`      | Absolute value      | `ABS(-5)` → 5           |
| `MOD(a,b)`    | Remainder           | `MOD(10,3)` → 1         |
| `POWER(b,e)`  | Exponent            | `POWER(2,10)` → 1024    |
| `SQRT(n)`     | Square root         | `SQRT(144)` → 12        |

## Date Functions Reference

| Function                 | Purpose                  | Example                         |
| ------------------------ | ------------------------ | ------------------------------- |
| `NOW()`                  | Current timestamp+tz     | `2025-05-18 14:30+05:30`        |
| `CURRENT_DATE`           | Today's date             | `2025-05-18`                    |
| `EXTRACT(field FROM ts)` | Pull one component       | `EXTRACT(YEAR FROM now())`      |
| `DATE_TRUNC(unit, ts)`   | Truncate to period start | `DATE_TRUNC('month', now())`    |
| `TO_CHAR(val, fmt)`      | Format as text           | `TO_CHAR(now(), 'DD Mon YYYY')` |
| `AGE(ts1, ts2)`          | Human readable diff      | `'1 year 3 months'`             |
| `INTERVAL`               | Add/subtract time        | `NOW() + INTERVAL '7 days'`     |

## Critical Rules

- `CONCAT()` treats NULL as empty string — safer than `||`
- `||` with any NULL input → entire result is NULL
- `DATE_TRUNC` returns TIMESTAMPTZ, not DATE — cast if needed
- `EXTRACT` returns DOUBLE PRECISION — safe for math
- `TO_CHAR` format: `FM` prefix removes padding/spaces
- Always `ROUND()` money — never show raw float results

## EDA Queries Built

1. Product catalog enrichment — display card with GST + discount %
2. User communication audit — email parsing + account age + last seen
3. Monthly revenue timeline — date formatting + days ago + age flag

## Day 04 — String, Numeric & Date Functions

### CONCAT vs || for NULL handling

```sql
-- User with NULL last_name:
CONCAT('Fatima', ' ', NULL)     → 'Fatima '   ✅ safe
'Fatima' || ' ' || NULL         → NULL         ❌ poisoned
-- Always use CONCAT() when any column might be NULL
```

### DATE_TRUNC — the analytics workhorse

```sql
DATE_TRUNC('month', ordered_at)
-- Groups ALL timestamps in Dec 2024 → '2024-12-01 00:00:00'
-- Essential for monthly/yearly grouping in reports
```

### Boolean expression in SELECT

```sql
(CURRENT_DATE - ordered_at::DATE) > 180   AS older_than_180_days
-- Returns TRUE or FALSE per row — no CASE needed
-- Powerful pattern for creating flag columns
```

### TO_CHAR format codes

```
'DD Mon YYYY'    → '01 Dec 2024'
'FMMonth YYYY'   → 'December 2024'  (FM removes padding)
'HH24:MI:SS'     → '14:30:00'
'FM₹999,999,990.00' → '₹2,499.00'
```
