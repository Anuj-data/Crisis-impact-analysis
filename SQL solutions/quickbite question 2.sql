--Which top 5 city groups experienced the highest percentage decline in orders
--during the crisis period compared to the pre-crisis period?




WITH city_orders AS (
    SELECT
        r.city,
        CASE 
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05' THEN 'pre_crisis'
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-09' THEN 'crisis'
        END AS period,
        COUNT(o.order_id) AS total_orders
    FROM
        fact_orders AS o
    JOIN
        dim_restaurant AS r
    ON
        o.restaurant_id = r.restaurant_id
    WHERE
        TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-09'
    GROUP BY
        r.city,
        period
)
SELECT
    pre.city,
    pre.total_orders AS pre_crisis_orders,
    crisis.total_orders AS crisis_orders,
    ROUND(
        ((pre.total_orders - crisis.total_orders)::NUMERIC / pre.total_orders) * 100, 
        2
    ) AS percentage_decline
FROM
    city_orders pre
JOIN
    city_orders crisis
ON
    pre.city = crisis.city
   AND pre.period = 'pre_crisis'
   AND crisis.period = 'crisis'
ORDER BY
    percentage_decline DESC
LIMIT 5;





