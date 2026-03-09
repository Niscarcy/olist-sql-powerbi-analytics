# ETL Process

## Extract

The dataset was downloaded from Kaggle:
Brazilian E-Commerce Public Dataset by Olist.

## Transform

A Python script was used to clean problematic CSV records, especially in the reviews dataset.

Cleaning steps included:

- Removing multiline text
- Replacing quotes
- Normalizing whitespace

## Load

Data was loaded into PostgreSQL using DBeaver.