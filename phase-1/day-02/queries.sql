-- ============================================================
-- E-COMMERCE PLATFORM DATABASE
-- Phase 1, Day 2: INSERT practice + SELECT & WHERE queries
-- Engine: PostgreSQL 16
-- File: phase-1/day-02/queries.sql
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- SECTION 1: Additional INSERT practice
-- We add 2 more users, 2 more products, 3 more orders
-- to make our dataset richer for filtering practice
-- ────────────────────────────────────────────────────────────

-- Add 2 more users
-- Note: we use RETURNING to see what user_id gets assigned

insert into users (first_name, last_name ,email, password_hash, phone, address, country, is_active, is_verified)
values 
	('Arjun',  'Singhania', 'arjun.singhania@gmail.com', '$2b$12$abc123hashedpassword11', '+91-9867890123','15 Civil Lines, Jaipur, RJ 302006','India', TRUE, TRUE),
	('Sophie', 'Laurent',   'sophie.laurent@gmail.com',  '$2b$12$abc123hashedpassword12', '+33-612345678', '12 Rue de Rivoli, Paris, France','France', TRUE, FALSE)
	
returning user_id, first_name, email, created_at;

-- Add 2 more products
insert into products (product_name, description, category, price, original_price, stock_quantity, sku, seller_id, weight_kg, is_listed)
values
    ('Apple AirPods Pro (2nd Gen)', 'Active noise cancellation. MagSafe charging case.', 'Electronics', 24900.00, 26900.00, 35, 'APL-APP-2G-WHT', 1, 0.061, TRUE),
    ('Whey Protein Isolate 1kg',    'Unflavoured. 27g protein per serving. Lab tested.',  'Health',       3299.00,   NULL,     80, 'HLT-WPI-1KG-UNF', 8, 1.200, TRUE)
returning product_id, product_name, price;


-- Add 3 more orders
-- Note: user_id 11 and 12 are our new users above
-- product_id 11 and 12 are our new products above
insert into orders (user_id, product_id, quantity, unit_price, total_amount, status, payment_method, delivery_address, estimated_delivery_date)
values 
    (11, 11, 1, 24900.00, 24900.00, 'confirmed', 'credit_card', '15 Civil Lines, Jaipur, RJ 302006', '2025-05-25'),
    (12, 12, 2,  3299.00,  6598.00, 'pending',   'upi',         '12 Rue de Rivoli, Paris, France',   '2025-05-30'),
    (1,  12, 1,  3299.00,  3299.00, 'delivered', 'debit_card',  '12 MG Road, Bangalore, KA 560001',  '2025-04-20')
returning order_id, user_id, product_id, status, total_amount;


-- ────────────────────────────────────────────────────────────
-- SECTION 2: Basic SELECT queries
-- ────────────────────────────────────────────────────────────

-- 2.1 Get all columns from users (exploration only)

select * from users;

-- 2.2 Get only specific columns — always do this in production
SELECT user_id, first_name, last_name, email, country
FROM users;

-- 2.3 Use aliases to rename columns in output
SELECT
    user_id                             AS "ID",
    first_name || ' ' || last_name      AS "Full Name",
    email                               AS "Email Address",
    country                             AS "Country"
FROM users;
-- Note: || is PostgreSQL's string concatenation operator
-- 'Rohan' || ' ' || 'Sharma' = 'Rohan Sharma'

-- 2.4 Compute new values on the fly 
select 
	product_name,
	price           as original_price,
	round(price * 0.18, 2) as gst_18_pct,
	round(price * 1.18, 2) as price_incl_gst
from products;


-- ────────────────────────────────────────────────────────────
-- SECTION 3: WHERE — single condition filtering
-- ────────────────────────────────────────────────────────────

-- 3.1 All users from India only 
select 
	first_name, last_name, email , country
from users 
where country = 'India';

-- 3.2 All products that are currently listed for sale
select 
	product_name, category, price, stock_quantity
from products
where is_listed = true;

-- 3.3 All orders with status 'delivered'
SELECT order_id, user_id, product_id, total_amount, ordered_at
FROM orders
WHERE status = 'delivered';

-- 3.4 All products cheaper than ₹5000
SELECT product_name, category, price
FROM products
WHERE price < 5000
ORDER BY price ASC;
-- ASC = ascending (low to high), DESC = descending (high to low)


-- 3.5 All orders where total_amount is more than ₹10000
SELECT order_id, user_id, total_amount, status
FROM orders
WHERE total_amount > 10000;

-- ────────────────────────────────────────────────────────────
-- SECTION 4: WHERE with AND, OR, NOT
-- ────────────────────────────────────────────────────────────

-- 4.1 Active AND verified users only
SELECT user_id, first_name, email, is_active, is_verified
FROM users
WHERE is_active   = TRUE
  AND is_verified = TRUE;


-- 4.2 Products in Electronics category AND price under ₹15000
SELECT product_name, price, stock_quantity
FROM products
WHERE category      = 'Electronics'
  AND price         < 15000
  AND stock_quantity > 0;


-- 4.3 Orders that are either cancelled OR returned (terminal states)
SELECT order_id, user_id, status, total_amount, ordered_at
FROM orders
WHERE status = 'cancelled'
   OR status = 'returned';

-- 4.4 Users who are NOT from India
SELECT first_name, last_name, email, country
FROM users
WHERE NOT country = 'India';
-- Same as: WHERE country != 'India'  or  WHERE country <> 'India'

-- 4.5 High value orders that are still active (not terminal states)
-- Brackets used explicitly to prevent precedence confusion
SELECT order_id, user_id, total_amount, status
FROM orders
WHERE total_amount > 10000
  AND (status = 'pending'
    OR status = 'confirmed'
    OR status = 'shipped');

-- ────────────────────────────────────────────────────────────
-- SECTION 5: WHERE with BETWEEN, IN, LIKE
-- ────────────────────────────────────────────────────────────
SELECT product_name, category, price
FROM products
WHERE price BETWEEN 1000 AND 10000
ORDER BY price;

-- 5.2 Orders placed in the year 2024 only
SELECT order_id, user_id, total_amount, status, ordered_at
FROM orders
WHERE ordered_at BETWEEN '2024-01-01 00:00:00' AND '2024-12-31 23:59:59';

-- 5.3 Find orders that are in 'active' statuses using IN
SELECT order_id, status, total_amount
FROM orders
WHERE status IN ('pending', 'confirmed', 'shipped')
ORDER BY total_amount DESC;

-- 5.4 Find all Gmail users using LIKE
SELECT first_name, email
FROM users
WHERE email LIKE '%@gmail.com';


-- 5.5 Find all users whose first name starts with 'A'
SELECT first_name, last_name, email
FROM users
WHERE first_name LIKE 'A%';

-- 5.6 Find all Indian phone numbers (start with +91)
SELECT first_name, phone, country
FROM users
WHERE phone LIKE '+91%';
























