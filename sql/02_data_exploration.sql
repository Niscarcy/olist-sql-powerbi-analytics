/*
Project: Olist E-Commerce Analytics
Author: Niscar Campos
Description: Exploratory analysis of the raw dataset
Database: PostgreSQL
Dataset: Brazilian E-Commerce Public Dataset by Olist
*/

-- =====================================================
-- 1. DATASET OVERVIEW
-- =====================================================

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM raw.customers
UNION ALL
SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM raw.payments
UNION ALL
SELECT 'products', COUNT(*) FROM raw.products
UNION ALL
SELECT 'sellers', COUNT(*) FROM raw.sellers
UNION ALL
SELECT 'reviews', COUNT(*) FROM raw.reviews
UNION ALL
SELECT 'geolocation', COUNT(*) FROM raw.geolocation
UNION ALL
SELECT 'category_translation', COUNT(*) FROM raw.category_translation
ORDER BY table_name;


-- =====================================================
-- 2. ORDER ANALYSIS
-- =====================================================

-- ORDER STATUS DISTRIBUTION

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM raw.orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- =====================================================
-- 3. PAYMENT ANALYSIS
-- =====================================================

-- PAYMENT METHODS

SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM raw.payments
GROUP BY payment_type
ORDER BY total_payments DESC;


-- =====================================================
-- 4. PRODUCT ANALYSIS
-- =====================================================

-- TOP PRODUCT CATEGORIES

SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM raw.products
GROUP BY product_category_name
ORDER BY total_products DESC
LIMIT 10;


-- REVENUE BY PRODUCT CATEGORY

SELECT 
    ct.product_category_name_english AS category,
    SUM(oi.price) AS revenue
FROM raw.order_items oi
JOIN raw.products p
    ON oi.product_id = p.product_id
LEFT JOIN raw.category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- 5. REVIEW ANALYSIS
-- =====================================================

-- REVIEW SCORE DISTRIBUTION

SELECT 
    review_score,
    COUNT(*) AS total_reviews
FROM raw.reviews
GROUP BY review_score
ORDER BY review_score;


-- AVERAGE REVIEW SCORE

SELECT 
    AVG(review_score) AS average_review_score
FROM raw.reviews;


-- =====================================================
-- 6. SELLER PERFORMANCE
-- =====================================================

-- TOP SELLERS BY REVENUE

SELECT 
    seller_id,
    COUNT(*) AS total_items_sold,
    SUM(price) AS revenue
FROM raw.order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- 7. CUSTOMER GEOGRAPHY
-- =====================================================

SELECT 
    customer_state,
    COUNT(*) AS total_customers
FROM raw.customers
GROUP BY customer_state
ORDER BY total_customers DESC;


-- =====================================================
-- 8. DELIVERY PERFORMANCE
-- =====================================================

-- AVERAGE DELIVERY TIME

SELECT 
    ROUND(
        AVG(order_delivered_customer_date::date - order_purchase_timestamp::date),2
    ) AS avg_delivery_days
FROM raw.orders
WHERE order_status = 'delivered';


-- DELIVERY VS REVIEW SCORE

SELECT 
    r.review_score,
    ROUND(
        AVG(o.order_delivered_customer_date::date - o.order_purchase_timestamp::date),2
    ) AS avg_delivery_days
FROM raw.orders o
JOIN raw.reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY r.review_score
ORDER BY r.review_score;


-- =====================================================
-- 9. BUSINESS METRICS
-- =====================================================

-- AVERAGE ORDER VALUE (AOV)

SELECT 
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price),2) AS total_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id),2) AS avg_order_value
FROM raw.order_items oi;


-- MONTHLY REVENUE TREND

SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price),2) AS revenue
FROM raw.orders o
JOIN raw.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;


-- REVENUE BY CUSTOMER STATE

SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price),2) AS revenue
FROM raw.orders o
JOIN raw.order_items oi
    ON o.order_id = oi.order_id
JOIN raw.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY revenue DESC;