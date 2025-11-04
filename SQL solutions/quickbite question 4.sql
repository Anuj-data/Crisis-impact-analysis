-- 4.Cancellation Analysis: What is the cancellation rate trend pre-crisis vs crisis,
-- and which cities are most affected?


-- 👇 make sure this starts as a fresh query (no leftover text before this)
WITH cancellation_data AS (
    SELECT
        r.city,
        CASE
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05' THEN 'pre_crisis'
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-08' THEN 'crisis'
        END AS period,
        COUNT(o.order_id) AS total_orders,
        SUM(CASE WHEN o.is_cancelled = 'Y' THEN 1 ELSE 0 END) AS cancelled_orders
    FROM
        fact_orders AS o
    JOIN
        dim_restaurant AS r
    ON
        o.restaurant_id = r.restaurant_id
    WHERE
        TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-08'
    GROUP BY
        r.city, period
),
cancellation_rate AS (
    SELECT
        city,
        period,
        ROUND((cancelled_orders::NUMERIC / total_orders) * 100, 2) AS cancellation_rate
    FROM
        cancellation_data
)
SELECT
    pre.city,
    pre.cancellation_rate AS pre_crisis_cancellation_rate,
    crisis.cancellation_rate AS crisis_cancellation_rate,
    ROUND((crisis.cancellation_rate - pre.cancellation_rate), 2) AS rate_change
FROM
    cancellation_rate pre
JOIN
    cancellation_rate crisis
    ON pre.city = crisis.city
   AND pre.period = 'pre_crisis'
   AND crisis.period = 'crisis'
ORDER BY
    rate_change DESC
LIMIT 10;

