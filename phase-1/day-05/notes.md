# Day 05 — NULL Handling: IS NULL, COALESCE, NULLIF & CASE

**Phase:** 1 — Foundations
**Date Completed:** _fill in_

---

## What NULL Actually Is

```
NULL ≠ 0        (zero is a known value)
NULL ≠ ''       (empty string is a known value)
NULL ≠ FALSE    (false is a known value)
NULL = unknown / not applicable / missing
```

NULL arithmetic: any operation involving NULL returns NULL
NULL comparison: NULL = NULL returns NULL (not TRUE)
Always use IS NULL / IS NOT NULL — never = NULL

---

## Functions Reference

### COALESCE

```sql
COALESCE(val1, val2, val3, ...)
-- Returns first non-NULL value
-- Returns NULL only if ALL args are NULL

COALESCE(phone, 'No phone')         -- fallback display
COALESCE(total_amount, 0) * 1.18    -- safe arithmetic
COALESCE(phone, email, 'No contact') -- priority chain
```

### NULLIF

```sql
NULLIF(value1, value2)
-- Returns NULL  if value1 = value2
-- Returns value1 if value1 ≠ value2

NULLIF(stock_quantity, 0)   -- prevent division by zero
NULLIF(phone, '')           -- treat empty string as NULL
```

### CASE — Searched Form

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

### CASE — Simple Form

```sql
CASE column
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE default_result
END
```

---

## NULL in Aggregations

| Function     | NULL Behaviour                            |
| ------------ | ----------------------------------------- |
| `COUNT(*)`   | Counts ALL rows including NULLs           |
| `COUNT(col)` | Ignores NULLs                             |
| `SUM(col)`   | Ignores NULLs                             |
| `AVG(col)`   | Ignores NULLs — divides by non-NULL count |
| `MIN(col)`   | Ignores NULLs                             |
| `MAX(col)`   | Ignores NULLs                             |

---

## Production Patterns

```sql
-- Safe division (prevent crash)
100.0 / NULLIF(denominator, 0)

-- Profile completeness score
(CASE WHEN phone IS NOT NULL THEN 1 ELSE 0 END +
 CASE WHEN address IS NOT NULL THEN 1 ELSE 0 END
) * 100.0 / 2   AS completeness_pct

-- Financial fallback
COALESCE(total_amount, quantity * unit_price) AS safe_total

-- Audit flag
CASE WHEN total_amount IS NOT NULL
     THEN 'Actual' ELSE 'Computed' END AS source
```

## EDA Queries Built

1. User profile completeness scoring with 4 field flags
2. Revenue safety net with COALESCE fallback + audit flag
3. Product health dashboard with discount label + stock level

## Day 05 — NULL Handling

### The NULL Rules — Never Forget

1. NULL = NULL → NULL (not TRUE!)
2. NULL != NULL → NULL (not TRUE!)
3. 100 + NULL → NULL (arithmetic poison)
4. COUNT(\*) → includes NULLs
5. COUNT(column) → excludes NULLs
6. AVG(column) → excludes NULLs from denominator too

### COALESCE vs NULLIF — Quick Distinction

a. COALESCE → "give me the first non-NULL value"
b. Use for: fallback display, safe arithmetic
c. NULLIF → "give me NULL if these two values are equal"
d. Use for: prevent division by zero,
treat empty string as NULL

### CASE — the SQL if/else

```sql
-- Always handle NULL first in CASE
CASE
    WHEN column IS NULL THEN 'Missing'  ← check NULL first
    WHEN column > 100   THEN 'High'
    ELSE 'Normal'
END
-- If you check column > 100 first and column IS NULL
-- that WHEN evaluates to NULL → skipped → falls to next
-- Technically same result but IS NULL first is clearer intent
```
