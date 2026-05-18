--Problem 1 — Product Catalog Enrichment: 
--The frontend team needs a clean product display card for each product. 
--Build a query that returns: a display_name (product name in UPPERCASE), category, 
--display_price formatted as ₹X,XXX.00, gst_price (price × 1.18 rounded to 2 decimals), 
--discount_pct (percentage saved vs original price, rounded to 1 decimal — show NULL if never discounted), 
--and stock_status showing 'In Stock' if stock_quantity > 0 else 'Out of Stock'. 
--Only show listed products, sorted by price descending.

select 
	upper(product_name) as display_name,
	category,
	to_char(price , 'FM₹999,999,990.00') as display_price,
	round(price * 1.18 , 2) as gst_price,
	case
		when original_price is not null
		then round(
			abs(price - original_price)
				* 100.0/original_price	
				,1)
		else null 
	end 			as discnt_price,
	case when stock_quantity > 0
		then 'In stock'
		else 'Out of Stock'
	end     as stock_status	
from products
where is_listed = true
order by price desc 
;

--Problem 2 — User Communication Audit: 
--The CRM team needs a contact quality report. 
--For each user return: full_name (using CONCAT to handle NULL last names safely), email_username (part before @), 
--email_domain (part after @), phone_clean (phone with all dashes removed, NULL if no phone), 
--account_age_days (days since registration), 
--and last_seen formatted as 'DD Mon YYYY' (NULL users show 'Never Logged In'). Sort by account_age_days descending.

select  
	concat(first_name, ' ', last_name) as full_name,
	split_part(email, '@', 1) as user_name,
	split_part(email, '@', 2) as domain_name,
	case 
		when phone is not null 
		then replace(phone , '-', '')
		else null	
	end  as phone_clean,
	(CURRENT_DATE - created_at::DATE)   AS account_age_days,
	age(now(), created_at) as account_age,
	case 
		when last_login_at is not null
		then to_char(last_login_at , 'DD Mon YYYY')
		else 'Never Logged In'
	end    as last_seen
from users
order by account_age_days desc;


--Problem 3 — Monthly Revenue Timeline:
--The finance team wants to see which calendar month each order was placed in, 
--formatted as 'Month YYYY' (e.g. 'December 2024'), along with the order_id, total_amount formatted with ₹ symbol, 
--how many days ago the order was placed, and whether the order is older than 180 days (show TRUE/FALSE). 
--Only include orders with a non-NULL total_amount. 
--Sort by ordered_at descending.
--	


select  
	order_id,
	to_char(ordered_at, 'Month YYYY') as ordered_month,
	to_char(total_amount, 'FM₹999,999,990.00') as amount_formatted,
	(current_date - ordered_at::DATE) as days_ago,
	(current_date - ordered_at::DATE) > 180 as older_than_180_days
from orders 
where total_amount is not null 
order by ordered_at desc
;

	



	