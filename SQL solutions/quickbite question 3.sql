-- 3.Among restaurants with at least 50 pre-crisis orders, which top 10 high-volume
-- restaurants experienced the largest percentage decline in order counts during
-- the crisis period?



WITH restaurant_orders AS (
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        CASE 
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05' THEN 'pre_crisis'
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-08' THEN 'crisis'
        END AS period,
        COUNT(o.order_id) AS total_orders
    FROM
        fact_orders AS o
    JOIN
        dim_restaurant AS r
    ON
        o.restaurant_id = r.restaurant_id
    WHERE
        TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-08'
    GROUP BY
        r.restaurant_id, r.restaurant_name, period
)
SELECT
    pre.restaurant_name,
    pre.total_orders AS pre_crisis_orders,
    crisis.total_orders AS crisis_orders,
    ROUND(
        ((pre.total_orders - crisis.total_orders)::NUMERIC / pre.total_orders) * 100,
        2
    ) AS percentage_decline
FROM
    restaurant_orders pre
JOIN
    restaurant_orders crisis
    ON pre.restaurant_id = crisis.restaurant_id
    AND pre.period = 'pre_crisis'
    AND crisis.period = 'crisis'
ORDER BY
    percentage_decline DESC
LIMIT 10;
