-- EXTRA ANALYSIS

-- 1.Priority Cities: Which Tier-1/Tier-2 cities show the highest risk of long-term
-- demand loss?

WITH city_demand AS (
  SELECT 
    dr.city,
    CASE 
      WHEN fd.order_timestamp < '2025-03-01' THEN 'Before Crisis'
      ELSE 'During Crisis'
    END AS period,
    COUNT(DISTINCT fd.order_id) AS total_orders,
    SUM(fd.total_amount) AS total_spend
  FROM fact_orders fd
  JOIN dim_restaurant dr 
    ON fd.restaurant_id = dr.restaurant_id
  WHERE fd.is_cancelled = 'N'
  GROUP BY dr.city, period
),
city_change AS (
  SELECT 
    city,
    MAX(CASE WHEN period = 'Before Crisis' THEN total_orders END) AS orders_before,
    MAX(CASE WHEN period = 'During Crisis' THEN total_orders END) AS orders_during,
    MAX(CASE WHEN period = 'Before Crisis' THEN total_spend END) AS spend_before,
    MAX(CASE WHEN period = 'During Crisis' THEN total_spend END) AS spend_during
  FROM city_demand
  GROUP BY city
)
SELECT 
  city,
  ROUND((((orders_during::numeric / NULLIF(orders_before, 0)) - 1) * 100), 2) AS order_change_pct,
  ROUND((((spend_during::numeric / NULLIF(spend_before, 0)) - 1) * 100), 2) AS spend_change_pct
FROM city_change
ORDER BY order_change_pct ASC
LIMIT 10;
