/*
Project: Olist E-Commerce Analytics
Author: Niscar Campos
Description: Creation of Star Schema (Fact & Dimension Tables)
Layer: Analytics
*/

-- =========================================
-- DIMENSION TABLES
-- =========================================


-- Customers Dimension
CREATE TABLE analytics.dim_customers (

    customer_id VARCHAR PRIMARY KEY,
    customer_unique_id VARCHAR,
    customer_city VARCHAR,
    customer_state VARCHAR

);


-- Products Dimension
CREATE TABLE analytics.dim_products (

    product_id VARCHAR PRIMARY KEY,
    product_category_name_english VARCHAR,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT

);


-- Sellers Dimension
CREATE TABLE analytics.dim_sellers (

    seller_id VARCHAR PRIMARY KEY,
    seller_city VARCHAR,
    seller_state VARCHAR

);


-- Date Dimension
CREATE TABLE analytics.dim_date (

    date_key DATE PRIMARY KEY,
    year INT,
    month INT,
    month_name VARCHAR,
    quarter INT,
    day_of_week VARCHAR

);


-- Order Status Dimension
CREATE TABLE analytics.dim_order_status (

    status_id INT PRIMARY KEY,
    status_group VARCHAR

);

-- Populate order status
INSERT INTO analytics.dim_order_status VALUES
(1,'Completed'),
(2,'In Progress'),
(3,'Canceled');


-- =========================================
-- FACT TABLE
-- =========================================

CREATE TABLE analytics.fact_sales (

    fact_sales_id BIGSERIAL PRIMARY KEY,
    order_id VARCHAR,
    customer_id VARCHAR NOT NULL,
    product_id VARCHAR NOT NULL,
    seller_id VARCHAR NOT NULL,
    date_key DATE NOT NULL,
    status_id INT NOT NULL,
    price DECIMAL,
    freight_value DECIMAL,
    total_sale_value DECIMAL,

    -- Foreign Keys

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES analytics.dim_customers(customer_id),

    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES analytics.dim_products(product_id),

    CONSTRAINT fk_seller
        FOREIGN KEY (seller_id)
        REFERENCES analytics.dim_sellers(seller_id),

    CONSTRAINT fk_date
        FOREIGN KEY (date_key)
        REFERENCES analytics.dim_date(date_key),

    CONSTRAINT fk_status
        FOREIGN KEY (status_id)
        REFERENCES analytics.dim_order_status(status_id)

);


-- =========================================
-- LOAD DIMENSION TABLES
-- =========================================


INSERT INTO analytics.dim_customers
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM raw.customers;


INSERT INTO analytics.dim_products
SELECT DISTINCT
    p.product_id,
    t.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM raw.products p
LEFT JOIN raw.product_category_name_translation t
ON p.product_category_name = t.product_category_name;


INSERT INTO analytics.dim_sellers
SELECT DISTINCT
    seller_id,
    seller_city,
    seller_state
FROM raw.sellers;

INSERT INTO analytics.dim_date
SELECT DISTINCT
    order_purchase_timestamp::date AS date_key,
    EXTRACT(YEAR FROM order_purchase_timestamp),
    EXTRACT(MONTH FROM order_purchase_timestamp),
    TO_CHAR(order_purchase_timestamp,'Month'),
    EXTRACT(QUARTER FROM order_purchase_timestamp),
    TO_CHAR(order_purchase_timestamp,'Day')
FROM raw.orders;

-- CREATE CALENDAR FOR DATES WITHOUT SALES

INSERT INTO analytics.dim_date
SELECT
    d::date AS date_key,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(MONTH FROM d) AS month,
    TO_CHAR(d,'FMMonth') AS month_name,
    EXTRACT(QUARTER FROM d) AS quarter,
    TO_CHAR(d,'FMDay') AS day_of_week
FROM generate_series(
    (SELECT MIN(order_purchase_timestamp)::date FROM raw.orders),
    (SELECT MAX(order_purchase_timestamp)::date FROM raw.orders),
    interval '1 day'
) d
WHERE NOT EXISTS (
    SELECT 1
    FROM analytics.dim_date dd
    WHERE dd.date_key = d::date
);


-- =========================================
-- LOAD FACT TABLE
-- =========================================


INSERT INTO analytics.fact_sales (

    order_id,
    customer_id,
    product_id,
    seller_id,
    date_key,
    status_id,
    price,
    freight_value,
    total_sale_value

)

SELECT

    oi.order_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,

    o.order_purchase_timestamp::date,

    CASE
        WHEN o.order_status = 'delivered' THEN 1
        WHEN o.order_status IN ('shipped','processing','approved','created') THEN 2
        ELSE 3
    END AS status_id,

    oi.price,
    oi.freight_value,

    (oi.price + oi.freight_value) AS total_sale_value

FROM raw.order_items oi
JOIN raw.orders o
ON oi.order_id = o.order_id;

-- =========================================
-- VERIFY TABLE CREATION
-- =========================================

/*
Data Warehouse Validation Checks

These queries validate:
- Table creation
- Data completeness
- Referential integrity
- Metric calculations
- Duplicate detection
*/

-- Verify that all tables exist in analytics schema

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'analytics'
ORDER BY table_name;

-- =========================================
-- VERIFY TABLE STRUCTURE
-- =========================================

-- Verify fact table columns and data types

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'analytics'
AND table_name = 'fact_sales';

-- =========================================
-- VERIFY ROW COUNTS
-- =========================================
-- Check that dimension and fact tables contain data

SELECT 'dim_customers' AS table_name, COUNT(*) FROM analytics.dim_customers
UNION ALL
SELECT 'dim_products', COUNT(*) FROM analytics.dim_products
UNION ALL
SELECT 'dim_sellers', COUNT(*) FROM analytics.dim_sellers
UNION ALL
SELECT 'dim_date', COUNT(*) FROM analytics.dim_date
UNION ALL
SELECT 'dim_order_status', COUNT(*) FROM analytics.dim_order_status
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM analytics.fact_sales;

-- =========================================
-- VERIFY NULL VALUES IN FACT TABLE KEYS
-- =========================================

-- Ensure there are no NULL values in foreign keys

SELECT *
FROM analytics.fact_sales
WHERE customer_id IS NULL
   OR product_id IS NULL
   OR seller_id IS NULL
LIMIT 10;

-- =========================================
-- VERIFY DIMENSION RELATIONSHIPS
-- =========================================

-- Check for orphan records in fact table (date dimension)

SELECT COUNT(*) AS missing_dates
FROM analytics.fact_sales f
LEFT JOIN analytics.dim_date d
ON f.date_key = d.date_key
WHERE d.date_key IS NULL;

-- Check for orphan records in fact table (product dimension)

SELECT COUNT(*) AS missing_products
FROM analytics.fact_sales f
LEFT JOIN analytics.dim_products p
ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Check for orphan records in fact table (customer dimension)

SELECT COUNT(*) AS missing_customers
FROM analytics.fact_sales f
LEFT JOIN analytics.dim_customers c
ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- =========================================
-- VERIFY SALES CALCULATION
-- =========================================

-- Validate that total_sale_value = price + freight_value

SELECT *
FROM analytics.fact_sales
WHERE total_sale_value <> price + freight_value
LIMIT 10;

-- =========================================
-- VERIFY DUPLICATE FACT RECORDS
-- =========================================

-- Ensure there are no duplicated order-product combinations

SELECT order_id, product_id, COUNT(*) AS duplicates
FROM analytics.fact_sales
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;

-- =========================================
-- VERIFY ALL DAYS IN DIM_DATE
-- =========================================

SELECT
    MIN(date_key),
    MAX(date_key),
    COUNT(*),
    MAX(date_key) - MIN(date_key) + 1 AS expected_days
FROM analytics.dim_date;

-- =========================================
-- END OF STAR SCHEMA CREATION
-- =========================================



