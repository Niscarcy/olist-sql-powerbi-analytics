# Data Dictionary

## Overview

This document describes the structure and meaning of the datasets used in the **Olist SQL + Power BI Analytics Project**.  
The goal of this data dictionary is to provide clear definitions of each table and column used in the analytical model.

The dataset comes from the **Brazilian E-Commerce Public Dataset by Olist** and represents transactions from an online marketplace.

---

## Tables included

The project uses the following main tables:

- customers
- orders
- order_items
- products
- payments
- reviews
- sellers

## Table: customers

Description:  
Contains information about customers who placed orders in the marketplace.

| Column | Data Type | Description |
|------|------|------|
| customer_id | varchar | Unique identifier for each customer |
| customer_unique_id | varchar | Unique customer identifier across orders |
| customer_zip_code_prefix | integer | Customer ZIP code prefix |
| customer_city | varchar | City where the customer lives |
| customer_state | varchar | Brazilian state of the customer |

## Table: orders

Description:  
Represents each purchase made in the marketplace.

| Column | Data Type | Description |
|------|------|------|
| order_id | varchar | Unique identifier of the order |
| customer_id | varchar | Foreign key referencing the customer |
| order_status | varchar | Current status of the order |
| order_purchase_timestamp | timestamp | Date and time when the order was placed |
| order_approved_at | timestamp | Date when the order was approved |
| order_delivered_carrier_date | timestamp | Date when the order was handed to the carrier |
| order_delivered_customer_date | timestamp | Date when the order was delivered to the customer |
| order_estimated_delivery_date | timestamp | Estimated delivery date |

## Table: order_items

Description:  
Contains the products included in each order.

| Column | Data Type | Description |
|------|------|------|
| order_id | varchar | Order identifier |
| order_item_id | integer | Sequential number of the item within the order |
| product_id | varchar | Identifier of the product |
| seller_id | varchar | Identifier of the seller |
| shipping_limit_date | timestamp | Deadline for shipping the product |
| price | numeric | Price of the product |
| freight_value | numeric | Shipping cost |

## Table: products

Description:  
Contains information about the products sold in the marketplace.  
Each record represents a product available for purchase.

| Column | Data Type | Description |
|------|------|------|
| product_id | varchar | Unique identifier for each product |
| product_category_name | varchar | Product category name in Portuguese |
| product_name_length | integer | Number of characters in the product name |
| product_description_length | integer | Number of characters in the product description |
| product_photos_qty | integer | Number of product images available |
| product_weight_g | integer | Product weight in grams |
| product_length_cm | integer | Product length in centimeters |
| product_height_cm | integer | Product height in centimeters |
| product_width_cm | integer | Product width in centimeters |

## Table: payments

Description:  
Contains payment information for each order.  
An order may have one or multiple payment records depending on how the payment was processed.

| Column | Data Type | Description |
|------|------|------|
| order_id | varchar | Identifier of the order associated with the payment |
| payment_sequential | integer | Sequential number of the payment within the order |
| payment_type | varchar | Payment method used by the customer |
| payment_installments | integer | Number of installments used to pay the order |
| payment_value | numeric | Total amount paid for the order |

## Table: reviews

Description:  
Contains customer reviews and ratings for completed orders.

| Column | Data Type | Description |
|------|------|------|
| review_id | varchar | Unique identifier of the review |
| order_id | varchar | Identifier of the order being reviewed |
| review_score | integer | Rating given by the customer (1 to 5) |
| review_comment_title | text | Title of the review written by the customer |
| review_comment_message | text | Detailed review message |
| review_creation_date | timestamp | Date when the review was created |
| review_answer_timestamp | timestamp | Date when the seller responded to the review |

## Table: sellers

Description:  
Contains information about sellers participating in the Olist marketplace.

| Column | Data Type | Description |
|------|------|------|
| seller_id | varchar | Unique identifier for each seller |
| seller_zip_code_prefix | integer | ZIP code prefix of the seller location |
| seller_city | varchar | City where the seller is located |
| seller_state | varchar | Brazilian state of the seller |