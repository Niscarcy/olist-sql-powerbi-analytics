# Project Architecture

This project analyzes the Brazilian E-Commerce dataset using a structured data pipeline.

## Data Layers

Raw Layer

- Raw CSV files from the Olist dataset.
- Stored in `/data/raw`.
- Loaded into PostgreSQL schema `raw`.

Cleaned Layer
- Data corrections applied before ingestion (e.g., fixing malformed review records).
- Stored in `/data/cleaned`.

Analytics Layer
- Business logic implemented through SQL views.
- Located in schema `analytics`.

Semantic Layer
- Star schema composed of fact and dimension tables.
- Optimized for BI tools such as Power BI.

Processed → Transformed data used for analysis



## Tools

- PostgreSQL
- Python
- Power BI
- VS Code