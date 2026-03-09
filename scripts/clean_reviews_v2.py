import csv
import os

input_file = "data/raw/olist_order_reviews_dataset.csv"
output_file = "data/cleaned/reviews_clean_v2.csv"

expected_columns = 7

rows_read = 0
rows_written = 0
rows_skipped = 0
rows_fixed = 0

print("Starting advanced cleaning process...")

os.makedirs("data/cleaned", exist_ok=True)

with open(input_file, encoding="utf-8") as infile, \
     open(output_file, "w", newline="", encoding="utf-8") as outfile:

    reader = csv.reader(infile)
    writer = csv.writer(outfile)

    header = next(reader)
    writer.writerow(header)

    for i, row in enumerate(reader, start=2):

        rows_read += 1

        # Validate column count
        if len(row) != expected_columns:
            rows_skipped += 1
            print(f"Skipping corrupted row {i}")
            continue

        # Remove empty rows
        if not any(field.strip() for field in row):
            rows_skipped += 1
            continue

        # Clean review_comment_message
        comment_index = 4

        if row[comment_index]:

            original = row[comment_index]

            cleaned = (
                original
                .replace('"', "'")
                .replace("\n", " ")
                .replace("\r", " ")
                .replace(",", " ")
                .strip()
            )

            cleaned = " ".join(cleaned.split())

            if cleaned != original:
                rows_fixed += 1

            row[comment_index] = cleaned

        writer.writerow(row)
        rows_written += 1

        if rows_read % 10000 == 0:
            print(f"{rows_read} rows processed")

print("\nCleaning completed")
print("------------------------")
print("Rows read:", rows_read)
print("Rows written:", rows_written)
print("Rows skipped:", rows_skipped)
print("Rows fixed:", rows_fixed)
print("Output file:", output_file)