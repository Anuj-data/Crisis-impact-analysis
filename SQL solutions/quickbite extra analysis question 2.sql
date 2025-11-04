-- 2.Behavior Shifts: Did customers shift from high-value orders to low-value
-- “survival orders” during crisis?


WITH order_value_category AS (
    SELECT
        CASE 
            WHEN TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05' THEN 'Pre-Crisis'
            WHEN TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-09' THEN 'Crisis'
        END AS period,
        CASE
            WHEN total_amount >= 500 THEN 'High-Value'
            ELSE 'Low-Value'
        END AS order_type
    FROM
        fact_orders
    WHERE
        is_cancelled = 'N'
        AND TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-09'
)
SELECT
    period,
    order_type,
    COUNT(*) AS total_orders,
    ROUND(
        (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY period)),
        2
    ) AS percentage_share
FROM
    order_value_category
GROUP BY
    period, order_type
ORDER BY
    period, order_type;
