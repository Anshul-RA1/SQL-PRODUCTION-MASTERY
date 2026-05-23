--Problem 1 — Incomplete Profile Report: 
--The growth team needs to know the data completeness score for each user. 
--Build a query showing full_name, email, country, and four flag columns: 
--has_phone, has_address, 
--has_verified_email, 
--has_logged_in_since_signup (TRUE/FALSE each). 
--Also compute a profile_completeness_pct — percentage of the 4 fields that are filled (each field is worth 25%). 
--Sort by profile_completeness_pct ascending so most incomplete profiles appear first.

select 
	concat(first_name , ' ', coalesce(last_name, '')) as full_name,
	email,
	country,
	phone is not null as has_phone,
	address is not null as has_address,
	is_verified as has_verified_email,
	last_login_at is not null as has_logged_in,
	round((
		(case when phone is not null then 1 else 0 end) +
		(case when address is not null then 1 else 0 end) +
		(case when is_verified = true then 1 else 0 end) + 
		(case when last_login_at is not null then 1 else 0 end)
	) * 100.0 / 4
	
	,2)   as profile_completeness_pct
from users
order by profile_completeness_pct asc 
;


--Problem 2 — Revenue Safety Net: 
--The finance team is running end-of-month reconciliation. 
--They need all orders where total_amount is NULL replaced with a computed value (quantity × unit_price), 
--clearly flagged as 'Computed' vs 'Actual'. 
--Show order_id, user_id, quantity, unit_price, 
--total_amount, safe_total (COALESCE with computed fallback), 
--and amount_source flag. 
--Only show delivered or confirmed orders. Sort by order_id.
--		
select 
	order_id,
	user_id,
	quantity,
	unit_price,
	total_amount,
	status,
	round(coalesce(total_amount, quantity * unit_price), 2) as safe_total,
	case
		when total_amount is not null then 'Actual'
		else 'Computed'
	end  as amount_source
from orders 
where status in ('delivered', 'confirmed')
order by order_id 
;

--
--Problem 3 — Product Health Dashboard: 
--Build a product health summary showing product_name, category, price_display (formatted with ₹), 
--discount_label (e.g. '15% OFF' if discounted, 'No Discount' if not), 
--stock_level ('Out of Stock' / 'Low' / 'Medium' / 'High'), 
--and listing_status ('Live' if is_listed=TRUE and stock_quantity > 0, 'Listed but No Stock' 
--if listed but 0 stock, 'Delisted' if not listed). 
--Sort by listing_status, then price descending.
--

select  
	product_name,
	category,
	to_char(price , 'FM₹999,999,990.00') as price_display,
	case 
		when original_price is null then 'No discount'
		else 
			concat(
				round(
				(original_price - price) * 100.0/ original_price,0		
			
			)::TEXT, '% OFF'
		)
	end as  discount_label,
	Case
		when stock_quantity = 0 then 'Out of Stock'
		when stock_quantity between 1 and 11 then 'Low'
		when stock_quantity between 11 and 50 then 'Medium'
		else 'High'
	end   as  stock_level,
	Case
		when is_listed = true and stock_quantity > 0 then 'Live'
		when is_listed = true and stock_quantity = 0 then 'Listed but No Stock'
 		else 'Delisted'   
	end  as  listing_status
from products 
order by listing_status asc , price desc 
;

	