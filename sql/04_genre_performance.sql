-- Q4. Which genres drive sales, and how does that compare with how much catalogue each genre has?
WITH sales AS (
    SELECT t.GenreId,
           SUM(il.UnitPrice * il.Quantity) AS revenue,
           SUM(il.Quantity)                AS units
    FROM InvoiceLine il
    JOIN Track t ON t.TrackId = il.TrackId
    GROUP BY t.GenreId
),
catalogue AS (
    SELECT GenreId, COUNT(*) AS tracks FROM Track GROUP BY GenreId
)
SELECT g.Name                                                          AS genre,
       c.tracks                                                        AS catalogue_tracks,
       COALESCE(s.units, 0)                                            AS units_sold,
       ROUND(COALESCE(s.revenue, 0), 2)                                AS revenue,
       ROUND(100.0 * COALESCE(s.revenue, 0) / SUM(s.revenue) OVER (), 1) AS revenue_share_pct,
       ROUND(1.0 * COALESCE(s.units, 0) / c.tracks, 2)                 AS units_per_catalogue_track
FROM Genre g
JOIN catalogue c ON c.GenreId = g.GenreId
LEFT JOIN sales s ON s.GenreId = g.GenreId
ORDER BY revenue DESC;
