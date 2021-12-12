{{
  config(
    materialized='table'
  )
}}

WITH session_bool as(
SELECT 
      session_guid,
      COUNT(CASE WHEN event_type='page_view' THEN 1 END) AS pv,
      COUNT(CASE WHEN event_type='add_to_cart' THEN 1 END) AS atc,
      COUNT(CASE WHEN event_type='checkout' THEN 1 END) AS co
FROM {{ref ('dim_events')}} 
GROUP BY session_guid
)

SELECT 
      COUNT(CASE WHEN (pv >0 or atc >0 or co >0) THEN 1 END) AS level_1,
      COUNT(CASE WHEN (atc > 0 or co > 0) THEN 1 END) AS level_2,
      COUNT(CASE WHEN (co > 0) THEN 1 END) AS level_3
FROM session_bool
