/*
Project: Olist E-Commerce Analytics
Author: Niscar Campos
Description: Analytics layer (business metrics for BI tools)
Database: PostgreSQL
Dataset: Brazilian E-Commerce Public Dataset by Olist
*/

CREATE SCHEMA IF NOT EXISTS analytics;

-- KPI SALES SUMMARY

CREATE OR REPLACE VIEW analytics.kpi_sales_summary AS
SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price),2) AS total_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id),2) AS avg_order_value
FROM raw.orders o
JOIN raw.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- MONTHLY SALES TREND

CREATE OR REPLACE VIEW analytics.sales_by_month AS
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


-- SALES BY CUSTOMER STATE

CREATE OR REPLACE VIEW analytics.sales_by_state AS
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

--  SALES BY PRODUCT CATEGORY

CREATE OR REPLACE VIEW analytics.sales_by_category AS
SELECT 
    ct.product_category_name_english AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price),2) AS revenue
FROM raw.order_items oi
JOIN raw.products p
    ON oi.product_id = p.product_id
LEFT JOIN raw.category_translation ct
    ON p.product_category_name = ct.product_category_name
JOIN raw.orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC;

-- SELLER PERFORMANCE

CREATE OR REPLACE VIEW analytics.seller_performance AS
SELECT 
    seller_id,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(price),2) AS revenue
FROM raw.order_items
GROUP BY seller_id
ORDER BY revenue DESC;
LIMIT 10;

-- AVERAGE DELIVERY TIME

CREATE OR REPLACE VIEW analytics.delivery_performance AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        AVG(o.order_delivered_customer_date::date - o.order_purchase_timestamp::date),2
    ) AS avg_delivery_days
FROM raw.orders o
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- CUSTOMER SATISFACTION SCORE

CREATE OR REPLACE VIEW analytics.review_score_summary AS
SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM raw.reviews
GROUP BY review_score
ORDER BY review_score;

-- REVENUE VS SALES VOLUME

CREATE OR REPLACE VIEW analytics.category_sales_volume AS
SELECT
    ct.product_category_name_english AS category,
    COUNT(*) AS total_items_sold
FROM raw.order_items oi
JOIN raw.products p
    ON oi.product_id = p.product_id
LEFT JOIN raw.category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY total_items_sold DESC;