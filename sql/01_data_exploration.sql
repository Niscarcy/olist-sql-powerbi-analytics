/*
Project: Olist E-Commerce Analytics
Author: Niscar Campos
Description: Initial exploration of the raw dataset
Database: PostgreSQL
Dataset: Brazilian E-Commerce Public Dataset by Olist
*/

-- =====================================
-- DATASET OVERVIEW
-- =====================================

-- Total customers
SELECT COUNT(*) AS total_customers
FROM raw.customers;

-- Total orders
SELECT COUNT(*) AS total_orders
FROM raw.orders;

-- Total order items
SELECT COUNT(*) AS total_order_items
FROM raw.order_items;

-- Total products
SELECT COUNT(*) AS total_products
FROM raw.products;

-- Total sellers
SELECT COUNT(*) AS total_sellers
FROM raw.sellers;

-- =====================================
-- ORDER STATUS DISTRIBUTION
-- =====================================

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM raw.orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- =====================================
-- PAYMENT METHODS
-- =====================================

SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM raw.payments
GROUP BY payment_type
ORDER BY total_payments DESC;

-- =====================================
-- PRODUCT CATEGORIES
-- =====================================

SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM raw.products
GROUP BY product_category_name
ORDER BY total_products DESC
LIMIT 10;