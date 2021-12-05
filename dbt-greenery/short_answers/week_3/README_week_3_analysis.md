### Questions 

## What is our overall conversion rate?
# Query
WITH  con_rate AS (
SELECT 
    SUM(count_checkout) as total_conversions, 
    COUNT(distinct session_guid) as total_sessions
 FROM fact_page_views
)
SELECT 
total_conversions, total_sessions, (round((total_conversions / total_sessions *100),2))  as conversion_rate
FROM con_rate

# Results:


| total_conversions | total_sessions | conversion_rate |
|-------------------|---------------|----------------|
|       400         |     1108      |    36.10      |

## What is the conversion rate per product?
# Query 
WITH rate_per_prod AS (
SELECT name, 
COUNT(DISTINCT session_guid) as total_sessions, 
COUNT(DISTINCT CASE WHEN session_converted = 1 then session_guid END):: numeric as converted_sessions

FROM session_events_agg 
WHERE name IS NOT NULL 
GROUP BY 1)

SELECT 
    name, 
    total_sessions, 
    converted_sessions, 
    ROUND(converted_sessions/total_sessions*100,2) as conversion_rate 
FROM rate_per_prod 
ORDER BY 3 desc

# Results:
<img width="307" alt="Screen Shot 2021-12-05 at 3 26 44 PM" src="https://user-images.githubusercontent.com/81575873/144762753-b354dfda-a88d-4bc1-be2a-900cb05fab3c.png">

## Why might some products might be converting more than other?
* There could be a number of reason why some products are converting more than othrs, maybe some items are discounted more, have more or more promo use or it could be as simple as soome products sell better. 
