/* =============================================================================
   Pergunta de negócio: Quais clientes são os mais valiosos, combinando
   Recência (há quanto tempo compraram pela última vez), Frequência (quantos
   pedidos fizeram) e Valor Monetário (quanto gastaram)?

   Técnica: CTEs + NTILE() para segmentar clientes em quartis por dimensão.
   Quanto menor o RFMScoreTotal, melhor o cliente (mais recente, mais
   frequente e de maior valor).
   ============================================================================= */

WITH CustomerOrders AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        MAX(o.OrderDate)                                    AS LastOrderDate,
        COUNT(DISTINCT o.OrderID)                            AS Frequency,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))  AS Monetary
    FROM Customers AS c
    INNER JOIN Orders AS o
        ON o.CustomerID = c.CustomerID
    INNER JOIN [Order Details] AS od
        ON od.OrderID = o.OrderID
    GROUP BY
        c.CustomerID,
        c.CompanyName
),
RFMBase AS (
    SELECT
        CustomerID,
        CompanyName,
        LastOrderDate,
        DATEDIFF(DAY, LastOrderDate, (SELECT MAX(OrderDate) FROM Orders)) AS RecencyDays,
        Frequency,
        Monetary
    FROM CustomerOrders
),
RFMScored AS (
    SELECT
        CustomerID,
        CompanyName,
        RecencyDays,
        Frequency,
        Monetary,
        NTILE(4) OVER (ORDER BY RecencyDays ASC)  AS RecencyScore,   -- 1 = comprou mais recentemente
        NTILE(4) OVER (ORDER BY Frequency DESC)   AS FrequencyScore, -- 1 = compra com mais frequência
        NTILE(4) OVER (ORDER BY Monetary DESC)    AS MonetaryScore   -- 1 = maior valor gasto
    FROM RFMBase
)
SELECT
    CustomerID,
    CompanyName,
    RecencyDays,
    Frequency,
    Monetary,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    (RecencyScore + FrequencyScore + MonetaryScore) AS RFMScoreTotal
FROM RFMScored
ORDER BY RFMScoreTotal ASC, Monetary DESC;
