USE CEI_WEEK2;

--Selecting west region 
SELECT TOP 5 * 
FROM SUPERSTORE
WHERE Region ='West';

--Selecting entries in technology category
SELECT TOP 5 *
FROM SUPERSTORE
WHERE CATEGORY = 'Technology';

--Selecting High sale entries
SELECT TOP 5 *
FROM SUPERSTORE
WHERE SALES > 500;

--Selecting orders from year 2017
SELECT TOP 5 *
FROM SUPERSTORE
WHERE ORDER_DATE LIKE '2017%';
