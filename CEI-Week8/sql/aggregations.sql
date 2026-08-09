--Total revenue per category
SELECT 
p.category,
ROUND(
    SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount_percent / 100.0)
    ),2) AS total_revenue
FROM order_items oi 
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

--Top 10 customers by total order value
SELECT 
c.customer_id,
c.customer_name,
ROUND(
    SUM(
        oi.quantity * oi.unit_price * (1- oi.discount_percent / 100.0)
    ),2
) AS total_order_value
FROM customers c JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY c.customer_id,
         c.customer_name
ORDER BY total_order_value DESC
LIMIT 10;

--Month wise order count for the last 12 months

SELECT
    strftime('%Y-%m', order_date) AS order_month,
    COUNT(order_id) AS total_orders
FROM orders
WHERE order_date >= date('now', '-12 months')
GROUP BY order_month
ORDER BY order_month;

--Customers who placed the orders but never had any item delivred
SELECT DISTINCT
c.customer_id,
c.customer_name
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY 
c.customer_id,c.customer_name
HAVING SUM(
    CASE 
        WHEN o.status = 'DELIVERED' THEN 1
        ELSE 0
        END
) = 0;

--Products with more returns than purchases
SELECT 
p.product_id,
p.product_name,
SUM(
    CASE
        WHEN oi.quantity > 0 THEN oi.quantity 
        ELSE 0
        END
    ) AS purchased_quantity,
ABS(SUM(
    CASE 
        WHEN oi.quantity < 0 THEN oi.quantity
        ELSE 0
        END 
    )) AS returned_quantity
FROM products p 
JOIN order_items oi 
ON p.product_id = oi.product_id
GROUP BY p.product_id , p.product_name
HAVING returned_quantity > purchased_quantity;

--Return rate per category
SELECT
p.category,
ROUND(
    100.0 * 
    SUM(CASE 
            WHEN oi.quantity < 0 THEN ABS(oi.quantity)
            ELSE 0
            END) /
            SUM(
                ABS(oi.quantity)
            ) , 2
) AS return_rate_percent
FROM products p 
JOIN order_items oi 
ON p.product_id = oI.product_id
GROUP BY p.category
ORDER BY return_rate_percent DESC;
