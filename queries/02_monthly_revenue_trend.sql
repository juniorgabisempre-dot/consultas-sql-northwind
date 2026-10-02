/* =============================================================================
   Pergunta de negócio: Qual é a tendência de receita mês a mês e qual o
   crescimento percentual (Month-over-Month) observado em cada mês?

   Técnica: window function LAG() para comparar cada mês com o mês anterior.
   ============================================================================= */

WITH MonthlyRevenue AS (
    SELECT
        DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1)     AS OrderMonth,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))         AS Revenue
    FROM Orders AS o
    INNER JOIN [Order Details] AS od
        ON od.OrderID = o.OrderID
    GROUP BY
        DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1)
)
SELECT
    OrderMonth,
    Revenue,
    LAG(Revenue) OVER (ORDER BY OrderMonth)                        AS PreviousMonthRevenue,
    CAST(
        CASE
            WHEN LAG(Revenue) OVER (ORDER BY OrderMonth) IS NULL
                 OR LAG(Revenue) OVER (ORDER BY OrderMonth) = 0 THEN NULL
            ELSE (Revenue - LAG(Revenue) OVER (ORDER BY OrderMonth))
                 / LAG(Revenue) OVER (ORDER BY OrderMonth) * 100
        END AS DECIMAL(10, 2)
    )                                                               AS MoMGrowthPercent
FROM MonthlyRevenue
ORDER BY OrderMonth;
