-- Q12. What is the favourite genre in each country? (ROW_NUMBER picks the top genre per partition)
WITH country_genre AS (
    SELECT i.BillingCountry AS country,
           g.Name           AS genre,
           SUM(il.Quantity) AS units
    FROM InvoiceLine il
    JOIN Invoice i ON i.InvoiceId = il.InvoiceId
    JOIN Track   t ON t.TrackId   = il.TrackId
    JOIN Genre   g ON g.GenreId   = t.GenreId
    GROUP BY country, genre
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY country ORDER BY units DESC, genre) AS rn,
           SUM(units)   OVER (PARTITION BY country)                           AS country_units
    FROM country_genre
)
SELECT country, genre AS top_genre, units,
       ROUND(100.0 * units / country_units, 1) AS share_of_country_pct
FROM ranked
WHERE rn = 1
ORDER BY country_units DESC;
