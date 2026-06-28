USE ShopEase;

--Q1.Displaying all rows and columns from customers
SELECT * FROM CUSTOMERS;

--Q2.Displaying only first name, last name and city of all customers
SELECT FIRST_NAME, LAST_NAME,CITY FROM CUSTOMERS;

--Q3.Displaying all unique categories from products table
SELECT DISTINCT CATEGORY FROM PRODUCTS;

--Q4.Primary key of each table:
-- CUSTOMERS : CUSTOMER_ID
-- PRODUCTS : PRODUCT_ID
-- ORDERS : ORDER_ID
--ORDER_ITEMS : ITEM_ID

-- Primary key uniquely identifies each record hence no two rows
-- can have the same primry key value.

--Q5. Constraints applied to email column in the customers table
-- are 'UNIQUE' and 'NOT NULL'.
--If we try to insert the duplicate email then it well throw the 
--error 'violation of UNIQUE KEY constraint.' and that new email 
-- cannot be inserted into the table.

/*Q6 query:
INSERT INTO PRODUCTS (PRODUCT_ID,PRODUCT_NAME,CATEGORY,BRAND,UNIT_PRICE,STOCK_QTY)
VALUES (209,'USB cable','electronics','samsung',-50,100);
Result:
This query will throw the error as 'The INSERT statement conflicted with'
the CHECK constraint'

The SQL server wil not allow to insert the negative record in the PRODUCTS 
table

Reason:
The constraint which prevents it is: CHECK constraint
At the time of table creation we have used the CHECK constraint for unit_price
record as 'CHECK(UNIT_PRICE > 0)'

Hence it will not allow the insertion of values lesser than 0*/




