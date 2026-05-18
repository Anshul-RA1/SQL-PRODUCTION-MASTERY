-- ============================================================
-- E-COMMERCE PLATFORM DATABASE
-- Phase 1, Day 4: String, Numeric & Date Functions
-- Engine: PostgreSQL 16
-- File: phase-1/day-04/queries.sql
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- SECTION 1: String Functions
-- ────────────────────────────────────────────────────────────

-- 1.1 LENGTH — find email length for all users

select 
	first_name, 
	last_name,
	email,
	length(email) as email_length
from users
order by email_length desc;

-- 1.2 UPPER and LOWER — normalize names and emails
select 
	upper(first_name) as first_name_upper,
	lower(email) as email_lower
from users;

-- 1.3 TRIM — clean whitespace (simulate dirty data)

select 
	product_name,
	length(product_name) as len_product_name,
	trim(product_name) as product_name_trim
--	length(product_name_trim) as len_trim_product_name
from products;


-- 1.4 REPLACE — standardize phone format
SELECT
    first_name,
    phone,
    REPLACE(phone, '-', '')     AS phone_no_dashes
FROM users
WHERE phone IS NOT NULL;

-- 1.5 SUBSTRING — extract country code from phone
select 
	first_name,
	phone,
	substring(phone,1,3) as country_code
from users
where phone is not null;

-- 1.6 SPLIT_PART — extract email username and domain
select 
	email,
	split_part(email , '@', 1) as user_name,
	split_part(email, '@', 2) as domain_name
from users;

-- 1.7 CONCAT vs || — handling NULL last_name
-- User 4 (Fatima) has NULL last_name — watch the difference

select 
	first_name,
	last_name,
	concat(first_name,' ', last_name) as concat_full_name,
	first_name || ' ' || last_name as pipe_full_name
from users;

-- 1.8 LEFT and RIGHT — extract parts of SKU codes
SELECT
    product_name,
    sku,
    LEFT(sku, 3)                AS sku_prefix,
    RIGHT(sku, 3)               AS sku_suffix
FROM products
WHERE sku IS NOT NULL;

-- 1.9 POSITION — find @ position in email
SELECT
    email,
    POSITION('@' IN email)      AS at_sign_position
FROM users;

-- ────────────────────────────────────────────────────────────
-- SECTION 2: Numeric Functions
-- ────────────────────────────────────────────────────────────

-- 2.1 ROUND — GST calculation rounded to 2 decimal places
SELECT
    product_name,
    price,
    ROUND(price * 0.18, 2)      AS gst_amount,
    ROUND(price * 1.18, 2)      AS price_with_gst
FROM products
ORDER BY price DESC;

-- 2.2 CEIL and FLOOR — shipping weight billing
SELECT
    product_name,
    weight_kg,
    FLOOR(weight_kg)            AS floor_weight,
    CEIL(weight_kg)             AS ceil_weight_billable
FROM products
WHERE weight_kg IS NOT NULL
ORDER BY weight_kg;

-- 2.3 ABS — price drop amount (absolute difference)
SELECT
    product_name,
    original_price,
    price,
    ABS(price - original_price)             AS price_drop,
    ROUND(
        ABS(price - original_price)
        * 100.0 / original_price
    , 2)                                    AS discount_pct
FROM products
WHERE original_price IS NOT NULL
ORDER BY discount_pct DESC;

-- 2.4 MOD — identify even and odd order IDs
SELECT
    order_id,
    total_amount,
    CASE WHEN MOD(order_id, 2) = 0
         THEN 'Even'
         ELSE 'Odd'
    END                         AS order_id_parity
FROM orders
LIMIT 10;

-- 2.5 Inventory value — ROUND applied to multiplication
SELECT
    product_name,
    price,
    stock_quantity,
    ROUND(price * stock_quantity, 2)    AS total_stock_value
FROM products
WHERE stock_quantity > 0
ORDER BY total_stock_value DESC;


-- ────────────────────────────────────────────────────────────
-- SECTION 3: Date & Time Functions
-- ────────────────────────────────────────────────────────────

-- 3.1 NOW, CURRENT_DATE — confirm server time
SELECT
    NOW()                       AS current_timestamp,
    CURRENT_DATE                AS today,
    CURRENT_TIME                AS current_time;


-- 3.2 EXTRACT — pull year, month, day from ordered_at
SELECT
    order_id,
    ordered_at,
    EXTRACT(YEAR  FROM ordered_at)  AS order_year,
    EXTRACT(MONTH FROM ordered_at)  AS order_month,
    EXTRACT(DAY   FROM ordered_at)  AS order_day,
    EXTRACT(DOW   FROM ordered_at)  AS day_of_week
FROM orders
ORDER BY ordered_at DESC;


-- 3.3 DATE_TRUNC — group orders by month
SELECT
    order_id,
    ordered_at,
    DATE_TRUNC('month', ordered_at)     AS order_month_start,
    DATE_TRUNC('year',  ordered_at)     AS order_year_start
FROM orders
ORDER BY ordered_at DESC;

-- 3.4 Date arithmetic — days since registration
SELECT
    first_name,
    created_at::DATE                            AS registered_on,
    CURRENT_DATE - created_at::DATE             AS days_since_joined,
    CURRENT_DATE - created_at::DATE
        > 365                                   AS over_one_year
FROM users
ORDER BY days_since_joined DESC;

-- 3.5 INTERVAL — expected delivery window
SELECT
    order_id,
    ordered_at::DATE                            AS order_date,
    ordered_at::DATE + INTERVAL '7 days'        AS expected_by,
    estimated_delivery_date
FROM orders
WHERE estimated_delivery_date IS NOT NULL
ORDER BY ordered_at DESC;

-- 3.6 TO_CHAR — format dates for human-readable reports
SELECT
    order_id,
    total_amount,
    status,
    TO_CHAR(ordered_at, 'DD Mon YYYY')          AS order_date_formatted,
    TO_CHAR(ordered_at, 'Month YYYY')           AS order_month_formatted,
    TO_CHAR(total_amount, 'FM₹999,999,990.00')  AS amount_formatted
FROM orders
ORDER BY ordered_at DESC;


-- 3.7 AGE — how long has each user been registered?
SELECT
    first_name,
    created_at::DATE                AS registered_on,
    AGE(NOW(), created_at)          AS account_age
FROM users
ORDER BY created_at ASC;

