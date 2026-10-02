/* =============================================================================
   Pergunta de negócio: Qual é o total acumulado (running total) de vendas ao
   longo do tempo, pedido a pedido?

   Técnica: window function SUM() OVER (ORDER BY ...) sem PARTITION BY, para
   acumular a receita cronologicamente.
   ============================================================================= */

WITH OrderRevenue AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderRevenue
    FROM Orders AS o
    INNER JOIN [Order Details] AS od
        ON od.OrderID = o.OrderID
    GROUP BY
        o.OrderID,
        o.OrderDate
)
SELECT
    OrderID,
    OrderDate,
    OrderRevenue,
    SUM(OrderRevenue) OVER (
        ORDER BY OrderDate, OrderID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotalRevenue
FROM OrderRevenue
ORDER BY OrderDate, OrderID;
