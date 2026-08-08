CREATE DATABASE IF NOT EXISTS retail_sales_db;

USE retail_sales_db;
CREATE TABLE IF NOT EXISTS retail_sales (
    month INT,
    year INT,
    naics_code VARCHAR(20),
    kind_of_business VARCHAR(255),
    industry VARCHAR(255),
    sales DECIMAL(15,2)
);
USE retail_sales_db;

SELECT COUNT(*) AS total_rows
FROM retail_sales;
USE retail_sales_db;

-- 1. Total rows
SELECT COUNT(*) AS total_rows
FROM retail_sales;

-- 2. Check NULL values
SELECT
    SUM(month IS NULL) AS blank_month,
    SUM(year IS NULL) AS blank_year,
    SUM(naics_code IS NULL) AS blank_naics_code,
    SUM(kind_of_business IS NULL) AS blank_kind_of_business,
    SUM(industry IS NULL) AS blank_industry,
    SUM(sales IS NULL) AS blank_sales
FROM retail_sales;

-- 3. Check duplicate rows
SELECT
    COUNT(*) AS duplicate_rows
FROM (
    SELECT month, year, naics_code, kind_of_business, industry, sales
    FROM retail_sales
    GROUP BY month, year, naics_code, kind_of_business, industry, sales
    HAVING COUNT(*) > 1
) AS duplicates;

-- 4. Basic date range
USE retail_sales_db;

-- 1. Overall Sales Summary
SELECT
    COUNT(*) AS total_rows,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(sales), 2) AS average_sales,
    ROUND(MIN(sales), 2) AS minimum_sales,
    ROUND(MAX(sales), 2) AS maximum_sales
FROM retail_sales;


-- 2. Year-wise Sales
SELECT
    year,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY year
ORDER BY year;


-- 3. Industry-wise Sales
SELECT
    industry,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY industry
ORDER BY total_sales DESC;


-- 4. Top 10 Business Types by Sales
SELECT
    kind_of_business,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY kind_of_business
ORDER BY total_sales DESC
LIMIT 10;


-- 5. Monthly Sales
SELECT
    month,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY month
ORDER BY month;


-- 6. Year + Month Sales Trend
SELECT
    year,
    month,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;


-- 7. Top 10 Highest Sales Records
SELECT
    year,
    month,
    kind_of_business,
    industry,
    sales
FROM retail_sales
ORDER BY sales DESC
LIMIT 10;


-- 8. Lowest 10 Sales Records
SELECT
    year,
    month,
    kind_of_business,
    industry,
    sales
FROM retail_sales
ORDER BY sales ASC
LIMIT 10;
USE retail_sales_db;

-- 1. Year-wise Sales
SELECT
    year,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY year
ORDER BY year;


-- 2. Industry-wise Sales
SELECT
    industry,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY industry
ORDER BY total_sales DESC;


-- 3. Top 10 Business Types
SELECT
    kind_of_business,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY kind_of_business
ORDER BY total_sales DESC
LIMIT 10;


-- 4. Monthly Sales
SELECT
    month,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY month
ORDER BY month;
USE retail_sales_db;

-- Q1: Top-performing industry for each month in 2021

WITH monthly_sales_2021 AS (
    SELECT
        month,
        industry,
        SUM(sales) AS total_sales
    FROM retail_sales
    WHERE year = 2021
    GROUP BY month, industry
),
ranked_2021 AS (
    SELECT
        month,
        industry,
        total_sales,
        RANK() OVER (
            PARTITION BY month
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM monthly_sales_2021
)
SELECT
    month,
    industry,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_2021
WHERE sales_rank = 1
ORDER BY month;


-- Q2: Top-performing industry for each month in 2022

WITH monthly_sales_2022 AS (
    SELECT
        month,
        industry,
        SUM(sales) AS total_sales
    FROM retail_sales
    WHERE year = 2022
    GROUP BY month, industry
),
ranked_2022 AS (
    SELECT
        month,
        industry,
        total_sales,
        RANK() OVER (
            PARTITION BY month
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM monthly_sales_2022
)
SELECT
    month,
    industry,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_2022
WHERE sales_rank = 1
ORDER BY month;


-- Q3: Top-performing industry for each month in 2020

WITH monthly_sales_2020 AS (
    SELECT
        month,
        industry,
        SUM(sales) AS total_sales
    FROM retail_sales
    WHERE year = 2020
    GROUP BY month, industry
),
ranked_2020 AS (
    SELECT
        month,
        industry,
        total_sales,
        RANK() OVER (
            PARTITION BY month
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM monthly_sales_2020
)
SELECT
    month,
    industry,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_2020
WHERE sales_rank = 1
ORDER BY month;


-- Q4: Top-performing industry for each month in 2019

WITH monthly_sales_2019 AS (
    SELECT
        month,
        industry,
        SUM(sales) AS total_sales
    FROM retail_sales
    WHERE year = 2019
    GROUP BY month, industry
),
ranked_2019 AS (
    SELECT
        month,
        industry,
        total_sales,
        RANK() OVER (
            PARTITION BY month
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM monthly_sales_2019
)
SELECT
    month,
    industry,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_2019
WHERE sales_rank = 1
ORDER BY month;
USE retail_sales_db;


-- =========================================================
-- Q5. Which specific kind of business contributes the most
--     to total sales overall, and how does contribution
--     vary across industries?
-- =========================================================

SELECT
    industry,
    kind_of_business,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY industry, kind_of_business
ORDER BY total_sales DESC;


-- =========================================================
-- Q6. Seasonality in sales by industry, year and month
-- =========================================================

SELECT
    year,
    month,
    industry,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY year, month, industry
ORDER BY industry, year, month;


-- =========================================================
-- Q7. Sales distribution by NAICS code and industry
-- =========================================================

SELECT
    naics_code,
    industry,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY naics_code, industry
ORDER BY naics_code, total_sales DESC;


-- =========================================================
-- Q8. Outliers / sudden spikes or drops
--     Threshold = 1.5x
-- =========================================================

WITH monthly_sales AS (
    SELECT
        year,
        month,
        industry,
        SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY year, month, industry
),
comparison AS (
    SELECT
        year,
        month,
        industry,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY industry
            ORDER BY year, month
        ) AS previous_sales,
        LEAD(total_sales) OVER (
            PARTITION BY industry
            ORDER BY year, month
        ) AS next_sales
    FROM monthly_sales
)
SELECT
    year,
    month,
    industry,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(previous_sales, 2) AS previous_sales,
    ROUND(next_sales, 2) AS next_sales,
    CASE
        WHEN previous_sales IS NOT NULL
             AND total_sales > previous_sales * 1.5
            THEN 'Sudden Spike'

        WHEN previous_sales IS NOT NULL
             AND total_sales < previous_sales / 1.5
            THEN 'Sudden Drop'

        ELSE 'Normal'
    END AS sales_status
FROM comparison
WHERE
    previous_sales IS NOT NULL
    AND (
        total_sales > previous_sales * 1.5
        OR total_sales < previous_sales / 1.5
    )
ORDER BY year, month, industry;


-- =========================================================
-- Q9. Business categories with average monthly sales
--     above 10,000 million
-- =========================================================

SELECT
    kind_of_business,
    ROUND(AVG(sales), 2) AS average_monthly_sales
FROM retail_sales
GROUP BY kind_of_business
HAVING AVG(sales) > 10000
ORDER BY average_monthly_sales DESC;


-- =========================================================
-- Q10. Highest-selling business type in Automotive in 2022
-- =========================================================

SELECT
    kind_of_business,
    ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
WHERE industry = 'Automotive'
  AND year = 2022
GROUP BY kind_of_business
ORDER BY total_sales DESC
LIMIT 1;


-- =========================================================
-- Q11. Percentage contribution of each business type
--      to total Automotive sales in 2022
-- =========================================================

WITH business_sales AS (
    SELECT
        kind_of_business,
        SUM(sales) AS business_total
    FROM retail_sales
    WHERE industry = 'Automotive'
      AND year = 2022
    GROUP BY kind_of_business
),
automotive_total AS (
    SELECT
        SUM(sales) AS overall_total
    FROM retail_sales
    WHERE industry = 'Automotive'
      AND year = 2022
)
SELECT
    b.kind_of_business,
    ROUND(b.business_total, 2) AS business_total,
    ROUND(
        b.business_total
        / NULLIF(a.overall_total, 0) * 100,
        2
    ) AS contribution_percent
FROM business_sales b
CROSS JOIN automotive_total a
ORDER BY contribution_percent DESC;


-- =========================================================
-- Q12. Year-over-Year (YoY) growth rate for each industry
-- =========================================================

WITH yearly_sales AS (
    SELECT
        year,
        industry,
        SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY year, industry
),
previous_year AS (
    SELECT
        year,
        industry,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY industry
            ORDER BY year
        ) AS previous_year_sales
    FROM yearly_sales
)
SELECT
    year,
    industry,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(previous_year_sales, 2) AS previous_year_sales,
    ROUND(
        (total_sales - previous_year_sales)
        / NULLIF(previous_year_sales, 0) * 100,
        2
    ) AS yoy_growth_percent
FROM previous_year
ORDER BY industry, year;


-- =========================================================
-- Q13. Women's vs Men's clothing yearly total sales
-- =========================================================

SELECT
    year,

    ROUND(
        SUM(
            CASE
                WHEN kind_of_business = 'Women''s clothing stores'
                THEN sales
                ELSE 0
            END
        ), 2
    ) AS womens_clothing_sales,

    ROUND(
        SUM(
            CASE
                WHEN kind_of_business = 'Men''s clothing stores'
                THEN sales
                ELSE 0
            END
        ), 2
    ) AS mens_clothing_sales

FROM retail_sales
GROUP BY year
ORDER BY year;


-- =========================================================
-- Q14. Women's-to-Men's clothing sales ratio by year
-- =========================================================

WITH clothing_sales AS (
    SELECT
        year,

        SUM(
            CASE
                WHEN kind_of_business = 'Women''s clothing stores'
                THEN sales
                ELSE 0
            END
        ) AS womens_sales,

        SUM(
            CASE
                WHEN kind_of_business = 'Men''s clothing stores'
                THEN sales
                ELSE 0
            END
        ) AS mens_sales

    FROM retail_sales
    GROUP BY year
)
SELECT
    year,
    ROUND(womens_sales, 2) AS womens_sales,
    ROUND(mens_sales, 2) AS mens_sales,
    ROUND(
        womens_sales / NULLIF(mens_sales, 0),
        2
    ) AS womens_to_mens_ratio
FROM clothing_sales
ORDER BY year;


-- =========================================================
-- Q15. YTD cumulative sales for Women's clothing stores
--      in 2019, 2020, 2021 and 2022
-- =========================================================

WITH monthly_womens_sales AS (
    SELECT
        year,
        month,
        SUM(sales) AS monthly_sales
    FROM retail_sales
    WHERE kind_of_business = 'Women''s clothing stores'
      AND year IN (2019, 2020, 2021, 2022)
    GROUP BY year, month
)
SELECT
    year,
    month,
    ROUND(monthly_sales, 2) AS monthly_sales,
    ROUND(
        SUM(monthly_sales) OVER (
            PARTITION BY year
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2
    ) AS ytd_sales
FROM monthly_womens_sales
ORDER BY year, month;


-- =========================================================
-- Q16. Month-over-Month growth rate for Women's clothing
--      stores in 2022
-- =========================================================

WITH monthly_sales AS (
    SELECT
        month,
        SUM(sales) AS monthly_sales
    FROM retail_sales
    WHERE kind_of_business = 'Women''s clothing stores'
      AND year = 2022
    GROUP BY month
),
previous_month AS (
    SELECT
        month,
        monthly_sales,
        LAG(monthly_sales, 1) OVER (
            ORDER BY month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    month,
    ROUND(monthly_sales, 2) AS monthly_sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(
        (monthly_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0) * 100,
        2
    ) AS mom_growth_percent
FROM previous_month
ORDER BY month;
