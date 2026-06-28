USE ShopEase;

-- Q7. Displaying all orders with status displaying
SELECT * FROM ORDERS
WHERE ORDER_STATUS='Delivered';

/* Q8. Displaying all products in 'Electronics' category 
with unit_price > 2000 */
SELECT * FROM PRODUCTS
WHERE CATEGORY = 'Electronics'
AND
UNIT_PRICE > 2000;

/*Q9. Dislaying the customers who joined in year 2024 and 
belongs to 'Maharashtra' state */
SELECT * FROM CUSTOMERS
WHERE JOIN_DATE BETWEEN '2024-01-01' AND '2024-12-31'
AND STATE = 'Maharashtra';

/*Q10. Orders placed between '2024-08-10' and '2024-08-25' that 
   are not cancelled */
   SELECT * FROM ORDERS
   WHERE ORDER_DATE BETWEEN '2024-08-10' AND '2024-08-25'
   AND ORDER_STATUS != 'CANCELLED';

/*Q11. IDX_ORDERS_DATE:
   This is the index created on the column - (ORDER_DATE)
   1. An index helps SQL to locate rows faster
   2. Without index SQl will scan the entire table
   3. It will check every row one by one. Hence it will 
      take more time
   4. By using an index server performs an index seek
   5. It directly locates requied dates. Hence query 
      executes faster
      
      Query: */
      SELECT * FROM ORDERS
      WHERE ORDER_DATE = '2024-08-15';

/* Q12. Will index used?
       - No index will not be used in these query
       - query is not SARGable because YEAR() function is used 
         in index column i.e. JOIN_DATE
       - So before SQL compare value with 2024, it has to calculate
         YEAR(JOIN_DATE) for every row.
       - It makes the query more difficult.

       SARGable query: 
       */
       SELECT * FROM CUSTOMERS
       WHERE JOIN_DATE BETWEEN '2024-01-01' AND '2024-12-31';
