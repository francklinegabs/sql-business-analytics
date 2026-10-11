-- Q3. Which markets matter most? Revenue, customers and revenue per customer by country,
-- with each country's share of total revenue.
SELECT c.Country                                              AS country,
       COUNT(DISTINCT c.CustomerId)                           AS customers,
       COUNT(i.InvoiceId)                                     AS invoices,
       ROUND(SUM(i.Total), 2)                                 AS revenue,
       ROUND(SUM(i.Total) / COUNT(DISTINCT c.CustomerId), 2)  AS revenue_per_customer,
       ROUND(100.0 * SUM(i.Total) / (SELECT SUM(Total) FROM Invoice), 1) AS revenue_share_pct
FROM Customer c
JOIN Invoice  i ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY revenue DESC;
