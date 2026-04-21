-- ================================================
-- E-commerce Sales Analysis
-- Author: Parwez
-- Tool: MySQL Workbench
-- Dataset: Kaggle Online Retail Dataset
-- ================================================

USE ecommerce_db;

-- ================================================
-- Q1: Total Revenue
-- ================================================
SELECT 
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue 
FROM data 
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0 
AND unit_price > 0;

-- ================================================
-- Q2: Average Order Value (AOV)
-- ================================================
WITH avg_revenue_per_invoice AS (
    SELECT invoice_no,
           SUM(quantity * unit_price) AS total_revenue
    FROM data
    WHERE invoice_no NOT LIKE 'C%'
    AND quantity > 0
    AND unit_price > 0
    GROUP BY invoice_no
)
SELECT ROUND(AVG(total_revenue), 2) AS AOV
FROM avg_revenue_per_invoice;

-- ================================================
-- Q3: Best Performing Month by Revenue
-- ================================================
SELECT 
    DATE_FORMAT(invoice_date_, '%M %Y') AS month_,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM data
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY DATE_FORMAT(invoice_date_, '%M %Y')
ORDER BY total_revenue DESC
LIMIT 1;

-- ================================================
-- Q4: Top 10 Customers by Revenue
-- ================================================
SELECT customer_id,
       ROUND(SUM(quantity * unit_price), 2) AS total_revenue,
       RANK() OVER(ORDER BY SUM(quantity * unit_price) DESC) AS rank_
FROM data
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY customer_id
LIMIT 10;

-- ================================================
-- Q5: Revenue by Country with Percentage Share
-- ================================================
WITH most_revenue_by_country AS (
    SELECT country,
           ROUND(SUM(quantity * unit_price), 2) AS total_revenue,
           RANK() OVER(ORDER BY SUM(quantity * unit_price) DESC) AS rank_
    FROM data
    WHERE invoice_no NOT LIKE 'C%'
    AND quantity > 0
    AND unit_price > 0
    GROUP BY country
),
grand_total AS (
    SELECT SUM(total_revenue) AS grand_total 
    FROM most_revenue_by_country
)
SELECT country, total_revenue,
       ROUND(total_revenue / grand_total * 100, 2) AS percentage
FROM most_revenue_by_country, grand_total
ORDER BY total_revenue DESC;

-- ================================================
-- Q6: Top 10 Products by Revenue
-- ================================================
SELECT description,
       ROUND(SUM(quantity * unit_price), 2) AS total_revenue,
       RANK() OVER(ORDER BY SUM(quantity * unit_price) DESC) AS rank_
FROM data
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY description
LIMIT 10;

-- ================================================
-- Q7: Unique Customer Count
-- ================================================
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM data
WHERE invoice_no NOT LIKE 'C%';

-- ================================================
-- Q8: Cancelled Orders Percentage
-- Note: Zero cancellations found - data pre-cleaned
-- ================================================
SELECT 
    SUM(CASE WHEN invoice_no LIKE 'C%' THEN 1 ELSE 0 END) AS cancelled_orders,
    COUNT(DISTINCT invoice_no) AS total_invoices,
    ROUND(
        SUM(CASE WHEN invoice_no LIKE 'C%' THEN 1 ELSE 0 END) 
        / COUNT(DISTINCT invoice_no) * 100, 1
    ) AS cancellation_percentage
FROM data;

-- ================================================
-- Q9: Month over Month Revenue Trend
-- Note: Dataset covers December only - MoM not applicable
-- Query included for reference with full-year datasets
-- ================================================
WITH monthly_report AS (
    SELECT DATE_FORMAT(invoice_date_, '%M %Y') AS month_name,
           MIN(MONTH(invoice_date_)) AS month_order,
           ROUND(SUM(quantity * unit_price), 2) AS total_revenue
    FROM data
    WHERE invoice_no NOT LIKE 'C%'
    AND quantity > 0
    AND unit_price > 0
    GROUP BY DATE_FORMAT(invoice_date_, '%M %Y')
)
SELECT month_name,
       total_revenue,
       LAG(total_revenue) OVER(ORDER BY month_order ASC) AS prev_month_revenue,
       ROUND(total_revenue - LAG(total_revenue) OVER(ORDER BY month_order ASC), 2) AS difference
FROM monthly_report
ORDER BY month_order ASC;

-- ================================================
-- Q10: Customer Segmentation - VIP, Regular, Low
-- ================================================
SELECT customer_id,
       ROUND(SUM(quantity * unit_price), 2) AS total_revenue,
       CASE
           WHEN SUM(quantity * unit_price) > 10000 THEN 'VIP'
           WHEN SUM(quantity * unit_price) > 1000  THEN 'Regular'
           ELSE 'Low'
       END AS segment
FROM data
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY customer_id
ORDER BY total_revenue DESC;

-- ================================================
-- Q11: Customer Revenue Ranking
-- ================================================
WITH ranked_customers AS (
    SELECT customer_id,
           ROUND(SUM(quantity * unit_price), 2) AS total_revenue
    FROM data
    WHERE invoice_no NOT LIKE 'C%'
    AND quantity > 0
    AND unit_price > 0
    GROUP BY customer_id
)
SELECT customer_id,
       total_revenue,
       RANK() OVER(ORDER BY total_revenue DESC) AS revenue_rank
FROM ranked_customers
ORDER BY revenue_rank ASC;
