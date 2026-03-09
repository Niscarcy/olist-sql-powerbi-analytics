# Olist E-Commerce Analytics
SQL + Power BI Data Analytics Project

## Project Overview

This project analyzes the Brazilian E-Commerce Public Dataset by Olist.

The goal is to build an end-to-end analytics pipeline including:

- Data ingestion
- Data cleaning
- SQL analysis
- Data modeling
- Interactive dashboards

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
# Olist E-Commerce Analytics
SQL + Power BI Data Analytics Project


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

---

## Project Status

Project in progress.

Current progress:

- Data ingestion
- Data cleaning
- PostgreSQL database setup

Next steps:

- SQL exploratory analysis
- Data modeling
- Power BI dashboard

