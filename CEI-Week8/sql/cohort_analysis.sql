-- 10. Multi-Level CTE

WITH MonthlyRevenue AS (
    SELECT
        o.customer_id,
        strftime('%Y-%m', o.order_date) AS order_month,
        SUM(
            oi.quantity * oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.customer_id IS NOT NULL
    GROUP BY
        o.customer_id,
        strftime('%Y-%m', o.order_date)
),

RevenueCategory AS (
    SELECT *,
        CASE
            WHEN monthly_revenue > 10000 THEN 'High'
            WHEN monthly_revenue >= 5000 THEN 'Medium'
            ELSE 'Low'
        END AS revenue_category
    FROM MonthlyRevenue
)

SELECT
    order_month,
    revenue_category,
    COUNT(customer_id) AS customer_count
FROM RevenueCategory
GROUP BY
    order_month,
    revenue_category
ORDER BY
    order_month,
    revenue_category;

--NTILE customer segmentation 
WITH CustomerRevenue AS (

    SELECT
        o.customer_id,
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent/100.0)
            ),
            2
        ) AS total_value

    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.customer_id IS NOT NULL

    GROUP BY o.customer_id
),

RankedCustomers AS (

    SELECT
        customer_id,
        total_value,
        NTILE(4) OVER(ORDER BY total_value DESC) AS quartile

    FROM CustomerRevenue
)

SELECT
    customer_id,
    total_value,
    quartile,

    CASE
        WHEN quartile=1 THEN 'Platinum'
        WHEN quartile=2 THEN 'Gold'
        WHEN quartile=3 THEN 'Silver'
        ELSE 'Bronze'
    END AS quartile_label

FROM RankedCustomers;

-- 12. Year-over-Year Revenue Comparison

WITH YearRevenue AS (
    SELECT
        strftime('%Y', o.order_date) AS year,
        strftime('%m', o.order_date) AS month,
        ROUND(
            SUM(
                oi.quantity * oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        ) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        strftime('%Y', o.order_date),
        strftime('%m', o.order_date)
),

RevenueComparison AS (
    SELECT
        year,
        month,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY month
            ORDER BY year
        ) AS prev_year_revenue
    FROM YearRevenue
)

SELECT
    year,
    month,
    revenue,
    prev_year_revenue,
    ROUND(
        ((revenue - prev_year_revenue) * 100.0) /
        prev_year_revenue,
        2
    ) AS yoy_growth_percent
FROM RevenueComparison
ORDER BY
    month,
    year;
    
-- 13.First purchased category vs last purchased category

WITH PurchaseHistory AS (

SELECT

o.customer_id,

p.category,

o.order_date,

ROW_NUMBER() OVER(
PARTITION BY o.customer_id
ORDER BY o.order_date
) first_purchase,

ROW_NUMBER() OVER(
PARTITION BY o.customer_id
ORDER BY o.order_date DESC
) last_purchase

FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id

JOIN products p
ON oi.product_id=p.product_id

)

SELECT

f.customer_id,

f.category AS first_category,

l.category AS last_category,

CASE

WHEN f.category=l.category
THEN 'No'

ELSE 'Yes'

END AS category_shift

FROM PurchaseHistory f

JOIN PurchaseHistory l

ON f.customer_id=l.customer_id

WHERE
f.first_purchase=1
AND
l.last_purchase=1;

-- 14. Cumulative Revenue Distribution

WITH CustomerRevenue AS (
    SELECT
        o.customer_id,
        SUM(
            oi.quantity * oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.customer_id IS NOT NULL
    GROUP BY o.customer_id
),

CumulativeRevenue AS (
    SELECT
        customer_id,
        ROUND(revenue, 2) AS revenue,
        ROUND(
            SUM(revenue) OVER (
                ORDER BY revenue DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ),
            2
        ) AS cumulative_revenue,

        SUM(revenue) OVER () AS total_revenue

    FROM CustomerRevenue
)

SELECT
    customer_id,
    revenue,
    cumulative_revenue,

    ROUND(
        (cumulative_revenue * 100.0) / total_revenue,
        2
    ) AS cumulative_percent

FROM CumulativeRevenue

ORDER BY revenue DESC;

-- 15. Customer Cohort and Monthly Retention Analysis

WITH CustomerFirstPurchase AS (
    SELECT
        customer_id,
        MIN(DATE(order_date, 'start of month')) AS cohort_month
    FROM orders
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),

CustomerActivity AS (
    SELECT DISTINCT
        o.customer_id,
        DATE(o.order_date, 'start of month') AS activity_month
    FROM orders o
    WHERE o.customer_id IS NOT NULL
),

CohortActivity AS (
    SELECT
        cfp.cohort_month,
        ca.activity_month,
        ca.customer_id
    FROM CustomerFirstPurchase cfp
    JOIN CustomerActivity ca
        ON cfp.customer_id = ca.customer_id
),

CohortSize AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_customers
    FROM CohortActivity
    WHERE activity_month = cohort_month
    GROUP BY cohort_month
),

CohortRetention AS (
    SELECT
        ca.cohort_month,
        ca.activity_month,
        COUNT(DISTINCT ca.customer_id) AS active_customers,
        cs.cohort_customers
    FROM CohortActivity ca
    JOIN CohortSize cs
        ON ca.cohort_month = cs.cohort_month
    GROUP BY
        ca.cohort_month,
        ca.activity_month,
        cs.cohort_customers
)

SELECT
    cohort_month,
    activity_month,
    active_customers,
    cohort_customers,
    ROUND(
        active_customers * 100.0 / cohort_customers,
        2
    ) AS retention_rate_percent
FROM CohortRetention
ORDER BY
    cohort_month,
    activity_month;

-- 16. RFM-Style Customer Segmentation

WITH CustomerMetrics AS (
    SELECT
        o.customer_id,

        -- Recency: Days since last purchase
        CAST(
            JULIANDAY('now') -
            JULIANDAY(MAX(o.order_date))
            AS INTEGER
        ) AS recency_days,

        -- Frequency: Number of orders
        COUNT(DISTINCT o.order_id) AS order_frequency,

        -- Monetary: Total customer spending
        ROUND(
            SUM(
                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        ) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.customer_id IS NOT NULL

    GROUP BY o.customer_id
),

CustomerSegments AS (
    SELECT
        customer_id,
        recency_days,
        order_frequency,
        monetary_value,

        -- Purchase Frequency Segment
        CASE
            WHEN order_frequency = 1
                THEN 'One-time'

            WHEN order_frequency BETWEEN 2 AND 4
                THEN 'Occasional'

            ELSE 'Loyal'
        END AS purchase_segment,

        -- Spending Segment
        CASE
            WHEN monetary_value < 5000
                THEN 'Low'

            WHEN monetary_value < 15000
                THEN 'Medium'

            ELSE 'High'
        END AS spend_segment

    FROM CustomerMetrics
)

SELECT
    customer_id,
    recency_days,
    order_frequency,
    monetary_value,
    purchase_segment,
    spend_segment
FROM CustomerSegments
ORDER BY monetary_value DESC;

-- 17. Customer Segment Summary

WITH CustomerMetrics AS (
    SELECT
        o.customer_id,

        COUNT(DISTINCT o.order_id) AS order_frequency,

        ROUND(
            SUM(
                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100.0)
            ),
            2
        ) AS monetary_value

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.customer_id IS NOT NULL

    GROUP BY o.customer_id
),

CustomerSegments AS (
    SELECT
        customer_id,
        order_frequency,
        monetary_value,

        CASE
            WHEN order_frequency = 1
                THEN 'One-time'
            WHEN order_frequency BETWEEN 2 AND 4
                THEN 'Occasional'
            ELSE 'Loyal'
        END AS purchase_segment,

        CASE
            WHEN monetary_value < 5000
                THEN 'Low'
            WHEN monetary_value < 15000
                THEN 'Medium'
            ELSE 'High'
        END AS spend_segment

    FROM CustomerMetrics
)

SELECT
    purchase_segment,
    spend_segment,
    COUNT(*) AS customer_count
FROM CustomerSegments
GROUP BY
    purchase_segment,
    spend_segment
ORDER BY
    purchase_segment,
    spend_segment;