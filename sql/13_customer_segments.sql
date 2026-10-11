-- Q13. Simple RFM-style segmentation in pure SQL.
-- Recency is measured against the last invoice date in the data.
WITH ref AS (SELECT MAX(julianday(InvoiceDate)) AS last_day FROM Invoice),
rfm AS (
    SELECT c.CustomerId,
           ref.last_day - MAX(julianday(i.InvoiceDate)) AS recency_days,
           COUNT(i.InvoiceId)                          AS frequency,
           SUM(i.Total)                                AS monetary
    FROM Customer c
    JOIN Invoice i ON i.CustomerId = c.CustomerId
    CROSS JOIN ref
    GROUP BY c.CustomerId
),
scored AS (
    SELECT *,
           NTILE(3) OVER (ORDER BY recency_days DESC) AS r_score,   -- 3 = most recent
           NTILE(3) OVER (ORDER BY monetary)          AS m_score    -- 3 = highest spend
    FROM rfm
)
SELECT CASE
         WHEN r_score = 3 AND m_score = 3   THEN '1 Champions'
         WHEN r_score >= 2 AND m_score >= 2 THEN '2 Loyal'
         WHEN r_score = 3                   THEN '3 Recent, low spend'
         WHEN m_score = 3                   THEN '4 High value, at risk'
         ELSE                                    '5 Hibernating'
       END                         AS segment,
       COUNT(*)                    AS customers,
       ROUND(AVG(recency_days), 0) AS avg_recency_days,
       ROUND(AVG(frequency), 1)    AS avg_orders,
       ROUND(AVG(monetary), 2)     AS avg_spend,
       ROUND(SUM(monetary), 2)     AS total_spend
FROM scored
GROUP BY segment
ORDER BY segment;
