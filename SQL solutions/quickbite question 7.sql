-- 7.Sentiment Insights: During the crisis period, identify the most frequently
-- occurring negative keywords in customer review texts. (Hint: Use a Word Cloud
-- visual in Power BI to visualize the findings.)



WITH crisis_reviews AS (
    SELECT
        LOWER(review_text) AS review_text
    FROM
        fact_ratings
    WHERE
        TO_CHAR(review_timestamp::timestamp, 'YYYY-MM') BETWEEN '2025-06' AND '2025-08'
        AND (
            (sentiment_score IS NOT NULL AND sentiment_score::numeric < 0)
            OR (rating::numeric < 3)
        )
        AND review_text IS NOT NULL
)
SELECT
    word,
    COUNT(*) AS frequency
FROM (
    SELECT
        unnest(string_to_array(regexp_replace(review_text, '[^a-zA-Z\s]', '', 'g'), ' ')) AS word
    FROM
        crisis_reviews
) AS words
WHERE
    word NOT IN ('the','is','and','to','a','of','in','it','for','was','on','this','with','at','very','i','we','you','my','they','so','but','had','too')
    AND LENGTH(word) > 2
GROUP BY
    word
ORDER BY
    frequency DESC
LIMIT 30;
