# E-commerce Sales Analysis — SQL Portfolio Project

## Project Summary

This project is an end-to-end SQL analysis of a real e-commerce dataset sourced from Kaggle. The dataset contains transactional data from a UK-based online retailer. Using MySQL Workbench, I explored, cleaned, and analysed 24,467 records to answer 11 business questions across revenue performance, customer behaviour, and product analysis.

All SQL queries are available in `analysis.sql`.

---

## Tools and Technologies

- **Database:** MySQL Workbench
- **Language:** SQL
- **Techniques:** CTEs, Window Functions (RANK, LAG), CASE statements, Date Functions, Aggregate Functions, Subqueries, Data Cleaning

---

## Dataset

| Property | Detail |
| --- | --- |
| Source | Kaggle — Online Retail Dataset |
| Rows | 24,467 transactions |
| Format | Single flat table (CSV) |
| Columns | invoice_no, stock_code, description, quantity, invoice_date, unit_price, customer_id, country |

---

## Data Preparation

The dataset required cleaning before analysis could begin. The invoice_date column was stored as plain text after the CSV import and had to be converted to a proper DATETIME format using STR_TO_DATE(). All column names were renamed to lowercase snake_case for consistency.

All revenue queries exclude rows where quantity or unit_price is zero or negative to ensure figures reflect genuine transactions only.

**Two notable findings discovered during preparation:**

- The dataset contains December 2011 data only, making month-over-month trend analysis not applicable
- No cancelled orders were present — the dataset had been pre-cleaned before publication on Kaggle

---

## Business Questions Answered

| # | Question | Technique Used |
| --- | --- | --- |
| 1 | Total revenue generated | SUM, WHERE filters |
| 2 | Average Order Value (AOV) | CTE + AVG |
| 3 | Best performing month by revenue | DATE_FORMAT, GROUP BY, LIMIT |
| 4 | Top 10 customers by revenue | RANK, GROUP BY, LIMIT |
| 5 | Revenue by country with percentage share | Double CTE, RANK, percentage formula |
| 6 | Top 10 products by revenue | RANK, GROUP BY, LIMIT |
| 7 | Unique customer count | COUNT DISTINCT |
| 8 | Cancelled orders percentage | SUM CASE WHEN, COUNT DISTINCT |
| 9 | Month over Month revenue trend | CTE + LAG window function |
| 10 | Customer segmentation — VIP, Regular, Low | CASE WHEN, GROUP BY |
| 11 | Customer revenue ranking | CTE + RANK window function |

---

## Key Findings

- Average order value of £407.49 is consistent with a wholesale or B2B customer base placing bulk orders rather than individual consumer retail
- The United Kingdom accounts for the substantial majority of total revenue, confirming the domestic focus of the business
- No cancelled orders were present in the dataset — it was pre-cleaned prior to Kaggle publication
- Single-month data coverage (December 2011) limits time-series and trend analysis
- Customer spend is heavily skewed, with a small group of high-value accounts driving a disproportionate share of revenue

---

## How to Run This Project

1. Download the dataset from Kaggle: https://www.kaggle.com/datasets/carrie1/ecommerce-data
2. Create a database called `ecommerce_db` in MySQL Workbench
3. Import the CSV file using the Table Data Import Wizard
4. Rename columns to lowercase using `ALTER TABLE RENAME COLUMN`
5. Create a clean date column using `ALTER TABLE` and `STR_TO_DATE()`
6. Run the queries from `analysis.sql`

---

## Repository Structure

```
ecommerce-sales-analysis-sql/
├── README.md         → project overview and findings
└── analysis.sql      → all 11 SQL queries
```

---

## About

Aspiring Data Analyst based in Dubai. Currently building a portfolio of SQL projects and working toward an entry-level role in data analysis, business intelligence, or MIS. Open to opportunities across the UAE.

---

*Tools: MySQL Workbench | Dataset: Kaggle Online Retail*
