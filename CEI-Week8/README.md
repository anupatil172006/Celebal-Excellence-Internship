# 🛒 E-Commerce Analytics System

An end-to-end e-commerce data analytics system built using **Python, Pandas, SQLite, and SQL**.

The project demonstrates the complete data analytics workflow starting from synthetic data generation and data quality validation to relational database loading, advanced SQL analytics, customer segmentation, cohort retention analysis, and command-line reporting.

---

## 📌 Project Overview

The **E-Commerce Analytics System** is designed to process and analyze realistic e-commerce order data.

The system intentionally introduces data inconsistencies into generated datasets and then applies data cleaning and validation techniques using Pandas.

The cleaned data is loaded into a SQLite relational database where multiple SQL queries are used to generate business insights.

The project also includes a Python-based command-line reporting tool that allows users to generate dynamic reports directly from the terminal.

---

## 🎯 Objective

The main objectives of this project are to:

- Generate realistic e-commerce datasets using Python.
- Introduce intentional data inconsistencies.
- Clean and validate datasets using Pandas.
- Validate relationships between multiple tables.
- Maintain referential integrity using primary and foreign keys.
- Store cleaned data in a relational SQLite database.
- Perform business analytics using SQL.
- Implement JOINs and aggregations.
- Implement CTEs and window functions.
- Perform cohort and retention analysis.
- Perform customer segmentation using RFM-style metrics.
- Build a command-line reporting tool.
- Handle important edge cases and invalid inputs.
- Document and organize the complete project for GitHub submission.

---

# 🏗️ System Architecture

```text
                    ┌─────────────────────────┐
                    │   Python Data Generator │
                    │  Faker + Random + Pandas │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │       Raw CSV Data      │
                    │        data/raw/        │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │    Pandas Data Cleaning │
                    │     & Data Validation   │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │     Cleaned CSV Data    │
                    │      data/cleaned/      │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │      SQLite Database    │
                    │       ecommerce.db      │
                    └────────────┬────────────┘
                                 │
                ┌────────────────┼─────────────────┐
                │                │                 │
                ▼                ▼                 ▼
        ┌──────────────┐ ┌──────────────┐ ┌───────────────┐
        │ Aggregations │ │   Advanced   │ │    Cohort &   │
        │  & JOINs     │ │ SQL / CTEs   │ │   Retention   │
        └──────┬───────┘ └──────┬───────┘ └───────┬───────┘
               │                │                 │
               └────────────────┼─────────────────┘
                                ▼
                    ┌─────────────────────────┐
                    │ Customer Segmentation   │
                    │      RFM Analysis       │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │   Python CLI Reporting  │
                    │        Tool             │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │    Business Reports     │
                    │ output/sample_reports/  │
                    └─────────────────────────┘