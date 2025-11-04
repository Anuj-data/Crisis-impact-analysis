-- 6.Ratings Fluctuation: Track average customer rating month-by-month. Which
-- months saw the sharpest drop?




WITH monthly_ratings AS (
  SELECT
    TO_CHAR(review_timestamp::timestamp, 'YYYY-MM') AS month,
    -- safe numeric conversion: only numeric strings will be cast, others -> NULL
    ROUND(AVG(
      CASE 
        WHEN rating ~ '^\s*\d+(\.\d+)?\s*$' THEN (rating)::numeric
        ELSE NULL
      END
    )::numeric, 2) AS avg_rating
  FROM fact_ratings
  GROUP BY TO_CHAR(review_timestamp::timestamp, 'YYYY-MM')
)
SELECT
  month,
  avg_rating,
  LAG(avg_rating) OVER (ORDER BY month) AS prev_month_rating,
  ROUND((avg_rating - LAG(avg_rating) OVER (ORDER BY month)), 2) AS rating_change
FROM monthly_ratings
ORDER BY month;





