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
