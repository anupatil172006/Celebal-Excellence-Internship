USE ShopEase;

-- Q19. Displaying first name, last name and order date
	SELECT
	O.ORDER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	O.ORDER_DATE,
	O.TOTAL_AMOUNT 
	FROM ORDERS AS O
	INNER JOIN CUSTOMERS AS C
	ON O.CUSTOMER_ID = C.CUSTOMER_ID;


/* Q20. Displaying all customers with their orders
   and those who have not placed any orders */
   SELECT 
   C.CUSTOMER_ID,
   C.FIRST_NAME,
   C.LAST_NAME,
   O.ORDER_ID
   FROM CUSTOMERS AS C 
   LEFT JOIN ORDERS AS O
   ON C.CUSTOMER_ID = O.CUSTOMER_ID;

/* Q21. Displaying customers full name, order ID, 
   product name, quantity ordered and total amount
   of each order */
   SELECT 
   C.FIRST_NAME,
   C.LAST_NAME,
   P.PRODUCT_NAME,
   OI.QUANTITY,
   O.TOTAL_AMOUNT
   FROM CUSTOMERS AS C
   INNER JOIN ORDERS O
   ON C.CUSTOMER_ID = O.CUSTOMER_ID
   INNER JOIN ORDER_ITEMS AS OI
   ON O.ORDER_ID = OI.ORDER_ID
   INNER JOIN PRODUCTS AS P
   ON OI.PRODUCT_ID = P.PRODUCT_ID;

/* Q22. Differencr between left join and right join
   Left join:
       - returns all the rows from left table
	   - returns only matching rows from right table
	   - if there is no match, then right table
	     contains NULL
   Right join:
       - returns all rows from right table
	   - returns only matching rows from left table
	   - if there is no match, then left table
	     contains NULL
   Full outer join:
	   - returns all rows from both tables
	   - returns matching rows where available
	   - contains NULL where there is no match
EX:
*/
--LEFT JOIN:
   SELECT 
   C.CUSTOMER_ID,
   C.FIRST_NAME,
   O.ORDER_ID
   FROM CUSTOMERS AS C
   LEFT JOIN ORDERS AS O
   ON C.CUSTOMER_ID = O.CUSTOMER_ID;

--RIGHT JOIN
  SELECT 
  C.CUSTOMER_ID,
  C.FIRST_NAME,
  O.ORDER_ID
  FROM CUSTOMERS AS C
  RIGHT JOIN ORDERS AS O
  ON C.CUSTOMER_ID = O.CUSTOMER_ID;

/* Q23. Forign key:
   1. ORDERS.CUSTOMER_ID -> CUSTOMERS.CUSTOMER_ID
   2. ORDER_ITEMS.ORDER_ID -> ORDERS.ORDER_ID
   3.ORDER_ITEMS.PRODUCT_ID -> PRODUCTS.PRODUCT_ID

   What happen if we try to insert invalid customer?
   - SQL will reject this insertion
   - will display the error message
*/

/* Q. Displaying each customer's name along with total
   orders they have placed */
   SELECT 
   C.FIRST_NAME,
   C.LAST_NAME,
   COUNT(O.ORDER_ID) AS Total_Orders
   FROM CUSTOMERS AS C
   INNER JOIN ORDERS AS O
   ON C.CUSTOMER_ID = O.CUSTOMER_ID
   GROUP BY C.FIRST_NAME, C.LAST_NAME
   ORDER BY Total_Orders DESC;

   /* Q. Displaying each order along with product name,
   quantity ordered, and unit price */
   SELECT 
   O.ORDER_ID,
   P.PRODUCT_NAME,
   OI.QUANTITY,
   P.UNIT_PRICE,
   OI.DISCOUNT_PCT
   FROM ORDERS AS O
   INNER JOIN ORDER_ITEMS AS OI
   ON O.ORDER_ID = OI.ORDER_ID
   INNER JOIN PRODUCTS AS P
   ON OI.PRODUCT_ID = P.PRODUCT_ID;

