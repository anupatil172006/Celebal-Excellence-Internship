USE ShopEase;

/* Q13. Displaying the total number of orders in
   orders table */
   SELECT COUNT(*) AS TotalCount
   FROM ORDERS;

/* Q14. Displaying total revenue from all delivered 
   orders */
   SELECT SUM(TOTAL_AMOUNT) AS Total_Revenue
   FROM ORDERS 
   WHERE ORDER_STATUS = 'Delivered';

/* Q15. Displaying average UNIT_PRICE of products in 
   each category */
   SELECT CATEGORY, AVG(UNIT_PRICE) AS Average_category
   FROM PRODUCTS
   GROUP BY CATEGORY;

/* Q16. Displaying the sorted results by count of orders
   and the total revenue */
   SELECT ORDER_STATUS,
   COUNT (*) AS Total_Orders,
   SUM(TOTAL_AMOUNT) AS Total_Revenue
   FROM ORDERS
   GROUP BY ORDER_STATUS
   ORDER BY total_Revenue DESC;

/* Q17. Displaying most expensive and cheapest product in 
   each category */
   SELECT CATEGORY,
   MAX(UNIT_PRICE) AS Expensive_Category,
   MIN(UNIT_PRICE) AS Cheapest_Category
   FROM PRODUCTS 
   GROUP BY CATEGORY;

/* Q18. Displaying all products category having average
   UNIT_PRICE greater price 2000 */
   SELECT CATEGORY,
   AVG(UNIT_PRICE) AS Average_Price
   FROM PRODUCTS
   GROUP BY CATEGORY
   HAVING AVG(UNIT_PRICE) > 2000;