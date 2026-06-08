-- ============================================================
-- Task 6: Sales Trend Analysis Using Aggregations
-- Tool: SQLite
-- Dataset: online_sales (transaction_id, order_date, amount,
--          product_category, product_name, units_sold,
--          unit_price, region, payment_method)
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- SECTION 1: Table Inspection
-- ────────────────────────────────────────────────────────────

-- Preview table structure
SELECT * FROM online_sales LIMIT 5;

-- Count total rows
SELECT COUNT(*) AS total_records FROM online_sales;

-- Date range in the dataset
SELECT 
    MIN(order_date) AS earliest_date,
    MAX(order_date) AS latest_date
FROM online_sales;

-- Check for NULLs in key columns
-- (SUM/COUNT automatically ignore NULLs; checking explicitly is good practice)
SELECT 
    COUNT(*) AS total_rows,
    COUNT(transaction_id) AS non_null_transaction_id,
    COUNT(order_date)     AS non_null_order_date,
    COUNT(amount)         AS non_null_amount
FROM online_sales;


-- ────────────────────────────────────────────────────────────
-- SECTION 2: Monthly Revenue & Order Volume
-- (Core Task Requirement)
-- ────────────────────────────────────────────────────────────

/*
  EXPLANATION:
  - strftime('%Y', order_date) extracts the year  (SQLite equivalent of EXTRACT)
  - strftime('%m', order_date) extracts the month
  - SUM(amount)                  calculates total revenue
  - COUNT(DISTINCT transaction_id) counts unique orders
  - GROUP BY year + month aggregates rows into monthly buckets
  - ORDER BY year, month         sorts chronologically
*/

SELECT 
    CAST(strftime('%Y', order_date) AS INTEGER)  AS year,
    CAST(strftime('%m', order_date) AS INTEGER)  AS month,
    strftime('%Y-%m', order_date)                AS year_month,
    ROUND(SUM(amount), 2)                        AS total_revenue,
    COUNT(DISTINCT transaction_id)               AS total_orders,
    SUM(units_sold)                              AS total_units_sold
FROM online_sales
GROUP BY year, month
ORDER BY year, month;


-- ────────────────────────────────────────────────────────────
-- SECTION 3: Top 3 Months by Revenue
-- ────────────────────────────────────────────────────────────

/*
  EXPLANATION:
  - ORDER BY total_revenue DESC sorts highest revenue first
  - LIMIT 3 restricts output to top 3 months
*/

SELECT 
    strftime('%Y-%m', order_date)  AS year_month,
    ROUND(SUM(amount), 2)          AS total_revenue,
    COUNT(DISTINCT transaction_id) AS total_orders,
    SUM(units_sold)                AS total_units_sold
FROM online_sales
GROUP BY year_month
ORDER BY total_revenue DESC
LIMIT 3;


-- ────────────────────────────────────────────────────────────
-- SECTION 4: Monthly Revenue by Product Category
-- ────────────────────────────────────────────────────────────

SELECT 
    strftime('%Y-%m', order_date)  AS year_month,
    product_category,
    ROUND(SUM(amount), 2)          AS category_revenue,
    COUNT(DISTINCT transaction_id) AS orders
FROM online_sales
GROUP BY year_month, product_category
ORDER BY year_month, category_revenue DESC;


-- ────────────────────────────────────────────────────────────
-- SECTION 5: Monthly Revenue by Region
-- ────────────────────────────────────────────────────────────

SELECT 
    strftime('%Y-%m', order_date)  AS year_month,
    region,
    ROUND(SUM(amount), 2)          AS regional_revenue,
    COUNT(DISTINCT transaction_id) AS orders
FROM online_sales
GROUP BY year_month, region
ORDER BY year_month, regional_revenue DESC;


-- ────────────────────────────────────────────────────────────
-- SECTION 6: Average Order Value Per Month
-- ────────────────────────────────────────────────────────────

/*
  EXPLANATION:
  - Divides total revenue by number of distinct orders
  - Multiplying by 1.0 ensures float division in integer-heavy DBs
*/

SELECT 
    strftime('%Y-%m', order_date)                              AS year_month,
    ROUND(SUM(amount), 2)                                      AS total_revenue,
    COUNT(DISTINCT transaction_id)                             AS total_orders,
    ROUND(SUM(amount) * 1.0 / COUNT(DISTINCT transaction_id), 2) AS avg_order_value
FROM online_sales
GROUP BY year_month
ORDER BY year_month;


-- ────────────────────────────────────────────────────────────
-- SECTION 7: Specific Period Filter (Q1 2024)
-- ────────────────────────────────────────────────────────────

/*
  EXPLANATION:
  - WHERE clause filters rows to a specific time window
  - Demonstrates LIMIT usage for specific time periods
*/

SELECT 
    strftime('%Y-%m', order_date)  AS year_month,
    ROUND(SUM(amount), 2)          AS total_revenue,
    COUNT(DISTINCT transaction_id) AS total_orders
FROM online_sales
WHERE order_date >= '2024-01-01'
  AND order_date <  '2024-04-01'   -- Q1: Jan, Feb, Mar
GROUP BY year_month
ORDER BY year_month;


-- ════════════════════════════════════════════════════════════
-- INTERVIEW Q&A (as SQL comments)
-- ════════════════════════════════════════════════════════════

-- Q1: How do you group data by month and year?
--     Use strftime('%Y', date) and strftime('%m', date) in SQLite,
--     or EXTRACT(YEAR FROM date) / EXTRACT(MONTH FROM date) in PostgreSQL/MySQL.
--     Then GROUP BY both extracted values.

-- Q2: What's the difference between COUNT(*) and COUNT(DISTINCT col)?
--     COUNT(*)            counts all rows including duplicates and NULLs.
--     COUNT(DISTINCT col) counts only unique non-NULL values in that column.
--     Example: 5 rows where transaction_id repeats twice → COUNT(*) = 5, COUNT(DISTINCT) = 4

-- Q3: How do you calculate monthly revenue?
--     GROUP rows by year + month, then apply SUM(amount) to each group.

-- Q4: What are aggregate functions in SQL?
--     Functions that operate on a set of rows and return a single value per group:
--     SUM(), COUNT(), AVG(), MIN(), MAX() — always used with GROUP BY.

-- Q5: How to handle NULLs in aggregates?
--     SUM() and AVG() automatically skip NULLs.
--     COUNT(*) includes NULLs; COUNT(col) excludes them.
--     Use COALESCE(amount, 0) to replace NULLs with 0 before aggregating if needed.

-- Q6: What's the role of ORDER BY and GROUP BY?
--     GROUP BY  → collapses rows sharing the same key(s) into one row per group.
--     ORDER BY  → sorts the final result set; does NOT affect grouping.
--     They serve different purposes and are often used together.

-- Q7: How do you get the top 3 months by sales?
--     GROUP BY month, apply SUM(amount), ORDER BY total DESC, then LIMIT 3.
--     See SECTION 3 above for the full query.
