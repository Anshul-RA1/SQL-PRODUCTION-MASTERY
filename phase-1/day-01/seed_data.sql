-- ============================================================
-- E-COMMERCE PLATFORM DATABASE
-- Phase 1, Day 1: Seed Data
-- Engine: PostgreSQL 16
-- File: phase-1/day-01/seed_data.sql
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- INSERT INTO users
-- Edge cases included:
--   • last_name NULL (user 4)        → single name registration
--   • password_hash NULL (user 6)    → social/OAuth login
--   • phone NULL                     → optional field
--   • address NULL (user 5)          → skipped at registration
--   • is_active FALSE (user 3)       → deactivated account
--   • is_verified FALSE (users 5,7)  → email not verified yet
--   • last_login_at NULL (user 5)    → never logged in again
-- ────────────────────────────────────────────────────────────

INSERT INTO users (first_name, last_name, email, password_hash, phone, address, country, is_active, is_verified, created_at, last_login_at)
VALUES
    ('Rohan',   'Sharma',   'rohan.sharma@gmail.com',   '$2b$12$abc123hashedpassword1',  '+91-9812345678', '12 MG Road, Bangalore, KA 560001',    'India',   TRUE,  TRUE,  '2023-06-15 09:22:00+05:30', '2025-04-10 18:45:00+05:30'),
    ('Priya',   'Mehta',    'priya.mehta@yahoo.com',    '$2b$12$abc123hashedpassword2',  '+91-9923456789', '45 Linking Road, Mumbai, MH 400050',  'India',   TRUE,  TRUE,  '2023-08-01 11:05:00+05:30', '2025-03-28 10:10:00+05:30'),
    ('Ankur',   'Joshi',    'ankur.joshi@outlook.com',  '$2b$12$abc123hashedpassword3',  NULL,             '7 Civil Lines, Bhopal, MP 462001',    'India',   FALSE, TRUE,  '2022-11-20 07:30:00+05:30', '2023-05-14 09:00:00+05:30'),
    ('Fatima',  NULL,       'fatima.k@gmail.com',       '$2b$12$abc123hashedpassword4',  '+971-501234567', 'Al Barsha, Dubai, UAE',               'UAE',     TRUE,  TRUE,  '2024-01-10 14:00:00+04:00', '2025-04-30 20:15:00+04:00'),
    ('Vikram',  'Rathore',  'vikram.r@rediffmail.com',  '$2b$12$abc123hashedpassword5',  '+91-9834567890', NULL,                                  'India',   TRUE,  FALSE, '2024-03-22 16:45:00+05:30', NULL),
    ('Lena',    'Mueller',  'lena.mueller@web.de',      NULL,                            '+49-16012345678','Kaiserswerther Str 42, Frankfurt, DE', 'Germany', TRUE,  TRUE,  '2024-07-18 08:30:00+02:00', '2025-05-10 11:00:00+02:00'),
    ('Aditya',  'Kapoor',   'aditya.kapoor@gmail.com',  '$2b$12$abc123hashedpassword7',  '+91-9845678901', '22 Park Street, Kolkata, WB 700016',  'India',   TRUE,  FALSE, '2025-01-05 10:20:00+05:30', '2025-01-05 10:25:00+05:30'),
    ('Meera',   'Nair',     'meera.nair@gmail.com',     '$2b$12$abc123hashedpassword8',  '+91-9756789012', '8 Residency Road, Kochi, KL 682011',  'India',   TRUE,  TRUE,  '2023-12-11 13:15:00+05:30', '2025-04-22 17:30:00+05:30'),
    ('Zaid',    'Al-Farsi', 'zaid.alfarsi@gmail.com',   '$2b$12$abc123hashedpassword9',  '+971-502345678', 'Jumeirah, Dubai, UAE',                'UAE',     TRUE,  TRUE,  '2024-09-01 09:00:00+04:00', '2025-05-01 08:45:00+04:00'),
    ('Sunita',  'Desai',    'sunita.desai@gmail.com',   '$2b$12$abc123hashedpasswrd10',  NULL,             '31 Ashram Road, Ahmedabad, GJ 380009', 'India',  TRUE,  TRUE,  '2022-05-30 15:00:00+05:30', '2025-03-15 14:20:00+05:30');


-- ────────────────────────────────────────────────────────────
-- INSERT INTO products
-- Edge cases included:
--   • description NULL (products 2,8) → not filled in yet
--   • original_price NULL             → never discounted
--   • stock_quantity = 0 (products 4,10) → out of stock
--   • sku NULL (product 8)            → seller hasn't set it
--   • is_listed FALSE (product 10)    → delisted product
--   • seller_id NULL (product 9)      → platform owned
-- ────────────────────────────────────────────────────────────

INSERT INTO products (product_name, description, category, price, original_price, stock_quantity, sku, seller_id, weight_kg, is_listed, created_at)
VALUES
    ('Samsung Galaxy S24 Ultra 256GB',    'Latest flagship with 200MP camera and S Pen. 1 year warranty.',  'Electronics', 109999.00, 124999.00, 42,  'SAM-S24U-256-BLK',  1,    0.233, TRUE,  '2024-02-01 10:00:00+05:30'),
    ('Nike Air Max 270 Running Shoes',     NULL,                                                             'Footwear',      8995.00,      NULL, 120, 'NIK-AM270-42-WHT',  4,    0.620, TRUE,  '2024-03-15 09:30:00+04:00'),
    ('The Pragmatic Programmer (2nd Ed.)', 'Classic software engineering book by Hunt and Thomas.',          'Books',          2499.00,   3200.00, 85,  'BOOK-PRAGPROG-2E',  1,    0.490, TRUE,  '2023-11-01 11:00:00+05:30'),
    ('Instant Pot Duo 7-in-1 6Qt',        'Electric pressure cooker. 7 functions in one pot.',              'Kitchen',        7500.00,   9999.00,  0,  'IPT-DUO-6QT-SLV',   6,    4.760, TRUE,  '2024-01-20 08:45:00+02:00'),
    ('Logitech MX Master 3S Mouse',       'High-precision wireless mouse for power users.',                 'Electronics',    9995.00,  10999.00, 60,  'LOG-MXM3S-GRY',     8,    0.141, TRUE,  '2024-04-10 14:00:00+05:30'),
    ('Organic Green Tea (100g)',           'Premium Darjeeling first flush green tea.',                      'Grocery',         549.00,      NULL, 500, 'GRO-TEA-GRN-100',   1,    0.110, TRUE,  '2023-09-05 10:30:00+05:30'),
    ('Sony WH-1000XM5 Headphones',        'Industry-leading noise cancellation. 30hr battery.',             'Electronics',   29990.00,  34990.00, 15,  'SNY-WH1000XM5-BLK', 4,    0.250, TRUE,  '2024-05-01 12:00:00+04:00'),
    ('Yoga Mat Premium (6mm)',             NULL,                                                             'Sports',          1299.00,      NULL, 200, NULL,               8,    0.900, TRUE,  '2024-02-28 09:00:00+05:30'),
    ('USB-C Hub 7-in-1 4K HDMI',         'Compatible with MacBook, Dell XPS, Surface.',                    'Electronics',    2799.00,   3499.00,  3,  'USB-HUB-7IN1-SLV',  NULL, 0.085, TRUE,  '2024-06-12 16:30:00+05:30'),
    ('Levi''s 511 Slim Fit Jeans',        'Classic slim fit. 99% cotton, 1% elastane.',                     'Clothing',       3499.00,   4299.00,  0,  'LEV-511-32-30-BLU', 6,    0.570, FALSE, '2023-07-10 08:00:00+02:00');


-- ────────────────────────────────────────────────────────────
-- INSERT INTO orders
-- Edge cases included:
--   • total_amount NULL (order 10)    → system capture failure
--   • payment_method NULL (order 8)   → async payment pending
--   • delivery_address NULL           → used saved address
--   • status 'cancelled' and 'returned' → terminal states
--   • updated_at NULL                 → status never changed
--   • estimated_delivery_date NULL    → not yet confirmed
-- ────────────────────────────────────────────────────────────

INSERT INTO orders (user_id, product_id, quantity, unit_price, total_amount, status, payment_method, delivery_address, ordered_at, updated_at, estimated_delivery_date)
VALUES
    (1,  1, 1, 109999.00, 109999.00, 'delivered',  'credit_card', '12 MG Road, Bangalore, KA 560001',      '2024-12-01 10:30:00+05:30', '2024-12-07 14:00:00+05:30', '2024-12-06'),
    (2,  5, 1,   9995.00,   9995.00, 'delivered',  'upi',         '45 Linking Road, Mumbai, MH 400050',    '2024-12-10 09:15:00+05:30', '2024-12-15 11:30:00+05:30', '2024-12-14'),
    (4,  7, 1,  29990.00,  29990.00, 'shipped',    'credit_card', 'Al Barsha, Dubai, UAE',                 '2025-01-05 20:00:00+04:00', '2025-01-07 08:00:00+04:00', '2025-01-12'),
    (1,  3, 2,   2499.00,   4998.00, 'delivered',  'debit_card',  NULL,                                    '2024-11-15 16:45:00+05:30', '2024-11-20 12:00:00+05:30', '2024-11-19'),
    (8,  8, 1,   1299.00,   1299.00, 'confirmed',  'upi',         '8 Residency Road, Kochi, KL 682011',    '2025-02-14 08:00:00+05:30', '2025-02-14 08:30:00+05:30', '2025-02-18'),
    (3,  2, 1,   8995.00,   8995.00, 'cancelled',  'net_banking', '7 Civil Lines, Bhopal, MP 462001',      '2023-04-20 11:00:00+05:30', '2023-04-21 09:00:00+05:30', NULL),
    (6,  4, 1,   7500.00,   7500.00, 'returned',   'credit_card', 'Kaiserswerther Str 42, Frankfurt, DE',  '2024-08-22 14:00:00+02:00', '2024-09-01 10:00:00+02:00', '2024-08-28'),
    (9,  1, 1, 109999.00, 109999.00, 'pending',    NULL,          'Jumeirah, Dubai, UAE',                  '2025-05-15 10:00:00+04:00', NULL,                        '2025-05-22'),
    (10, 6, 3,    549.00,   1647.00, 'delivered',  'upi',         '31 Ashram Road, Ahmedabad, GJ 380009',  '2024-10-05 07:30:00+05:30', '2024-10-09 16:00:00+05:30', '2024-10-08'),
    (2,  9, 1,   2799.00,      NULL, 'confirmed',  'emi',         '45 Linking Road, Mumbai, MH 400050',    '2025-03-01 13:20:00+05:30', '2025-03-01 13:25:00+05:30', '2025-03-06'),
    (7,  5, 2,   9995.00,  19990.00, 'shipped',    'credit_card', '22 Park Street, Kolkata, WB 700016',    '2025-04-02 09:00:00+05:30', '2025-04-04 11:00:00+05:30', '2025-04-08'),
    (5,  3, 1,   2499.00,   2499.00, 'pending',    'cod',         NULL,                                    '2025-05-10 17:00:00+05:30', NULL,                        NULL),
    (4,  6, 5,    549.00,   2745.00, 'delivered',  'credit_card', 'Al Barsha, Dubai, UAE',                 '2024-09-18 19:30:00+04:00', '2024-09-24 15:00:00+04:00', '2024-09-23'),
    (8,  7, 1,  29990.00,  29990.00, 'delivered',  'debit_card',  '8 Residency Road, Kochi, KL 682011',    '2024-07-30 10:00:00+05:30', '2024-08-05 12:00:00+05:30', '2024-08-04'),
    (1,  9, 2,   2799.00,   5598.00, 'cancelled',  'upi',         '12 MG Road, Bangalore, KA 560001',      '2025-02-20 14:00:00+05:30', '2025-02-21 09:00:00+05:30', NULL);


