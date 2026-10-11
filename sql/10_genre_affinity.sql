-- Q10. Cross-sell: which pairs of genres are most often bought in the same invoice?
WITH inv_genre AS (
    SELECT DISTINCT il.InvoiceId, g.Name AS genre
    FROM InvoiceLine il
    JOIN Track t ON t.TrackId = il.TrackId
    JOIN Genre g ON g.GenreId = t.GenreId
)
SELECT a.genre  AS genre_a,
       b.genre  AS genre_b,
       COUNT(*) AS invoices_together
FROM inv_genre a
JOIN inv_genre b
  ON a.InvoiceId = b.InvoiceId
 AND a.genre < b.genre
GROUP BY a.genre, b.genre
ORDER BY invoices_together DESC
LIMIT 12;
