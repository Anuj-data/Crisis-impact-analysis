-- 3.Feedback Trends: Do spikes in negative reviews align with the delivery outage
-- period?

WITH delivery_review_data AS (
    SELECT
        TO_CHAR(r.review_timestamp::timestamp, 'YYYY-MM') AS month,
        CASE 
            WHEN (d.actual_delivery_time_mins - d.expected_delivery_time_mins) > 0 THEN 'Late'
            ELSE 'On-Time'
        END AS delivery_status,
        CASE 
            WHEN (r.sentiment_score IS NOT NULL AND r.sentiment_score::numeric < 0)
                 OR (r.rating ~ '^\s*\d+(\.\d+)?\s*$' AND r.rating::numeric <= 2)
            THEN 'Negative'
            ELSE 'Non-Negative'
        END AS review_type
    FROM fact_ratings r
    JOIN fact_delivery_performance d 
        ON r.order_id = d.order_id
    WHERE r.review_timestamp >= '2025-01-01'
)
SELECT
    month,
    SUM(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_deliveries,
    SUM(CASE WHEN review_type = 'Negative' THEN 1 ELSE 0 END) AS negative_reviews,
    ROUND(
        (SUM(CASE WHEN review_type = 'Negative' THEN 1 ELSE 0 END) * 100.0 / COUNT(*))::numeric,
        2
    ) AS negative_review_percentage
FROM
    delivery_review_data
GROUP BY
    month
ORDER BY
    month;

