-- ============================================================
-- E-COMMERCE PLATFORM DATABASE
-- Phase 1, Day 3: ORDER BY, LIMIT, OFFSET & DISTINCT
-- Engine: PostgreSQL 16
-- File: phase-1/day-03/queries.sql
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- SECTION 1: ORDER BY — basic sorting
-- ────────────────────────────────────────────────────────────

-- 1.1 All products sorted by price — cheapest first
select 
	product_id,
	product_name,
	category,
	price 
from products
order by price;

-- 1.2 All products sorted by price — most expensive first
SELECT product_name, category, price
FROM products
ORDER BY price DESC;

-- 1.3 All orders sorted by ordered_at — most recent first
SELECT order_id, user_id, total_amount, status, ordered_at
FROM orders
ORDER BY ordered_at DESC;

-- 1.4 Multi-column sort: category A→Z, within category price high→low
SELECT product_name, category, price, stock_quantity
FROM products
ORDER BY category ASC, price DESC;

-- 1.5 Sort users by country A→Z, then by first_name A→Z
SELECT first_name, last_name, country, created_at
FROM users
ORDER BY country ASC, first_name ASC;

-- ────────────────────────────────────────────────────────────
-- SECTION 2: ORDER BY with NULLs
-- ────────────────────────────────────────────────────────────

-- 2.1 Users sorted by last_login_at — most recent first
-- NULLs (never logged in) pushed to bottom explicitly
SELECT first_name, email, last_login_at
FROM users
ORDER BY last_login_at DESC NULLS LAST;

-- 2.2 Products sorted by original_price — NULLs at bottom
-- NULLs here mean product was never discounted
SELECT product_name, price, original_price
FROM products
ORDER BY original_price DESC NULLS LAST;

-- ────────────────────────────────────────────────────────────
-- SECTION 3: LIMIT — controlling result size
-- ────────────────────────────────────────────────────────────

-- 3.1 Top 3 most expensive products
SELECT product_name, category, price
FROM products
ORDER BY price DESC
LIMIT 3;

-- 3.2 Top 5 most recent orders
SELECT order_id, user_id, total_amount, status, ordered_at
FROM orders
ORDER BY ordered_at DESC
LIMIT 5;

-- 3.3 The single most expensive order ever placed
SELECT order_id, user_id, total_amount, status
FROM orders
ORDER BY total_amount DESC NULLS LAST
LIMIT 1;

-- 3.4 Top 5 cheapest in-stock products
SELECT product_name, price, stock_quantity
FROM products
WHERE stock_quantity > 0
ORDER BY price ASC
LIMIT 5;

-- ────────────────────────────────────────────────────────────
-- SECTION 4: LIMIT + OFFSET — pagination
-- ────────────────────────────────────────────────────────────

-- Paginating products sorted by price ASC
-- Page size = 4 products per page

-- 4.1 Page 1 — products 1 to 4
SELECT product_name, price, category
FROM products
ORDER BY price ASC
LIMIT  4
OFFSET 0;

-- 4.2 Page 2 — products 5 to 8
SELECT product_name, price, category
FROM products
ORDER BY price ASC
LIMIT  4
OFFSET 4;

-- 4.3 Page 3 — products 9 to 12
SELECT product_name, price, category
FROM products
ORDER BY price ASC
LIMIT  4
OFFSET 8;

-- 4.4 Pagination on orders — most recent first
-- Page 1 of order history (5 per page)
SELECT order_id, user_id, total_amount, status, ordered_at
FROM orders
ORDER BY ordered_at DESC
LIMIT  5
OFFSET 0;

-- Page 2
SELECT order_id, user_id, total_amount, status, ordered_at
FROM orders
ORDER BY ordered_at DESC
LIMIT  5
OFFSET 5;


-- ────────────────────────────────────────────────────────────
-- SECTION 5: DISTINCT
-- ────────────────────────────────────────────────────────────

-- 5.1 What unique countries do our users come from?
SELECT DISTINCT country
FROM users
ORDER BY country ASC;

-- 5.2 What unique product categories exist?
SELECT DISTINCT category
FROM products
ORDER BY category ASC;

-- 5.3 What unique order statuses exist in our system?
SELECT DISTINCT status
FROM orders
ORDER BY status ASC;

-- 5.4 What unique payment methods have been used?
SELECT DISTINCT payment_method
FROM orders
ORDER BY payment_method ASC NULLS LAST;

-- 5.5 Unique combination of country + is_active status
SELECT DISTINCT country, is_active
FROM users
ORDER BY country, is_active;

-- ────────────────────────────────────────────────────────────
-- SECTION 6: COUNT DISTINCT — analytics
-- ────────────────────────────────────────────────────────────
-- 6.1 How many unique countries are our users from?
SELECT COUNT(DISTINCT country)      AS unique_countries
FROM users;

-- 6.2 How many unique buyers have placed at least one order?
SELECT COUNT(DISTINCT user_id)      AS unique_buyers
FROM orders;

-- 6.3 How many unique products have been ordered?
SELECT COUNT(DISTINCT product_id)   AS unique_products_ordered
FROM orders;

-- 6.4 How many unique payment methods have been used?
SELECT COUNT(DISTINCT payment_method) AS unique_payment_methods
FROM orders
WHERE payment_method IS NOT NULL;





