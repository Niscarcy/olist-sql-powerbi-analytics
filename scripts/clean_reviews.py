import csv
import os

input_file = "data/raw/olist_order_reviews_dataset.csv"
output_file = "data/cleaned/reviews_clean_sql_safe.csv"

expected_columns = 7

rows_read = 0
rows_written = 0
rows_skipped = 0
rows_normalized = 0

print("Starting SQL-safe data cleaning process...")

try:

    os.makedirs("data/cleaned", exist_ok=True)

    with open(input_file, encoding="utf-8") as infile, \
         open(output_file, "w", newline="", encoding="utf-8") as outfile:

        reader = csv.reader(infile)
        writer = csv.writer(
            outfile,
            delimiter=",",
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL
        )

        header = next(reader)
        writer.writerow(header)

        print("Header loaded.")
        print("Processing rows...")

        for i, row in enumerate(reader, start=2):

            rows_read += 1

            # Validate column count
            if len(row) != expected_columns:
                rows_skipped += 1
                print(f"[WARNING] Corrupted row at line {i}: {row}")
                continue

            # Remove completely empty rows
            if not any(field.strip() for field in row):
                rows_skipped += 1
                continue

            # Normalize review_comment_message
            comment_index = 4

            if row[comment_index]:

                original = row[comment_index]

                normalized = (
                    original
                    .replace('"', "'")      # replace problematic quotes
                    .replace("\n", " ")    # remove line breaks
                    .replace("\r", " ")
                    .replace("  ", " ")
                    .strip()
                )
                
                if normalized != original:
                    rows_normalized += 1

                row[comment_index] = normalized

            writer.writerow(row)
            rows_written += 1

            if rows_read % 10000 == 0:
                print(f"{rows_read} rows processed...")

    print("\nCleaning completed.")
    print("----------------------------")
    print(f"Rows read: {rows_read}")
    print(f"Rows written: {rows_written}")
    print(f"Rows skipped: {rows_skipped}")
    print(f"Rows normalized: {rows_normalized}")
    print(f"Output file: {output_file}")

except FileNotFoundError:
    print("ERROR: Input file not found.")

except Exception as e:
    print("Unexpected error:", e)