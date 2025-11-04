-- 8.Revenue Impact: Estimate revenue loss from pre-crisis vs crisis (based on
-- subtotal, discount, and delivery fee).




WITH revenue_data AS (
    SELECT
        CASE
            WHEN TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05' THEN 'pre_crisis'
            WHEN TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-09' THEN 'crisis'
        END AS period,
        SUM(subtotal_amount - discount_amount + delivery_fee) AS total_revenue
    FROM
        fact_orders
    WHERE
        is_cancelled = 'N'
        AND TO_CHAR(order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-09'
    GROUP BY
        period
)
SELECT
    pre.total_revenue AS pre_crisis_revenue,
    crisis.total_revenue AS crisis_revenue,
    ROUND(pre.total_revenue - crisis.total_revenue, 2) AS estimated_revenue_loss,
    ROUND(((pre.total_revenue - crisis.total_revenue) / pre.total_revenue) * 100, 2) AS percent_drop
FROM revenue_data AS pre, revenue_data AS crisis
WHERE pre.period = 'pre_crisis' AND crisis.period = 'crisis';



