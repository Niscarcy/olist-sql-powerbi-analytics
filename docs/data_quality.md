# Data Quality Report

## Reviews Dataset Issues

During ingestion of the reviews dataset several data quality issues were detected.

### Multiline text fields

Some review comments contained line breaks which caused CSV parsing issues during database ingestion.

Example:

"Ainda não posso opinar sobre o produto
pois não testei ainda"

### Quotes inside comments

Some comments contained quotation marks which broke the CSV structure.

### Solution

A Python preprocessing script was implemented to normalize the text:

- Replace line breaks with spaces
- Replace quotes with single quotes
- Normalize whitespace

This allowed the dataset to be safely loaded into PostgreSQL.