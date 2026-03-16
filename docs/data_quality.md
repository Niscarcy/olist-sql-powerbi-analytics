# Data Quality Report

## Overview

During the data ingestion process several data quality issues were identified in the **reviews dataset**.  
These issues prevented a direct and reliable import of the CSV file into PostgreSQL.

This document describes the problems detected and the solutions implemented to ensure successful ingestion.

---

## Dataset Affected

Table: `reviews`

The dataset contains customer review information including:

- review_id  
- order_id  
- review_score  
- review_comment_title  
- review_comment_message  
- review_creation_date  
- review_answer_timestamp  

---

## Data Quality Issues

### 1. Multiline Text Fields

Some review comments contained **line breaks inside the text**, which caused CSV parsing errors during database ingestion.

Example:
"Ainda não posso opinar sobre o produto
pois não testei ainda"


These line breaks caused rows to be incorrectly interpreted as multiple records.

---

### 2. Quotation Marks Inside Comments

Some comments contained quotation marks inside the text field, which broke the CSV structure and caused ingestion failures.

Example:
"Produto ""excelente"", recomendo!"


This resulted in malformed records during import.

---

## Solution Implemented

A **Python preprocessing script** was developed to normalize the text fields before loading the dataset into PostgreSQL.

The script performs the following operations:

- Replace line breaks with spaces
- Replace double quotes with single quotes
- Normalize whitespace characters
- Ensure consistent CSV formatting

After preprocessing, the cleaned dataset was successfully loaded into the database.

---

## Result

After applying the preprocessing step:

- All records were successfully ingested
- The final dataset contains **99,224 review records**
- No data corruption or row misalignment occurred

This preprocessing step ensures reliable ingestion and preserves the integrity of the review comments.

---

## Additional Data Standardization

Product categories in the original dataset are stored in **Portuguese**.

To improve readability for analytics and reporting, the dataset includes a translation table:
product_category_name_translation

This table was used to map product categories from Portuguese to **English**, enabling clearer analysis and dashboard visualization.