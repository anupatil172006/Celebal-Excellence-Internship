USE SUPERSTOREDB;


/* 1.Find all orders where sales are
   greater than the average sales. (Subquery) */
   SELECT * 
   FROM ORDERS 
   WHERE SALES > 
   (
     SELECT AVG(SALES)
     FROM ORDERS
   );

/* 2.Find the highest sales order for each 
   customer. (Subquery) */
   SELECT
   ORDER_ID,
   CUSTOMER_ID,
   SALES,
   ORDER_DATE
   FROM ORDERS O
   WHERE SALES = 
   (
     SELECT MAX(SALES)
     FROM ORDERS
     WHERE CUSTOMER_ID = O.CUSTOMER_ID
   )
   ORDER BY CUSTOMER_ID;

--3.Calculate total sales for each customer.(CTE) 
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
ORDER BY TotalSales DESC;

/* 4.Find customers whose total sales 
     are above average. (CTE + Subquery)*/
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

/* 5.Rank all customers based on 
   total sales. (Window Function) */
  WITH CustomerSales AS
  (
   SELECT
   CUSTOMER_ID,
   SUM(SALES) AS TotalSales
   FROM ORDERS
   GROUP BY CUSTOMER_ID
  )
  SELECT 
  CUSTOMER_ID,
  TotalSales,
  RANK() OVER 
  (
   ORDER BY TotalSales DESC
  ) AS SalesRank
  FROM CustomerSales
  ORDER BY SalesRank;

 /* 6.Assign row numbers to each order within a customer.
    (Window Function + PARTITION BY) */
  SELECT
  ORDER_ID,
  CUSTOMER_ID,
  SALES,
  ORDER_DATE,
  ROW_NUMBER() OVER
  (
    PARTITION BY CUSTOMER_ID
    ORDER BY ORDER_DATE
  ) AS RowNumber
  FROM ORDERS
  ORDER BY CUSTOMER_ID, RowNumber;

/*7.Display top 3 customers based on 
    total sales. (Window Function) */ 
 WITH CustomerSales AS
    (
      SELECT 
      CUSTOMER_ID,
      SUM(SALES) AS TotalSales
      FROM ORDERS
      GROUP BY CUSTOMER_ID
    )
SELECT 
CUSTOMER_ID,
TotalSales
FROM 
(
  SELECT 
  CUSTOMER_ID,
  TotalSales,
  RANK() OVER
  (
    ORDER BY TotalSales DESC
  ) AS SalesRank
  FROM CustomerSales
) AS RankedCustomers
WHERE SalesRank < = 3
ORDER BY SalesRank;
