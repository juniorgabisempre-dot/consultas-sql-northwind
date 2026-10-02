/* =============================================================================
   Pergunta de negócio: Qual é a receita por categoria de produto e qual o
   desconto médio efetivamente concedido em cada categoria (proxy de margem)?

   Técnica: CTEs encadeadas (produto -> categoria) + agregação.
   ============================================================================= */

WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        p.UnitPrice                                          AS ListPrice,
        SUM(od.Quantity)                                     AS TotalUnitsSold,
        SUM(od.UnitPrice * od.Quantity)                       AS GrossRevenue,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))   AS NetRevenue
    FROM Products AS p
    INNER JOIN [Order Details] AS od
        ON od.ProductID = p.ProductID
    GROUP BY
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        p.UnitPrice
),
CategorySales AS (
    SELECT
        c.CategoryID,
        c.CategoryName,
        SUM(ps.NetRevenue)     AS CategoryNetRevenue,
        SUM(ps.GrossRevenue)   AS CategoryGrossRevenue,
        SUM(ps.TotalUnitsSold) AS CategoryUnitsSold
    FROM ProductSales AS ps
    INNER JOIN Categories AS c
        ON c.CategoryID = ps.CategoryID
    GROUP BY
        c.CategoryID,
        c.CategoryName
)
SELECT
    CategoryID,
    CategoryName,
    CategoryUnitsSold,
    CategoryGrossRevenue,
    CategoryNetRevenue,
    CAST(
        (CategoryGrossRevenue - CategoryNetRevenue)
        / NULLIF(CategoryGrossRevenue, 0) * 100 AS DECIMAL(10, 2)
    ) AS AvgDiscountPercent
FROM CategorySales
ORDER BY CategoryNetRevenue DESC;
