-- ============================================================
-- E-COMMERCE PLATFORM DATABASE
-- Phase 1, Day 1: Core Schema Bootstrap
-- Engine: PostgreSQL 16
-- File: phase-1/day-01/schema.sql
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- STEP 1: Drop tables in reverse dependency order
-- orders depends on users and products → drop orders first
-- CASCADE handles any lingering constraints cleanly
-- ────────────────────────────────────────────────────────────

DROP TABLE IF EXISTS orders    CASCADE;
DROP TABLE IF EXISTS products  CASCADE;
DROP TABLE IF EXISTS users     CASCADE;

-- ────────────────────────────────────────────────────────────
-- TABLE 1: users
-- ────────────────────────────────────────────────────────────

create table users (
	user_id  	   serial primary key,
	first_name     varchar(100) not null,
	last_name      varchar(100),
	email          varchar(255) not null unique ,
	password_hash  text,
	phone 		   varchar(20),
	address 	   text,
	country 	   varchar(100) default 'India',
	is_active 	   boolean default true,
	is_verified    boolean default false,
	created_at 	   timestamptz default now(),
	last_login_at  timestamptz
);

comment on table users   is 'All registered platform users including customers and future sellers';
comment on column users.password_hash is 'bcrypt hash of the user password. NULL for OAuth/social login users';
comment on column users.last_login_at is 'Timestamp of most recent successful login. NULL if never logged in after registration';

-- ────────────────────────────────────────────────────────────
-- TABLE 2: products
-- ────────────────────────────────────────────────────────────

create table products (
	product_id     serial primary key ,
	product_name   varchar(300) not null,
	description    text,
	category       varchar(100),
	price          numeric(10,2) not null check(price>=0),
	original_price numeric(10,2)          check(original_price>=0),
	stock_quantity integer not null  default 0 check(stock_quantity>=0),
	sku 		   varchar(100) unique,
	seller_id      integer references users(user_id),
	weight_kg      numeric(8,3),
	is_listed      boolean default true,
	created_at 	   timestamptz default now(),
	updated_at     timestamptz default now()
);
	
COMMENT ON TABLE  products                IS 'All product listings on the platform, active and inactive';
COMMENT ON COLUMN products.sku            IS 'Stock Keeping Unit — seller internal reference code. Optional.';
COMMENT ON COLUMN products.original_price IS 'Pre-discount price. NULL means product has never been discounted';
COMMENT ON COLUMN products.seller_id      IS 'FK to users. The user who listed this product. NULL = platform inventory';


-- ────────────────────────────────────────────────────────────
-- TABLE 3: orders
-- ────────────────────────────────────────────────────────────

create table orders (
	order_id serial primary key,
	user_id integer not null references users(user_id),
	product_id integer not null references products(product_id),
	quantity smallint not null default 1 check(quantity > 0),
	unit_price numeric(12,2) not null check(unit_price >=0),
	total_amount numeric(14,2) check(total_amount >= 0),
	status varchar(20) not null default 'pending' 
						check (status in('pending', 'confirmed', 'shipped', 'delivered', 'cancelled','returned')),
	payment_method varchar(50)
	 			check (payment_method in ('credit_card','debit_card','upi','net_banking','wallet','cod','emi')),
	delivery_address text,
	ordered_at timestamptz default now(),
	updated_at timestamptz,
	estimated_delivery_date date

);
	

COMMENT ON TABLE  orders            IS 'Order header records. One row per order line.';
COMMENT ON COLUMN orders.unit_price IS 'Price at time of purchase — snapshot from products.price. Immutable after order creation.';
COMMENT ON COLUMN orders.status     IS 'Order lifecycle: pending → confirmed → shipped → delivered. Terminal: cancelled, returned.';

-- Confirm all 3 tables exist
select table_name , table_type
from information_schema.tables 
where table_schema = 'public'
order by table_name  

select * from users;
select * from products;
select * from orders;

SELECT 'users'    AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM products
UNION ALL
SELECT 'orders'   AS table_name, COUNT(*) AS row_count FROM orders;






