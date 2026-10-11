-- Q9. What does a typical basket look like? Distribution of tracks per invoice.
WITH baskets AS (
    SELECT InvoiceId, SUM(Quantity) AS items, SUM(UnitPrice * Quantity) AS value
    FROM InvoiceLine
    GROUP BY InvoiceId
)
SELECT items                                              AS tracks_in_basket,
       COUNT(*)                                           AS invoices,
       ROUND(AVG(value), 2)                               AS avg_value,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS share_pct
FROM baskets
GROUP BY items
ORDER BY items;
