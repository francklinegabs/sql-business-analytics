-- Q2. Is there seasonality? Monthly revenue with a 3-month rolling average and running total.
WITH monthly AS (
    SELECT strftime('%Y-%m', InvoiceDate) AS month,
           SUM(Total)                     AS revenue
    FROM Invoice
    GROUP BY month
)
SELECT month,
       ROUND(revenue, 2)                                                                     AS revenue,
       ROUND(AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_3m_avg,
       ROUND(SUM(revenue) OVER (ORDER BY month), 2)                                          AS running_total
FROM monthly
ORDER BY month;
