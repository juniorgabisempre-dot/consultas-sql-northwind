/* =============================================================================
   Pergunta de negócio: Dado o ID de um cliente, qual é o resumo do seu
   histórico de pedidos (quantidade de pedidos, receita total, ticket médio
   por linha de pedido, data do primeiro e do último pedido)?

   Uso:
       EXEC sp_customer_order_summary @CustomerID = 'ALFKI';
   ============================================================================= */

CREATE OR ALTER PROCEDURE sp_customer_order_summary
    @CustomerID NCHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.CustomerID,
        c.CompanyName,
        COUNT(DISTINCT o.OrderID)                                   AS TotalOrders,
        ISNULL(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 0) AS TotalRevenue,
        ISNULL(AVG(od.UnitPrice * od.Quantity * (1 - od.Discount)), 0) AS AvgOrderLineRevenue,
        MIN(o.OrderDate)                                            AS FirstOrderDate,
        MAX(o.OrderDate)                                            AS LastOrderDate
    FROM Customers AS c
    LEFT JOIN Orders AS o
        ON o.CustomerID = c.CustomerID
    LEFT JOIN [Order Details] AS od
        ON od.OrderID = o.OrderID
    WHERE c.CustomerID = @CustomerID
    GROUP BY
        c.CustomerID,
        c.CompanyName;
END;
GO
