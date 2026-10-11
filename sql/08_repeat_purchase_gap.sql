-- Q8. How long do customers wait between purchases? (LAG over each customer's invoices)
WITH ordered AS (
    SELECT CustomerId,
           InvoiceDate,
           julianday(InvoiceDate)
             - julianday(LAG(InvoiceDate) OVER (PARTITION BY CustomerId ORDER BY InvoiceDate)) AS gap_days
    FROM Invoice
)
SELECT COUNT(gap_days)                                  AS repeat_purchases,
       ROUND(AVG(gap_days), 1)                          AS avg_gap_days,
       MIN(gap_days)                                    AS min_gap_days,
       MAX(gap_days)                                    AS max_gap_days,
       SUM(CASE WHEN gap_days <= 30  THEN 1 ELSE 0 END) AS within_30d,
       SUM(CASE WHEN gap_days <= 90  THEN 1 ELSE 0 END) AS within_90d,
       SUM(CASE WHEN gap_days > 180 THEN 1 ELSE 0 END)  AS over_180d
FROM ordered;
