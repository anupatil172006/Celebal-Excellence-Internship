# CEI Week 7 - Delta Lake MERGE Implementation

## Overview

This repository contains the Week 7 assignment completed as part of the **Celebal Technologies Excellence Internship (CEI)**. The assignment demonstrates data exploration, data cleaning, Spark DataFrame conversion, and incremental data processing using **Delta Lake MERGE** in **Databricks**.

---

## Objectives

### Part 1: Data Exploration and Cleaning (Pandas)

- Load a CSV dataset into a Pandas DataFrame.
- Explore the dataset (head, shape, columns, data types).
- Identify and handle missing values.
- Remove duplicate records.
- Filter rows and select required columns.
- Create derived columns.
- Save the cleaned dataset as a new CSV file.

### Part 2: Delta Lake MERGE (PySpark & Delta Lake)

- Convert the cleaned Pandas DataFrame into a Spark DataFrame.
- Create a Delta table.
- Perform basic data cleaning.
- Create an incremental dataset.
- Apply the Delta Lake **MERGE** operation.
- Validate updates and newly inserted records.

---

## Technologies Used

- Python
- Pandas
- Apache Spark (PySpark)
- Delta Lake
- Databricks

---

## Project Structure

```text
CEI-Week7/
│
├── data/
│   ├── customer_master.csv
│   └── customer_incremental.csv
│
├── notebooks/
│   └── Week7_Assignment.ipynb
│
├── screenshots/
│   ├── data_loading/
│   ├── data_cleaning/
│   ├── scd1/
│   ├── scd2/
│   ├── validation/
│   └── final_output/
│
├── report/
│   └── assignment_summary.pdf
│
└── README.md
```

---

## Tasks Performed

### Data Exploration

- Loaded the Superstore dataset.
- Displayed the first and last records.
- Checked dataset dimensions.
- Inspected column names and data types.

### Data Cleaning

- Checked missing values.
- Removed duplicate records.
- Filtered required records.
- Selected important columns.
- Created the following derived columns:
  - Unit_Price
  - Total_Amount
- Saved the cleaned dataset.

### Spark & Delta Lake

- Converted the Pandas DataFrame into a Spark DataFrame.
- Created a Delta table.
- Standardized column names for Delta compatibility.
- Created an incremental dataset.
- Executed the Delta Lake MERGE operation.
- Validated updated and inserted records.

---

## Learning Outcomes

Through this assignment, I learned:

- Data exploration using Pandas.
- Data cleaning techniques.
- Spark DataFrame operations.
- Delta Lake fundamentals.
- Incremental data processing.
- MERGE operation in Delta Lake.
- Data validation after MERGE.
- Working with Databricks notebooks.

---

## Output

The project includes:

- Jupyter Notebook (.ipynb)
- Cleaned CSV dataset
- Incremental CSV dataset
- Screenshots of each major step
- Assignment Summary PDF

---

## Author

**Anushka Patil**

Celebal Technologies Excellence Internship (CEI)