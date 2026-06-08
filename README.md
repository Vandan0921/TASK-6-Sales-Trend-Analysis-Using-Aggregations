# Task 6: Sales Trend Analysis Using Aggregations

**Elevate Labs Data Analyst Internship**

---

## Objective
Analyze monthly revenue and order volume from an online sales dataset using SQL aggregations.

## Tools Used
- **SQLite** (via Python's `sqlite3` module)
- **Python** (pandas for data loading, csv for export)

---

## Dataset
**File:** `Online_Sales_Data.csv`  
**Rows:** 240 transactions  
**Period:** January 2024 – August 2024  
**Key Columns Used:**
| Column | Description |
|--------|-------------|
| `transaction_id` | Unique order identifier |
| `order_date` | Date of purchase (YYYY-MM-DD) |
| `amount` | Total revenue from transaction |
| `units_sold` | Number of units sold |
| `product_category` | Product category |
| `region` | Geographic region |

---

## Files
```
task6/
├── sales_trend_analysis.sql   ← Main SQL script (all queries + interview Q&A)
├── online_sales.db            ← SQLite database (auto-generated from CSV)
├── results/
│   ├── monthly_revenue_orders.csv   ← Core result: monthly revenue & volume
│   ├── top3_months.csv              ← Top 3 months by revenue
│   ├── category_monthly.csv         ← Revenue breakdown by category
│   ├── region_monthly.csv           ← Revenue breakdown by region
│   └── avg_order_value.csv          ← Average order value per month
└── README.md
```

---

## Key Results

### Monthly Revenue & Order Volume
| Year-Month | Total Revenue | Total Orders | Units Sold |
|------------|--------------|-------------|-----------|
| 2024-01    | $14,548.32   | 31          | 68        |
| 2024-02    | $10,803.37   | 29          | 77        |
| 2024-03    | $12,849.24   | 31          | 82        |
| 2024-04    | $12,451.69   | 30          | 65        |
| 2024-05    | $8,455.49    | 31          | 60        |
| 2024-06    | $7,384.55    | 30          | 61        |
| 2024-07    | $6,797.08    | 31          | 53        |
| 2024-08    | $7,278.11    | 27          | 52        |

### Top 3 Months by Revenue
| Rank | Year-Month | Revenue    | Orders |
|------|------------|-----------|--------|
| 1    | 2024-01    | $14,548.32 | 31     |
| 2    | 2024-03    | $12,849.24 | 31     |
| 3    | 2024-04    | $12,451.69 | 30     |

### Key Observations
- **January 2024** was the highest-revenue month ($14,548.32)
- Revenue showed a declining trend from Jan → July, with slight recovery in August
- **Electronics** was consistently the top revenue-generating category
- **North America** led regional revenue in most months

---

## SQL Concepts Demonstrated

| Concept | Usage in Script |
|--------|----------------|
| `strftime('%Y/%m', date)` | Extracting year and month in SQLite |
| `GROUP BY` | Aggregating rows into monthly buckets |
| `SUM(amount)` | Calculating total revenue per group |
| `COUNT(DISTINCT transaction_id)` | Counting unique orders |
| `ORDER BY ... DESC` | Sorting results (revenue ranking) |
| `LIMIT 3` | Restricting to top N results |
| `WHERE date BETWEEN` | Filtering specific time periods |
| `COALESCE / NULL handling` | Documented in interview Q&A section |

---

## Interview Q&A (Summary)

1. **Group by month/year** → Use `strftime('%Y-%m', date)` in SQLite, or `EXTRACT()` in PostgreSQL/MySQL, then `GROUP BY` the extracted values.

2. **COUNT(\*) vs COUNT(DISTINCT col)** → `COUNT(*)` counts all rows including duplicates; `COUNT(DISTINCT col)` counts only unique non-NULL values.

3. **Monthly revenue** → `SUM(amount)` after grouping by year+month.

4. **Aggregate functions** → Functions like `SUM()`, `COUNT()`, `AVG()`, `MIN()`, `MAX()` that reduce multiple rows to a single value per group.

5. **NULL handling** → Aggregates skip NULLs by default. Use `COALESCE(col, 0)` to replace NULLs before aggregation if needed.

6. **GROUP BY vs ORDER BY** → `GROUP BY` collapses rows; `ORDER BY` sorts the final output. They serve different purposes.

7. **Top 3 months** → `GROUP BY` month → `ORDER BY total_revenue DESC` → `LIMIT 3`.
