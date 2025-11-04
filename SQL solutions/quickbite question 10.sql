-- 10. Customer Lifetime Decline: Which high-value customers (top 5% by total
-- spend before the crisis) showed the largest drop in order frequency and ratings
-- during the crisis? What common patterns (e.g., location, cuisine preference,
-- delivery delays) do they share?


WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(o.subtotal_amount - o.discount_amount + o.delivery_fee) AS total_spend_pre
    FROM
        fact_orders AS o
    WHERE
        TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05'
        AND o.is_cancelled = 'N'
    GROUP BY
        o.customer_id
),
top_customers AS (
    SELECT
        customer_id
    FROM
        customer_spend
    WHERE
        total_spend_pre >= (
            SELECT
                PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY total_spend_pre)
            FROM
                customer_spend
        )
),
order_summary AS (
    SELECT
        o.customer_id,
        CASE 
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05' THEN 'pre_crisis'
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-09' THEN 'crisis'
        END AS period,
        COUNT(o.order_id) AS total_orders,
        SUM(o.subtotal_amount - o.discount_amount + o.delivery_fee) AS total_revenue
    FROM
        fact_orders AS o
    WHERE
        o.is_cancelled = 'N'
        AND TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-09'
    GROUP BY
        o.customer_id, period
),
rating_summary AS (
    SELECT
        r.customer_id,
        CASE 
            WHEN TO_CHAR(r.review_timestamp::timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05' THEN 'pre_crisis'
            WHEN TO_CHAR(r.review_timestamp::timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-09' THEN 'crisis'
        END AS period,
        ROUND(AVG(r.rating::NUMERIC), 2) AS avg_rating
    FROM
        fact_ratings AS r
    WHERE
        TO_CHAR(r.review_timestamp::timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-09'
    GROUP BY
        r.customer_id, period
),
delivery_delay AS (
    SELECT
        o.customer_id,
        AVG(d.actual_delivery_time_mins - d.expected_delivery_time_mins) AS avg_delay,
        r.city,
        r.cuisine_type
    FROM
        fact_orders AS o
    JOIN
        fact_delivery_performance AS d ON o.order_id = d.order_id
    JOIN
        dim_restaurant AS r ON o.restaurant_id = r.restaurant_id
    WHERE
        o.is_cancelled = 'N'
    GROUP BY
        o.customer_id, r.city, r.cuisine_type
)
SELECT
    pre.customer_id,
    pre.total_orders AS pre_crisis_orders,
    crisis.total_orders AS crisis_orders,
    pre.total_revenue AS pre_crisis_revenue,
    crisis.total_revenue AS crisis_revenue,
    pre_rating.avg_rating AS pre_crisis_rating,
    crisis_rating.avg_rating AS crisis_rating,
    d.city,
    d.cuisine_type,
    ROUND(d.avg_delay, 2) AS avg_delivery_delay,
    ROUND(((pre.total_orders - crisis.total_orders)::NUMERIC / pre.total_orders) * 100, 2) AS order_decline_pct,
    ROUND(((pre_rating.avg_rating - crisis_rating.avg_rating)::NUMERIC), 2) AS rating_drop
FROM
    order_summary pre
JOIN
    order_summary crisis ON pre.customer_id = crisis.customer_id
    AND pre.period = 'pre_crisis' AND crisis.period = 'crisis'
JOIN
    top_customers t ON pre.customer_id = t.customer_id
LEFT JOIN
    rating_summary pre_rating ON pre.customer_id = pre_rating.customer_id AND pre_rating.period = 'pre_crisis'
LEFT JOIN
    rating_summary crisis_rating ON pre.customer_id = crisis_rating.customer_id AND crisis_rating.period = 'crisis'
LEFT JOIN
    delivery_delay d ON pre.customer_id = d.customer_id
ORDER BY
    order_decline_pct DESC
LIMIT 10;
