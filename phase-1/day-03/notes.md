# Day 03 — ORDER BY, LIMIT, OFFSET & DISTINCT

**Phase:** 1 — Foundations
**Date Completed:**

---

## Concepts Covered

- ORDER BY with ASC and DESC
- Multi-column sorting — primary sort + secondary sort
- NULL handling in ORDER BY — NULLS FIRST / NULLS LAST
- LIMIT — restricting result size, always pair with ORDER BY
- OFFSET — skipping rows for pagination
- Pagination formula: OFFSET = (page - 1) \* page_size
- DISTINCT — removing duplicate rows
- COUNT(DISTINCT column) — counting unique values
- DISTINCT vs GROUP BY — when to use which

## Key Syntax

```sql
-- Multi-column sort
ORDER BY category ASC, price DESC;

-- NULL control in sorting
ORDER BY last_login_at DESC NULLS LAST;

-- Top N rows
ORDER BY price DESC
LIMIT 5;

-- Pagination — Page N
LIMIT  page_size
OFFSET (page_number - 1) * page_size;

-- Unique values
SELECT DISTINCT country FROM users;

-- Count unique values
SELECT COUNT(DISTINCT country) FROM users;
```

## Production Rules

- Never use LIMIT without ORDER BY — results are random
- OFFSET is slow at large scale (millions of rows) — use cursor pagination
- DISTINCT operates on the full row — all selected columns together
- Use COUNT(DISTINCT col) not COUNT(col) when counting unique values
- NULLS LAST is best practice in most business reports

## EDA Queries Built

1. Top 5 products by stock value (price × quantity)
2. Paginated order history — Page 2 for user_id = 1
3. Platform diversity audit — unique countries, payments, statuses

## Day 03 — ORDER BY, LIMIT, OFFSET & DISTINCT

### Key Rules

| Concept       | Rule                                           |
| ------------- | ---------------------------------------------- |
| `ORDER BY`    | Always specify — never assume default order    |
| `LIMIT`       | Always pair with `ORDER BY` — else random rows |
| `OFFSET`      | Slow at scale — fine for small datasets        |
| `DISTINCT`    | Works on full row — all columns combined       |
| NULLs in sort | PostgreSQL: ASC→NULLs last, DESC→NULLs first   |

### Pagination Formula

1. Page 1 → LIMIT 10 OFFSET 0
2. Page 2 → LIMIT 10 OFFSET 10
3. Page N → LIMIT 10 OFFSET (N-1) \* 10

### COUNT(DISTINCT) vs COUNT(\*)

```sql
COUNT(*)               -- counts ALL rows including duplicates
COUNT(DISTINCT user_id) -- counts each user ONCE only
```
