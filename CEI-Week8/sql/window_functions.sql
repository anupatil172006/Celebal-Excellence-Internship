WITH DailyRevenue AS(
    SELECT 
    o.region_code,
    DATE(o.order_date) AS order_date,
    ROUND(
        SUM(
            oi.quantity * oi.unit_price * (1 - oi.discount_percent / 100.0)
        ) , 2
    ) AS daily_revenue
FROM orders o JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY 
o.region_code,
DATE(o.order_date)
)
SELECT
region_code,
order_date,
daily_revenue,
ROUND(
    SUM(daily_revenue) OVER (PARTITION BY region_code
                            ORDER BY order_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2
) AS running_total
FROM DailyRevenue
ORDER BY
        region_code,
        order_date;

--Rank products by revenue
WITH ProductRevenue AS(
    SELECT 
    p.product_name,
    p.category,
    ROUND(
        SUM(
            oi.quantity * oi.unit_price * (1 - oi.discount_percent / 100.0)
        ) , 2
    ) AS total_revenue
    FROM products p JOIN order_items oi 
    ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
)
SELECT 
category,
product_name,
total_revenue,
DENSE_RANK() OVER(PARTITION BY category
                  ORDER BY total_revenue DESC) AS rank_in_category
FROM ProductRevenue
ORDER BY category, rank_in_category

-- --LAG Analysis
WITH CustomerOrders AS(
    SELECT 
    customer_id,
    order_date,
    LAG(order_date) OVER(PARTITION BY customer_id
                         ORDER BY order_date) AS previous_order_date
FROM orders
WHERE customer_id IS NOT NULL
),
OrderGaps AS (
    SELECT
        customer_id,
        order_date,
        previous_order_date,
        JULIANDAY(order_date) - JULIANDAY(previous_order_date) AS days_gap
    FROM CustomerOrders
)

SELECT
    customer_id,
    order_date,
    previous_order_date,
    ROUND(days_gap, 2) AS days_gap,
    CASE
        WHEN AVG(days_gap) OVER (PARTITION BY customer_id) > 30
        THEN 'At Risk'
        ELSE 'Active'
    END AS customer_status
FROM OrderGaps
ORDER BY
    customer_id,
    order_date;

-- Rank customers by lifetime value

WITH CustomerLifetimeValue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        ROUND(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount_percent / 100.0)
            ),
            2
        ) AS lifetime_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,
    lifetime_value,
    DENSE_RANK() OVER (
        ORDER BY lifetime_value DESC
    ) AS lifetime_value_rank
FROM CustomerLifetimeValue
ORDER BY lifetime_value_rank;