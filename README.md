# 🛒 SQL Production Mastery

A production-grade SQL learning project built on PostgreSQL 16,
centered around a real-world multi-vendor E-Commerce Platform.

## 🗂️ Project Structure

SQL-PRODUCTION-MASTERY/
├── docs/
│ └── sql-roadmap.html # Interactive progress tracker
├── phase-1/ # Foundations (Days 1-7)
│ └── day-01/
│ ├── schema.sql # CREATE TABLE scripts
│ ├── seed_data.sql # INSERT seed data
│ ├── eda_queries.sql # Practice EDA queries
│ └── notes.md # Day notes
├── phase-2/ # Moderate Analytics (Days 8-16)
├── phase-3/ # Advanced Engineering (Days 17-25)
├── .gitignore
└── README.md

## 🗄️ Tech Stack

| Tool          | Purpose                         |
| ------------- | ------------------------------- |
| PostgreSQL 16 | Primary database engine         |
| DBeaver 26    | SQL client and file editor      |
| VS Code       | Code editor and file management |
| Git + GitHub  | Version control                 |

## 📦 The Project — Multi-Vendor E-Commerce Platform

We are building and analyzing a data platform similar to Amazon/eBay.
The database evolves across 3 phases as SQL skills grow.

### Current Schema (Phase 1)

| Table      | Rows | Description                         |
| ---------- | ---- | ----------------------------------- |
| `users`    | 10   | Platform users — buyers and sellers |
| `products` | 10   | Product listings with inventory     |
| `orders`   | 15   | Transactional order records         |

### Key Design Decisions

- `TIMESTAMPTZ` over `TIMESTAMP` — timezone-aware for global users
- `NUMERIC(p,s)` for all money columns — never `FLOAT`
- `unit_price` snapshotted in orders — preserves historical transaction truth
- `SERIAL` primary keys — auto-incrementing, never reused
- `NULL` used intentionally — optional fields vs missing data

## 📈 Progress

| Phase   | Topic                | Days       | Status         |
| ------- | -------------------- | ---------- | -------------- |
| Phase 1 | Foundations          | Days 1-7   | 🔄 In Progress |
| Phase 2 | Moderate Analytics   | Days 8-16  | ⏳ Pending     |
| Phase 3 | Advanced Engineering | Days 17-25 | ⏳ Pending     |

See `docs/sql-roadmap.html` for live progress tracking.

## ✅ Completed Days

### Day 1 — PostgreSQL Setup & Core Schema Bootstrap

- Installed PostgreSQL 16 and DBeaver 26
- Created `ecommerce_db` database
- Built `users`, `products`, `orders` tables with production constraints
- Seeded realistic data with intentional edge cases
  - NULL phones, addresses, password hashes
  - Zero-stock listed products
  - Cancelled and returned orders
  - Async payment NULLs
- Debugged real errors: single vs double quotes, NOT NULL planning,
  SERIAL sequence behavior

## 🔑 Key SQL Concepts — Quick Reference

```sql
-- Safe table removal
DROP TABLE IF EXISTS table_name CASCADE;

-- Auto-incrementing primary key
user_id  SERIAL  PRIMARY KEY

-- Nullable foreign key
seller_id  INTEGER  REFERENCES users(user_id)

-- Enum-style check constraint
status VARCHAR(20) DEFAULT 'pending'
       CHECK (status IN ('pending','confirmed','shipped',
                         'delivered','cancelled','returned'))

-- Timezone-aware timestamp with auto default
created_at  TIMESTAMPTZ  DEFAULT NOW()

-- Exact decimal for money — never FLOAT
price  NUMERIC(12, 2)  NOT NULL  CHECK (price >= 0)

-- Conditional aggregate count
COUNT(*) FILTER (WHERE condition)

-- Verify all tables exist
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

## 📝 Lessons Learned

| #   | Lesson                                                                             |
| --- | ---------------------------------------------------------------------------------- |
| 1   | Always use `'single quotes'` for text values, `"double quotes"` for identifiers    |
| 2   | `NOT NULL` must be planned carefully — nullable columns carry business meaning     |
| 3   | `SERIAL` sequences never reset on failed inserts — always reset via DROP + CREATE  |
| 4   | Run `schema.sql` before `seed_data.sql` — structure before data, always            |
| 5   | Separate structure and data into different files — Single Responsibility Principle |
| 6   | `INTEGER / INTEGER` = integer division — use `100.0` for percentage math           |
| 7   | `SUM()`, `AVG()`, `COUNT(column)` ignore NULLs — `COUNT(*)` does not               |
