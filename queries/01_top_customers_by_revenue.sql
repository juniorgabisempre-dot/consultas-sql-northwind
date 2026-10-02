/* =============================================================================
   Pergunta de negócio: Quais são os 10 clientes que mais geraram receita
   (valor líquido de pedidos, já considerando desconto) para a empresa?
   ============================================================================= */

SELECT TOP 10
    c.CustomerID,
    c.CompanyName,
    c.Country,
    COUNT(DISTINCT o.OrderID)                                   AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))         AS TotalRevenue
FROM Customers AS c
INNER JOIN Orders AS o
    ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] AS od
    ON od.OrderID = o.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName,
    c.Country
ORDER BY
    TotalRevenue DESC;
