USE SuperstoreDB;

--1. Who are the top 5 customers?
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
CUSTOMER_ID,
CUSTOMER_NAME,
TotalSales,
SalesRank
FROM
(
  SELECT *,
  RANK() OVER
  (
    ORDER BY TotalSales DESC
  )AS SalesRank
  FROM CustomerSales
) AS RankedCustomers
WHERE SalesRank <= 5
ORDER BY SalesRank;

--2.Who are the Bottom 5 Customers?
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
CUSTOMER_ID,
CUSTOMER_NAME,
TotalSales,
SalesRank
FROM
(
  SELECT *,
  RANK() OVER
  (
    ORDER BY TotalSales ASC
  ) AS SalesRank
  FROM CustomerSales
) AS RankedCustomers
WHERE SalesRank <= 5
ORDER BY SalesRank;

--3.Which Customers Made Only One Order?
WITH CustomerOrders AS
(
  SELECT 
  CUSTOMER_ID,
  COUNT(ORDER_ID) AS Totalorders
  FROM ORDERS
  GROUP BY CUSTOMER_ID
  HAVING COUNT(ORDER_ID) = 1
)
SELECT 
C.CUSTOMER_ID,
C.CUSTOMER_NAME,
CO.TotalOrders
FROM CUSTOMERS C
JOIN CustomerOrders CO
ON C.CUSTOMER_ID = CO.CUSTOMER_ID;

--4. Which Customers Have Above-Average Sales?
WITH CustomerSales AS
(
  SELECT 
  CUSTOMER_ID,
  SUM(SALES) AS TotalSales
  FROM ORDERS
  GROUP BY CUSTOMER_ID
)
SELECT *
FROM CustomerSales
WHERE TotalSales > 
(
  SELECT AVG(TotalSales)
  FROM CustomerSales
);

--5.What is the Highest Order Value per Customer?
WITH RankedOrders AS
(
  SELECT 
  O.ORDER_ID,
  C.CUSTOMER_ID,
  C.CUSTOMER_NAME,
  O.SALES,
  ROW_NUMBER() OVER
  (
    PARTITION BY C.CUSTOMER_ID
    ORDER BY O.SALES DESC
  ) AS RowNum
  FROM ORDERS O
  JOIN CUSTOMERS C
  ON O.CUSTOMER_ID = C.CUSTOMER_ID
)
SELECT
CUSTOMER_ID,
CUSTOMER_NAME,
ORDER_ID,
SALES AS HighestorderValue
FROM RankedOrders
WHERE RowNum = 1
ORDER BY HighestOrderValue DESC;