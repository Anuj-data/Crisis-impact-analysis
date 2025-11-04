--PRIMARY ANALYSIS

--1. Monthly Orders: Compare total orders across pre-crisis (Jan–May 2025) vs crisis
--(Jun–Sep 2025). How severe is the decline?

WITH monthly_orders AS (
    SELECT
        TO_CHAR(order_timestamp, 'YYYY-MM') AS order_month,
        COUNT(order_id) AS total_orders
    FROM
        fact_orders
    WHERE
        TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-09'
    GROUP BY
        TO_CHAR(order_timestamp, 'YYYY-MM')
)
SELECT
    SUM(CASE WHEN order_month BETWEEN '2025-01' AND '2025-05' THEN total_orders ELSE 0 END) AS pre_crisis_orders,
    SUM(CASE WHEN order_month BETWEEN '2025-06' AND '2025-09' THEN total_orders ELSE 0 END) AS crisis_orders,
    ROUND(
        (SUM(CASE WHEN order_month BETWEEN '2025-06' AND '2025-09' THEN total_orders ELSE 0 END)::numeric /
         SUM(CASE WHEN order_month BETWEEN '2025-01' AND '2025-05' THEN total_orders ELSE 0 END)::numeric - 1) * 100,
        2
    ) AS decline_percent
FROM
    monthly_orders;



