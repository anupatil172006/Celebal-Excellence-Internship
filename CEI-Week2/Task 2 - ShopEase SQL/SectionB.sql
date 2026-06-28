USE ShopEase;

--Displaying all orders with status displaying
SELECT * FROM ORDERS
WHERE ORDER_STATUS='Delivered';

/*Displaying all products in 'Electronics' category 
with unit_price > 2000 */
SELECT * FROM PRODUCTS
WHERE CATEGORY = 'Electronics'
AND
UNIT_PRICE > 2000;

/* Dislaying the customers who joined in year 2024 and 
belongs to 'Maharashtra' state */
SELECT * FROM CUSTOMERS
WHERE JOIN_DATE BETWEEN '2024-01-01' AND '2024-12-31'
AND STATE = 'Maharashtra';

