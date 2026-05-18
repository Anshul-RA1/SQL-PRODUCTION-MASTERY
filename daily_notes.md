# Daily Learning Notes — SQL Production Mastery

---

## Day 02 — INSERT, SELECT & WHERE Filtering

### PostgreSQL Execution Order

> The order you **write** SQL is NOT the order PostgreSQL **executes** it.

| Step | You Write  | PostgreSQL Executes                |
| ---- | ---------- | ---------------------------------- |
| 1    | `SELECT`   | `FROM` → which table?              |
| 2    | `FROM`     | `WHERE` → filter rows              |
| 3    | `WHERE`    | `GROUP BY` → group rows _(Day 6)_  |
| 4    | `GROUP BY` | `HAVING` → filter groups _(Day 8)_ |
| 5    | `HAVING`   | `SELECT` → pick columns            |
| 6    | `ORDER BY` | `ORDER BY` → sort results          |
| 7    | `LIMIT`    | `LIMIT` → cut results              |

**Memory shortcut:**

# You write → 1, 2, 3, 4, 5, 6, 7

# PG executes → 2, 3, 4, 5, 1, 6, 7

---

### Revision Q&A

**Q1. Why does this fail?**

```sql
SELECT price * qty AS total
FROM orders
WHERE total > 1000;
```

`WHERE` runs before `SELECT` in PostgreSQL's execution order.
The alias `total` is created in the `SELECT` step — which hasn't
happened yet when `WHERE` is evaluated. PostgreSQL throws:

# ⚠️ERROR: column "total" does not exist

✅ **Fix:** Use the full expression in WHERE directly:

```sql
WHERE price * qty > 1000
```

---

**Q2. What is the difference between `LIKE` and `ILIKE`?**

| Operator | Case Sensitive | Example | Matches                   |
| -------- | -------------- | ------- | ------------------------- |
| `LIKE`   | ✅ Yes         | `'A%'`  | `Arjun` but NOT `arjun`   |
| `ILIKE`  | ❌ No          | `'A%'`  | `Arjun`, `arjun`, `ARJUN` |

> ⚠️ `ILIKE` is **PostgreSQL-specific** — not available in MySQL or SQL Server.

---

**Q3. Why should you never write `WHERE phone = NULL`?**

`NULL` means **unknown value**. In SQL:

- `NULL = NULL` does **not** evaluate to `TRUE` — it evaluates to `NULL`
- `WHERE` treats `NULL` as `FALSE`
- So `WHERE phone = NULL` silently returns **zero rows every time**

```sql
-- ❌ Wrong — always returns 0 rows
WHERE phone = NULL

-- ✅ Correct
WHERE phone IS NULL
WHERE phone IS NOT NULL
```

> 💡 **Golden Rule:** Never use `= NULL`. Always use `IS NULL` or `IS NOT NULL`.

---

## Day 04 — Revision Q&A

**Q1. What is the difference between `CONCAT()` and `||`
when one value is NULL?**

- `CONCAT()` treats `NULL` as an empty string `''` — result is
  still returned even if some values are NULL
- `||` operator — if ANY part of the expression is NULL,
  the **entire result becomes NULL**

```sql
-- User with NULL last_name (Fatima):
CONCAT('Fatima', ' ', NULL)     → 'Fatima '   ✅ safe
'Fatima' || ' ' || NULL         → NULL         ❌ poisoned

-- Best practice: use CONCAT() when any column might be NULL
-- Or use COALESCE to handle NULLs explicitly:
CONCAT(first_name, ' ', COALESCE(last_name, ''))
```

---

**Q2. What does `DATE_TRUNC('month', ordered_at)` return
for `'2024-12-15 14:30:00'`?**

It returns the **timestamp of the very first moment of that month**:

```sql
DATE_TRUNC('month', '2024-12-15 14:30:00')
→ '2024-12-01 00:00:00+00'
```

It does NOT return just "December" or "12".
It truncates everything below month level (day, hour, minute, second)
to their minimum values — giving the start of the month.

This is why it is powerful for analytics — all orders placed in
December 2024 get grouped under the same `'2024-12-01 00:00:00'`
value regardless of what day or time they were placed.

---

**Q3. When would you use `CEIL()` over `ROUND()`
in a real business scenario?**

Use `CEIL()` when you must **always round UP** regardless of the
decimal value — business logic requires it.

Use `ROUND()` when you want standard mathematical rounding
(≥ 0.5 rounds up, < 0.5 rounds down).

```sql
-- Scenario: Shipping weight billing
-- Never undercharge — always bill the full kg above

weight_kg = 2.1

ROUND(2.1, 0)  → 2   ❌ undercharges customer
CEIL(2.1)      → 3   ✅ correct billing

-- Other CEIL() use cases:
-- Pages needed to print N records (CEIL(records / page_size))
-- Minimum number of boxes to pack N items
-- Minimum number of buses for N passengers

-- ROUND() use cases:
-- GST amount display → ROUND(price * 0.18, 2)
-- Average order value → ROUND(AVG(total_amount), 2)
-- Discount percentage → ROUND(discount * 100.0 / price, 1)
```

> 💡 **Rule of thumb:**
> `CEIL()` = business says "never go below"
> `ROUND()` = mathematics says "nearest value"
