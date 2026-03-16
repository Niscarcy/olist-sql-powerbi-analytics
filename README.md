# Olist E-Commerce Analytics
SQL + Power BI Data Analytics Project

## Project Overview

This project analyzes the Brazilian E-Commerce Public Dataset by Olist.

The goal is to build an end-to-end analytics pipeline including:

- Data ingestion
- Data cleaning
- Exploratory data analysis (EDA)
- Data modeling (Star Schema)
- Business analytics queries
- Interactive dashboard development

The project simulates a real-world analytics workflow using PostgreSQL and Power BI.

---

## Tools Used

- PostgreSQL
- DBeaver
- Python
- Power BI
- VS Code
- GitHub

---

## Project Structure

project-root/
│
├── data/
│ ├── raw/
│ ├── cleaned/
│ └── processed/
│
├── sql/
│ ├── 01_schema_setup.sql
│ ├── 02_data_exploration.sql
│ └── 03_analytics_model.sql
  └── 04_star_schema.sql
│
├── docs/
│ ├── data_dictionary.md
│ ├── data_quality.md
│ ├── EDA.md
│ ├── analytics_layer.md
│ └── project_architecture.md
│ └── star_schema.md
│
└── dashboards/
└── olist_powerbi.pbix

---

## Data Pipeline

Raw data → Cleaning (Python) → PostgreSQL → SQL analysis → Power BI dashboard

---

## Data Ingestion Challenge

During the ingestion process, the `reviews` dataset presented issues due to:

- multiline text fields
- quotation marks inside comments
- CSV parsing errors

A Python preprocessing script was created to normalize the text fields before loading the data into PostgreSQL.

This ensured a successful and complete ingestion of **99,224 review records**.

---

## Dataset

Source:

Brazilian E-Commerce Public Dataset by Olist  
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The dataset contains information about:

- customers
- orders
- order items
- products
- sellers
- payments
- reviews
- geolocation

---

## SQL Exploratory Analysis

The project includes an exploratory analysis of the Olist dataset using PostgreSQL.

Key analyses performed:

- Dataset overview and table sizes
- Order status distribution
- Payment method analysis
- Product category performance
- Customer geographic distribution
- Review score distribution
- Delivery time analysis
- Revenue by category
- Monthly revenue trends
- Average order value (AOV)

All queries are documented in: sql/02_data_exploration.sql

## Data Modeling

A **Star Schema** was designed to support business intelligence and dashboard analysis.

Key characteristics:

- Fact table at the **order-item level**
- Dimension tables for customers, products, sellers and time
- Optimized structure for BI tools

### Fact Table Grain

Each row represents a **single product item sold in an order**.

This design prevents revenue duplication caused by joins with tables that contain multiple records per order (e.g., payments).

The fact table also includes a **pre-calculated metric**:
total_sale_value
to simplify analytical queries and improve BI performance.


## Power BI Dashboard

An interactive Power BI dashboard was developed to analyze business performance.

### Executive Overview

Key KPIs:

- GMV (Gross Merchandise Value)
- Total Orders
- Average Order Value (AOV)
- Month-over-Month Growth

Visualizations include:

- Monthly GMV trend
- Top product categories by revenue
- Geographic sales distribution across Brazilian states

---

## Project Status

Project in progress.

Completed stages:

✔ Data ingestion  
✔ Data cleaning  
✔ PostgreSQL database setup  
✔ SQL exploratory analysis  
✔ Data modeling (Star Schema)  
✔ Executive dashboard in Power BI

Next steps:

- Customer analytics dashboard
- Seller performance analysis
- Advanced business insights

---

## Author

**Niscar Campos**  
Industrial Engineer | Data Analyst  

Tools: SQL, Python, Power BI, Data Modeling, Analytics