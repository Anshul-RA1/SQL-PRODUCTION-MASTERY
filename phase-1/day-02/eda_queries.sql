--Problem 1 — Customer Segmentation: 
--The marketing team wants a list of all active, verified users from India 
--who have a phone number on file. They need full name, email, phone and 
--how long they have been registered on the platform in days. 
--Sort by longest registered first.

select * from users;

select 
	user_id,
	first_name || ' ' || last_name as full_name,
	email,
	phone,
	(current_date - created_at::Date) as days_registered,
	country
from users 
where country = 'India' 
		and phone is not null  
		and is_active = true 
		and is_verified = true
order by days_registered desc
;

--Problem 2 — Revenue Leak Detection: 
--The finance team suspects some high-value orders are stuck in non-terminal statuses for too long. 
--Find all orders where total_amount is above ₹5,000 AND the status is NOT one of the terminal states 
--(delivered, cancelled, returned). 
--Show order_id, user_id, total_amount, status, and ordered_at. 
--Sort by total_amount descending.

select 
	order_id ,
	user_id,
	total_amount,
	status,
	ordered_at
from orders 
where total_amount > 5000
	  and status not in ('delivered', 'cancelled', 'returned')
order by total_amount desc;

--Problem 3 — Product Search Feature: 
--A buyer searches for products containing the word "Pro" in the name. 
--Build the search query that returns product_name, category, price, stock_quantity, 
--and a computed column price_with_gst (price × 1.18, rounded to 2 decimal places). 
--Only show products that are currently listed and in stock. Sort by price ascending.

select 
	product_id,
	product_name,
	category,
	price,
	stock_quantity,
	round(price * 1.18, 2) as price_incl_gst	
from products 
where product_name Ilike '%Pro%' 
      and is_listed = true
	  and stock_quantity > 0 
order by price asc; 






