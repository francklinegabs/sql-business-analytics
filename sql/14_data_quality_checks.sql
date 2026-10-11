-- Q14. Data-quality audit: do invoice totals reconcile with their line items,
-- and are there orphaned or incomplete records?
SELECT 'invoices whose Total differs from sum of lines' AS check_name,
       COUNT(*) AS failures
FROM (
    SELECT i.InvoiceId
    FROM Invoice i
    JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
    GROUP BY i.InvoiceId
    HAVING ROUND(i.Total, 2) <> ROUND(SUM(il.UnitPrice * il.Quantity), 2)
)
UNION ALL
SELECT 'invoice lines pointing at missing tracks',
       COUNT(*) FROM InvoiceLine il LEFT JOIN Track t ON t.TrackId = il.TrackId WHERE t.TrackId IS NULL
UNION ALL
SELECT 'invoices with no lines',
       COUNT(*) FROM Invoice i WHERE NOT EXISTS (SELECT 1 FROM InvoiceLine il WHERE il.InvoiceId = i.InvoiceId)
UNION ALL
SELECT 'customers without a support rep',
       COUNT(*) FROM Customer WHERE SupportRepId IS NULL
UNION ALL
SELECT 'customers with no state recorded',
       COUNT(*) FROM Customer WHERE State IS NULL
UNION ALL
SELECT 'tracks with no composer',
       COUNT(*) FROM Track WHERE Composer IS NULL
UNION ALL
SELECT 'line price differs from catalogue price',
       COUNT(*) FROM InvoiceLine il JOIN Track t ON t.TrackId = il.TrackId WHERE il.UnitPrice <> t.UnitPrice;
