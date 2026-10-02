# SQL Analytics — Northwind

Coleção de consultas T-SQL (SQL Server) sobre o banco de exemplo público
**Northwind**, escritas para responder perguntas de negócio reais — não
apenas para demonstrar sintaxe. O objetivo deste repositório é mostrar, de
forma prática, o uso de **window functions**, **CTEs (Common Table
Expressions)** e **stored procedures** aplicados a um cenário de vendas.

> Portfólio de análise de dados / governança de dados — foco em SQL Server.

## Sobre o banco Northwind

Northwind é o banco de dados de exemplo clássico da Microsoft, que simula
uma empresa de importação e exportação de alimentos. Ele contém tabelas
como `Customers`, `Orders`, `Order Details`, `Products`, `Categories` e
`Employees`, e é amplamente usado para ensino e demonstração de SQL por
representar bem um cenário de vendas B2B.

Repositório oficial da Microsoft com o script de criação do banco:
https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs

Nenhum dado do Northwind está incluído neste repositório — apenas as
consultas. O schema é público e a restauração é feita localmente por quem
for executar os exemplos.

## Como restaurar o Northwind no SQL Server

1. Baixe o script `instnwnd.sql` (versão para SQL Server) a partir do
   repositório oficial acima.
2. Abra o script no SQL Server Management Studio (SSMS) ou no Azure Data
   Studio, conectado à sua instância local de SQL Server.
3. Execute o script completo — ele cria o banco `Northwind` e popula todas
   as tabelas com dados de exemplo.
4. Aponte a conexão do seu cliente SQL para o banco `Northwind` recém-criado
   e execute as consultas deste repositório normalmente.

## Estrutura do repositório

```
queries/
  01_top_customers_by_revenue.sql
  02_monthly_revenue_trend.sql
  03_running_total_sales.sql
  04_employee_performance_ranking.sql
  05_product_category_analysis.sql
  06_customer_rfm_lite.sql
procedures/
  sp_customer_order_summary.sql
```

## Consultas e as perguntas de negócio que respondem

| Arquivo | Pergunta de negócio | Técnica em destaque |
|---|---|---|
| `queries/01_top_customers_by_revenue.sql` | Quais são os 10 clientes que mais geraram receita? | `JOIN` + agregação, `TOP` |
| `queries/02_monthly_revenue_trend.sql` | Qual a tendência de receita mês a mês e o crescimento percentual (MoM)? | CTE + `LAG()` |
| `queries/03_running_total_sales.sql` | Qual o total acumulado de vendas ao longo do tempo? | CTE + `SUM() OVER (ORDER BY ...)` |
| `queries/04_employee_performance_ranking.sql` | Como os funcionários se comparam em receita gerada? | CTE + `RANK()` / `DENSE_RANK()` |
| `queries/05_product_category_analysis.sql` | Qual a receita e o desconto médio por categoria de produto? | CTEs encadeadas + agregação |
| `queries/06_customer_rfm_lite.sql` | Quais clientes são mais valiosos (Recência, Frequência, Valor Monetário)? | CTEs + `NTILE()` |
| `procedures/sp_customer_order_summary.sql` | Qual o resumo do histórico de pedidos de um cliente específico? | Stored procedure parametrizada |

## Como executar a stored procedure

```sql
EXEC sp_customer_order_summary @CustomerID = 'ALFKI';
```

## Habilidades demonstradas

- Window functions (`LAG`, `RANK`, `DENSE_RANK`, `NTILE`, `SUM() OVER`)
- Common Table Expressions (CTEs simples e encadeadas)
- Stored procedures parametrizadas em T-SQL
- Tradução de perguntas de negócio em consultas SQL
- Boas práticas de legibilidade (aliases, formatação, comentários de contexto)

## Licença

Distribuído sob a licença MIT — veja [LICENSE](LICENSE).
