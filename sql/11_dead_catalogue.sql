-- Q11. How much of the catalogue has never sold? Unsold tracks by media type.
SELECT mt.Name                                             AS media_type,
       COUNT(*)                                            AS tracks,
       SUM(CASE WHEN il.TrackId IS NULL THEN 1 ELSE 0 END) AS never_sold,
       ROUND(100.0 * SUM(CASE WHEN il.TrackId IS NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS never_sold_pct
FROM Track t
JOIN MediaType mt ON mt.MediaTypeId = t.MediaTypeId
LEFT JOIN (SELECT DISTINCT TrackId FROM InvoiceLine) il ON il.TrackId = t.TrackId
GROUP BY mt.MediaTypeId
ORDER BY tracks DESC;
