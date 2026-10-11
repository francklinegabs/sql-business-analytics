-- Q15. Org chart via a recursive CTE: each employee's level and reporting chain.
WITH RECURSIVE chain(EmployeeId, name, title, level, path) AS (
    SELECT EmployeeId, FirstName || ' ' || LastName, Title, 0, FirstName || ' ' || LastName
    FROM Employee
    WHERE ReportsTo IS NULL
    UNION ALL
    SELECT e.EmployeeId, e.FirstName || ' ' || e.LastName, e.Title, c.level + 1,
           c.path || ' > ' || e.FirstName || ' ' || e.LastName
    FROM Employee e
    JOIN chain c ON e.ReportsTo = c.EmployeeId
)
SELECT level, name, title, path AS reporting_chain
FROM chain
ORDER BY path;
