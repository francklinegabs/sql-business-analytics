-- Q1. How has revenue developed year over year?
-- Annual revenue, invoice count, average order value and YoY growth (window function LAG).
WITH yearly AS (
    SELECT strftime('%Y', InvoiceDate)          AS year,
           COUNT(*)                             AS invoices,
           ROUND(SUM(Total), 2)                 AS revenue,
           ROUND(AVG(Total), 2)                 AS avg_order_value
    FROM Invoice
    GROUP BY year
)
SELECT year,
       invoices,
       revenue,
       avg_order_value,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY year))
             / LAG(revenue) OVER (ORDER BY year), 1) AS yoy_growth_pct
FROM yearly
ORDER BY year;
