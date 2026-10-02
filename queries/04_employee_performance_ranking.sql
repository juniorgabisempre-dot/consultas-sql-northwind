/* =============================================================================
   Pergunta de negócio: Como os funcionários (vendedores) se comparam entre si
   em receita total gerada? Quem é o 1º, 2º, 3º colocado, inclusive em caso de
   empate?

   Técnica: RANK() (deixa "buracos" após empates) e DENSE_RANK() (não deixa).
   ============================================================================= */

WITH EmployeeRevenue AS (
    SELECT
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName             AS EmployeeName,
        e.Title,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
    FROM Employees AS e
    INNER JOIN Orders AS o
        ON o.EmployeeID = e.EmployeeID
    INNER JOIN [Order Details] AS od
        ON od.OrderID = o.OrderID
    GROUP BY
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.Title
)
SELECT
    EmployeeID,
    EmployeeName,
    Title,
    TotalRevenue,
    RANK() OVER (ORDER BY TotalRevenue DESC)       AS RevenueRank,
    DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueDenseRank
FROM EmployeeRevenue
ORDER BY TotalRevenue DESC;
