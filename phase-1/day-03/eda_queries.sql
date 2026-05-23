--Problem 1 — Top Seller Report: 
--The business team wants to know which top 5 products by unit price are currently listed and in stock. 
--Show product_name, category, price, stock_quantity, and a column called stock_value 
--which is price × stock_quantity (the total rupee value of that product sitting in inventory). 
--Sort by stock_value descending.

select 	
	product_name, 
	category,
	price,
	stock_quantity,
	round(price * stock_quantity, 2) as stock_value
from products
where stock_quantity > 0 and is_listed=true 
order by stock_value desc 
limit 5 
;

--Problem 2 — Order History Pagination: 
--Build the query that powers page 2 of a user's order history screen. 
--The user with user_id = 1 (Rohan) wants to see his orders, most recent first, with 2 orders per page. 
--Show order_id, product_id, quantity, unit_price, total_amount, status, and ordered_at.

select 
	user_id,
	order_id,
	product_id,
	quantity,
	unit_price,
	total_amount,
	status,
	ordered_at
from orders 
where user_id = 1
order by ordered_at desc
limit 2
offset 2
;


--Problem 3 — Platform Diversity Audit: 
--The analytics team wants a unique summary of what countries, payment methods, 
--and order statuses exist in the platform — basically a data dictionary of all distinct categorical values across the system. 
--Write three separate SELECT DISTINCT queries and also show the count of unique values for each. Present results sorted alphabetically.

-- Part A: Unique countries with user count per country
select 
	distinct 
	country,
	count(*) as user_count
from users
group by country
order by country asc;

-- Part B: Unique payment methods used
SELECT DISTINCT
    payment_method,
    COUNT(*)    AS times_used
FROM orders
WHERE payment_method IS NOT NULL
GROUP BY payment_method
ORDER BY times_used DESC;

-- Part C: Unique order statuses with count
SELECT DISTINCT
    status,
    COUNT(*)    AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;




