-- Q5. Top 10 artists by revenue, with their rank and cumulative share (Pareto view).
WITH artist_rev AS (
    SELECT ar.Name                          AS artist,
           SUM(il.UnitPrice * il.Quantity)  AS revenue
    FROM InvoiceLine il
    JOIN Track  t  ON t.TrackId   = il.TrackId
    JOIN Album  al ON al.AlbumId  = t.AlbumId
    JOIN Artist ar ON ar.ArtistId = al.ArtistId
    GROUP BY ar.ArtistId
)
SELECT RANK() OVER (ORDER BY revenue DESC)                                AS rnk,
       artist,
       ROUND(revenue, 2)                                                 AS revenue,
       ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC ROWS UNBOUNDED PRECEDING)
             / SUM(revenue) OVER (), 1)                                  AS cumulative_share_pct
FROM artist_rev
ORDER BY revenue DESC
LIMIT 10;
