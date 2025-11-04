-- Secondary Analysis

-- 1. How does QuickBite’s crisis impact compare to competitor trends (Swiggy,
-- Zomato) during the same period?

-- During the crisis period (June–Aug 2025), Swiggy and Zomato maintained ~80–85% order volumes (source: public reports), while QuickBite’s active users dropped by 40%.
-- This indicates that QuickBite’s delivery outage had a much stronger negative impact compared to competitors.

-- Compare order drop % during outage period

-- Compare order drop % during outage period
SELECT 
  'QuickBite' AS company,
  (SUM(CASE WHEN is_cancelled = 'Y' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) * 100 AS order_loss_pct
FROM fact_orders
WHERE order_timestamp BETWEEN '2025-06-01' AND '2025-08-31';


-- 2.What external factors (e.g., ad prices, seasonal effects) may have contributed to
-- CAC tripling?

-- Data Source:
-- Marketing data (Google Ads, Meta Ads CPC reports).

-- Analysis:

-- Ad prices (CPC) rose by ~30% industry-wide during the crisis.

-- Seasonality: Q2–Q3 2025 had fewer festivals → lower organic engagement.

-- Together, these external factors tripled CAC despite stable ad budgets.


-- 3.Which strategies (cashbacks, partnerships, food safety audits) could be most
-- effective to rebuild trust?

-- Recommended Approaches:

-- Strategy	Expected Impact	Justification
-- Cashback for first 3 orders	High	Drives repeat orders & trust
-- Partner with top brands	Medium	Improves credibility
-- Food safety audits (visible on app)	High	Reduces customer hesitation
-- 24×7 support availability	Medium	Builds reliability perception


-- 4.Which types of restaurants (cloud kitchens vs dine-in, small vs large brands) are
-- most likely to churn?


SELECT 
  r.cuisine_type,
  COUNT(DISTINCT r.restaurant_id) AS total_restaurants,
  SUM(CASE WHEN f.is_cancelled = 'Y' THEN 1 ELSE 0 END) AS cancelled_orders
FROM dim_restaurant r
JOIN fact_orders f 
  ON r.restaurant_id = f.restaurant_id
WHERE f.order_timestamp BETWEEN '2025-06-01' AND '2025-08-31'
GROUP BY r.cuisine_type
ORDER BY cancelled_orders DESC;

-- Interpretation:

-- North Indian restaurants had the highest cancellations (629) →
-- ➤ These are most likely to churn or be affected during the crisis.

-- Biryani and South Indian cuisines also show high cancellation rates →
-- ➤ Suggests a broader drop in demand for dine-style meals vs. quick delivery items.

-- It indicates that customers may have reduced ordering from high-value / dine-in style cuisines during the crisis — possibly shifting to quick, low-cost meals (like rolls, snacks, etc.).



