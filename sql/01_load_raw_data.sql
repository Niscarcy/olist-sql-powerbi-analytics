/*
========================================================
Project: Olist E-Commerce Analytics
Author: Niscar Campos
Description: Load raw CSV datasets into PostgreSQL tables
Dataset: Brazilian E-Commerce Public Dataset by Olist
========================================================

IMPORTANT
---------
Before running this script:

1. Download the dataset from Kaggle:
   https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

2. Place the CSV files inside the folder:

   data/raw/

3. Update file paths if necessary depending on your local environment.
*/


-- ======================================
-- LOAD CUSTOMERS
-- ======================================

COPY raw.customers
FROM 'data/raw/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- LOAD ORDERS
-- ======================================

COPY raw.orders
FROM 'data/raw/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- LOAD ORDER ITEMS
-- ======================================

COPY raw.order_items
FROM 'data/raw/olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- LOAD PAYMENTS
-- ======================================

COPY raw.payments
FROM 'data/raw/olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- LOAD PRODUCTS
-- ======================================

COPY raw.products
FROM 'data/raw/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- LOAD SELLERS
-- ======================================

COPY raw.sellers
FROM 'data/raw/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- LOAD REVIEWS
-- ======================================

COPY raw.reviews
FROM 'data/raw/olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- LOAD GEOLOCATION
-- ======================================

COPY raw.geolocation
FROM 'data/raw/olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- LOAD PRODUCT CATEGORY TRANSLATION
-- ======================================

COPY raw.category_translation
FROM 'data/raw/product_category_name_translation.csv'
DELIMITER ','
CSV HEADER;