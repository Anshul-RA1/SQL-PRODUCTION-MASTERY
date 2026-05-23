-- NULL means unknown or not applicable . it is the abscence of any value.

-- find the user with no phone number 

select 
	first_name , 
	last_name, 
	phone
from users 
where phone is null;

-- find the user with phone number 
select 
	first_name , 
	last_name, 
	phone
from users 
where phone is not null;

-- find the products that have been discounted
select 
	product_name,
	category,
	price,
	original_price,
	round(((original_price - price)/original_price) * 100 , 2) || ' %' as discount_percent
from products 
where original_price is not null and original_price <> 0
;

--Combining IS NULL with other conditions
select 
	first_name,
	email, 
	phone, 
	address
from users
where phone is null or address is null
;


-- COALSCE() - RETURN FIRST NON NULL VALUE 
--COALESCE is one of the most used functions in production SQL. 
--It takes any number of arguments and returns the first one that is not NULL.

-- Use case 1: Display fallback for missing phone

select 
	first_name, 
	address, 
	email,
	coalesce(phone, 'No phone number') as phone_display
from users;

-- Use case 3: Priority fallback chain
-- Show phone, if no phone show email, if no email show 'No contact'

select
	first_name,
	coalesce(phone, email, 'no contact info') as best_contact
from users;

-- Use case 4: Replace NULL last_name in full name
select 
	first_name,
	last_name,
	concat(first_name,' ', coalesce(last_name, '') ) as full_name
from users;

-- ============================================================
-- E-COMMERCE PLATFORM DATABASE
-- Phase 1, Day 5: NULL Handling
-- Engine: PostgreSQL 16
-- File: phase-1/day-05/queries.sql
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- SECTION 1: IS NULL and IS NOT NULL
-- ────────────────────────────────────────────────────────────

-- 1.1 Users with no phone number
SELECT first_name, email, country
FROM users
WHERE phone IS NULL;

-- 1.2 Users with no address on file
SELECT first_name, email, address
FROM users
WHERE address IS NULL;

-- 1.3 Users missing BOTH phone and address
SELECT first_name, email, phone, address
FROM users
WHERE phone   IS NULL
  AND address IS NULL;

-- 1.4 Products that have never been discounted
SELECT product_name, category, price
FROM products
WHERE original_price IS NULL;

-- 1.5 Orders with missing payment method
SELECT order_id, user_id, status, ordered_at
FROM orders
WHERE payment_method IS NULL;

-- 1.6 Orders with missing total_amount (data capture failure)
select 
	order_id,
	user_id,
	status,
	payment_method
from orders 
where total_amount is null;



-- ────────────────────────────────────────────────────────────
-- SECTION 2: COALESCE
-- ────────────────────────────────────────────────────────────

-- 2.1 Show fallback text for missing phone
SELECT
    first_name,
    email,
    COALESCE(phone, 'No phone on file')         AS phone_display
FROM users;

-- 2.2 Show fallback for missing address
SELECT
    first_name,
    COALESCE(address, 'Address not provided')   AS address_display
FROM users;

-- 2.3 Priority contact fallback chain
-- Show phone first, if NULL show email, if both NULL show message
SELECT
    first_name,
    COALESCE(phone, email, 'No contact info')   AS best_contact
FROM users;

-- 2.4 Handle NULL in arithmetic — total_amount
select
	order_id,
	total_amount,
	coalesce(total_amount, 0) as safe_total,
	round(coalesce(total_amount, 0) * 1.18, 2) as total_with_tax
from orders;

-- 2.5 Clean full name — handle NULL last_name
SELECT
    first_name,
    last_name,
    CONCAT(
        first_name, ' ',
        COALESCE(last_name, '')
    )                                           AS full_name
FROM users;


-- ────────────────────────────────────────────────────────────
-- SECTION 3: NULLIF
-- ────────────────────────────────────────────────────────────

-- 3.1 Prevent division by zero using NULLIF
-- Simulate: what percentage of stock is reserved?

select 
	product_name,
	stock_quantity,
	3                 as reserved,
	round(
		3 * 100.0/nullif(stock_quantity,0),2
	)                 as resrved_pct
from products
order by products.stock_quantity 
;

-- 3.3 Flag products where price equals original_price
-- (no actual discount despite having original_price set)
SELECT
    product_name,
    price,
    original_price,
    NULLIF(original_price, price)               AS real_original_price
FROM products;
-- Returns NULL if price = original_price (fake discount)
-- Returns original_price if genuinely different
-- ────────────────────────────────────────────────────────────
-- SECTION 4: CASE Expression
-- ────────────────────────────────────────────────────────────

-- 4.1 Order status labels

select 
	order_id,
	status,
	case status 
		when 'pending' 		then 'Awaiting Confirmation'
		when 'confirmed' 	then 'Order Confirmed'
		when 'shipped' 		then 'On the Way'
		when 'delivered' 	then 'Delivered Successfully'
		when 'canceled' 	then 'Cancelled'
		when 'returned' 	then 'Returned'
		else                   	 'Unknown Status' 
	end 										as status_label
from orders;

-- 4.2 Stock level classification
select 
	product_name,
	category,
	stock_quantity,
	case 
		when stock_quantity = 0 				then 'Out of Stock'
		when stock_quantity between 1 and 10 	then 'Low Stock'
		when stock_quantity between 11 and 50 	then 'Medium Stock'
		else  									 	 'Well Stocked'
	end                                              as stock_level
from products 
order by stock_quantity 
;

	
-- 4.3 Phone region detection using CASE + LIKE
select 
	first_name,
	phone, 
	case	
			when phone is null 		then 'Not Provided' 
			when phone like '+91%' 	then 'India'
			when phone like '+49%' 	then 'Germany'
			when phone like '+971%'	then 'UAE'
			when phone like '+33%' 	then 'France'
			else                    	 'Others'
	end                                   as phone_region
from users;

-- 4.4 Order value tier classification

select 
	order_id,
	total_amount,
	case 
		when total_amount is null 	then  'Missing'
		when total_amount >= 50000 	then  'High Value'
		when total_amount >= 10000 	then  'Mid Value'
		when total_amount >= 1000 	then  'Standard'
		else                              'Low Value'
	end 			as  order_tier

from orders
order by total_amount desc nulls last;


--- CTE QUERY :)
with order_classification as (
select 
	order_id,
	total_amount,
	case 
		when total_amount is null 	then  'Missing'
		when total_amount >= 50000 	then  'High Value'
		when total_amount >= 10000 	then  'Mid Value'
		when total_amount >= 1000 	then  'Standard'
		else                              'Low Value'
	end 			as  order_tier

from orders

)

select order_tier , count(*) as "Numbers"
from order_classification
group by order_tier;

	
	
-- 4.5 PIVOT — count orders by status in one row

select  
	count(*) as total_orders,
	count(case when status = 'delivered' then 1 end) as delivered,
	count(case when status = 'shipped' then 1 end) as shipped,
	count(case when status = 'confirmed' then 1 end) as confirmed,
	count(case when status = 'pending' then 1 end) as pending,
	count(case when status = 'cancelled' then 1 end) as cancelled,
	count(case when status = 'returned' then 1 end) as returned
from orders;

-- ────────────────────────────────────────────────────────────
-- SECTION 5: NULL behaviour in aggregations
-- ────────────────────────────────────────────────────────────

-- 5.2 AVG ignores NULL — verify manually
select  
	count(total_amount) as  values_averaged,
	sum(total_amount) as total_amount,
	round(avg(total_amount),2) as  avg_ignoring_null,
	round(sum(total_amount) / count(total_amount),2) as  manual_avg_chck
from orders;


















