-- 5.Delivery SLA: Measure average delivery time across phases. Did SLA
-- compliance worsen significantly in the crisis period?

WITH delivery_data AS (
    SELECT
        o.order_id,
        CASE
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-05' THEN 'pre_crisis'
            WHEN TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-08' THEN 'crisis'
        END AS period,
        d.actual_delivery_time_mins,
        d.expected_delivery_time_mins
    FROM
        fact_orders AS o
    JOIN
        fact_delivery_performance AS d
    ON
        o.order_id = d.order_id
    WHERE
        TO_CHAR(o.order_timestamp, 'YYYY-MM') BETWEEN '2025-01' AND '2025-08'
),

sla_summary AS (
    SELECT
        period,
        ROUND(AVG(actual_delivery_time_mins), 2) AS avg_actual_delivery_time,
        ROUND(AVG(expected_delivery_time_mins), 2) AS avg_expected_delivery_time,
        ROUND(
            (SUM(CASE WHEN actual_delivery_time_mins <= expected_delivery_time_mins THEN 1 ELSE 0 END)::NUMERIC
            / COUNT(*)) * 100, 2
        ) AS sla_compliance_rate
    FROM
        delivery_data
    WHERE
        period IS NOT NULL
    GROUP BY
        period
)

SELECT
    pre.period AS pre_crisis_period,
    pre.avg_actual_delivery_time AS pre_crisis_avg_time,
    crisis.avg_actual_delivery_time AS crisis_avg_time,
    ROUND((crisis.avg_actual_delivery_time - pre.avg_actual_delivery_time), 2) AS delivery_time_change,
    pre.sla_compliance_rate AS pre_crisis_sla,
    crisis.sla_compliance_rate AS crisis_sla,
    ROUND((pre.sla_compliance_rate - crisis.sla_compliance_rate), 2) AS sla_drop_percentage
FROM
    sla_summary pre
JOIN
    sla_summary crisis
    ON pre.period = 'pre_crisis'
   AND crisis.period = 'crisis';
