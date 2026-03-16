# Project Architecture

This project analyzes the **Brazilian E-Commerce Public Dataset by Olist** using a structured data pipeline that separates the data processing stages into multiple layers.

The architecture follows a common analytics workflow used in modern data projects.

---

## Data Pipeline Overview

Raw Data → Data Cleaning → PostgreSQL Database → SQL Analytics → Power BI Dashboard


Each stage of the pipeline has a specific responsibility to ensure data quality, maintainability, and analytical performance.

---

## Data Layers

### Raw Layer

The **raw layer** contains the original dataset files.

Characteristics:

- Raw CSV files from the Olist dataset
- No transformations applied
- Stored in: /data/raw


These files are imported into the **PostgreSQL `raw` schema**.

---

### Cleaned Layer

Before loading the data into the database, some datasets required preprocessing.

For example:

- fixing malformed review records
- handling multiline text fields
- normalizing quotation marks in comments

The cleaned datasets are stored in:

These files are imported into the **PostgreSQL `raw` schema**.

---

### Cleaned Layer

Before loading the data into the database, some datasets required preprocessing.

For example:

- fixing malformed review records
- handling multiline text fields
- normalizing quotation marks in comments

The cleaned datasets are stored in: /data/cleaned


This preprocessing step ensures reliable ingestion into PostgreSQL.

---

### Analytics Layer

The **analytics layer** contains SQL queries and views that implement business logic.

These queries perform tasks such as:

- revenue calculations
- monthly sales aggregation
- product category analysis
- geographic sales analysis

The SQL logic is implemented in the PostgreSQL schema: analytics


---

### Semantic Layer

The semantic layer contains a **Star Schema data model** designed for business intelligence and reporting.

This layer includes:

- fact tables
- dimension tables
- optimized relationships for analytical queries

The semantic model is optimized for BI tools such as **Power BI**.

---

### Processed Data

The processed data represents the **final transformed dataset** used for analytical queries and dashboards.

It includes:

- cleaned and validated data
- transformed business metrics
- aggregated datasets for reporting

---

## Tools Used

The following tools were used to build the analytics pipeline:

- **PostgreSQL** — database and SQL analytics
- **Python** — data cleaning and preprocessing
- **Power BI** — interactive dashboards
- **VS Code** — development environment
- **DBeaver** — database management
