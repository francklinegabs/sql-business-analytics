-- Q6. Customer lifetime value: total spend, orders, tenure and spend quartile per customer (top 15 shown).
WITH cust AS (
    SELECT c.CustomerId,
           c.FirstName || ' ' || c.LastName      AS customer,
           c.Country                             AS country,
           COUNT(i.InvoiceId)                    AS orders,
           ROUND(SUM(i.Total), 2)                AS lifetime_value,
           MIN(date(i.InvoiceDate))              AS first_order,
           MAX(date(i.InvoiceDate))              AS last_order
    FROM Customer c
    JOIN Invoice  i ON i.CustomerId = c.CustomerId
    GROUP BY c.CustomerId
)
SELECT customer, country, orders, lifetime_value, first_order, last_order,
       CAST(julianday(last_order) - julianday(first_order) AS INTEGER) AS tenure_days,
       NTILE(4) OVER (ORDER BY lifetime_value DESC)                    AS spend_quartile
FROM cust
ORDER BY lifetime_value DESC
LIMIT 15;
