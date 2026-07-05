USE SuperstoreDB;

/*3: one final query that shows: 
• Customer Name 
• Total Sales 
• Rank (Use JOIN + CTE + Window Function together) */
WITH CustomerSales AS
(
  SELECT
  C.CUSTOMER_ID,
  C.CUSTOMER_NAME,
  SUM(O.SALES) AS TotalSales
  FROM CUSTOMERS C
  JOIN ORDERS O
  ON C.CUSTOMER_ID = O.CUSTOMER_ID
  GROUP BY 
  C.CUSTOMER_ID,
  C.CUSTOMER_NAME
)
SELECT 
CUSTOMER_NAME,
TotalSales,
RANK() OVER
(
  ORDER BY TotalSales DESC
) AS SalesRank
FROM CustomerSales
ORDER BY SalesRank;