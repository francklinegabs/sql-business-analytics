-- Q7. Which support reps look after the most valuable customers?
-- Revenue per rep, per customer, and the rep's share, alongside hire date.
SELECT e.FirstName || ' ' || e.LastName                         AS sales_rep,
       e.Title                                                 AS title,
       date(e.HireDate)                                        AS hired,
       COUNT(DISTINCT c.CustomerId)                            AS customers,
       COUNT(i.InvoiceId)                                      AS invoices,
       ROUND(SUM(i.Total), 2)                                  AS revenue,
       ROUND(SUM(i.Total) / COUNT(DISTINCT c.CustomerId), 2)   AS revenue_per_customer,
       ROUND(100.0 * SUM(i.Total) / (SELECT SUM(Total) FROM Invoice), 1) AS revenue_share_pct
FROM Employee e
JOIN Customer c ON c.SupportRepId = e.EmployeeId
JOIN Invoice  i ON i.CustomerId   = c.CustomerId
GROUP BY e.EmployeeId
ORDER BY revenue DESC;
