# Day 02 — INSERT, SELECT & WHERE Filtering

**Phase:** 1 — Foundations

---

## Concepts Covered

- PostgreSQL execution order — FROM → WHERE → SELECT → ORDER BY → LIMIT
- SELECT with column aliases using AS
- String concatenation using || operator
- INSERT single row, multiple rows, with RETURNING clause
- WHERE with comparison operators: =, !=, >, <, >=, <=
- AND, OR, NOT logical operators with bracket precedence rules
- BETWEEN for range filtering (inclusive)
- IN and NOT IN for list matching
- LIKE and ILIKE for pattern matching (%, \_ wildcards)
- IS NULL and IS NOT NULL — never use = NULL

## Critical Rules Learned

| Rule                   | Correct           | Wrong             |
| ---------------------- | ----------------- | ----------------- |
| Check for NULL         | `IS NULL`         | `= NULL`          |
| Text values            | `'single quotes'` | `"double quotes"` |
| Case-insensitive match | `ILIKE`           | `LIKE`            |
| Mix AND + OR           | Use `()` brackets | No brackets       |
| Alias in WHERE         | Not allowed       | `WHERE alias > x` |

## Key Syntax

```sql
-- String concatenation
first_name || ' ' || last_name  AS full_name

-- Date difference in days
(CURRENT_DATE - created_at::DATE)  AS days_registered

-- Case-insensitive pattern match
WHERE product_name ILIKE '%pro%'

-- Range filter
WHERE price BETWEEN 1000 AND 10000

-- List filter
WHERE status IN ('pending', 'confirmed', 'shipped')

-- NULL check
WHERE phone IS NOT NULL

-- Insert and get generated ID back
INSERT INTO users (...) VALUES (...) RETURNING user_id;
```

## EDA Queries Built

1. Active verified Indian users with phone — sorted by seniority
2. Revenue leak detection — high value stuck orders
3. Product search with GST computation — ILIKE pattern match
