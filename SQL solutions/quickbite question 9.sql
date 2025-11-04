-- 9.Loyalty Impact: Among customers who placed five or more orders before the
-- crisis, determine how many stopped ordering during the crisis, and out of those,
-- how many had an average rating above 4.5?


WITH pre_crisis_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS pre_orders
    FROM
        fact_orders
    WHERE
        TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05'
        AND is_cancelled = 'N'
    GROUP BY
        customer_id
    HAVING
        COUNT(order_id) >= 5
),
crisis_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS crisis_orders
    FROM
        fact_orders
    WHERE
        TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-09'
        AND is_cancelled = 'N'
    GROUP BY
        customer_id
),
stopped_customers AS (
    SELECT
        p.customer_id
    FROM
        pre_crisis_orders p
    LEFT JOIN
        crisis_orders c
    ON
        p.customer_id = c.customer_id
    WHERE
        c.customer_id IS NULL  -- customers who stopped ordering
),
customer_ratings AS (
    SELECT
        customer_id,
        ROUND(AVG(rating::NUMERIC), 2) AS avg_rating
    FROM
        fact_ratings
    GROUP BY
        customer_id
)
SELECT
    COUNT(s.customer_id) AS total_stopped_customers,
    COUNT(CASE WHEN r.avg_rating > 4.5 THEN 1 END) AS high_rated_stopped_customers
FROM
    stopped_customers s
LEFT JOIN
    customer_ratings r
ON
    s.customer_id = r.customer_id;
