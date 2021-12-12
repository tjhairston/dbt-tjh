{{
  config(
    materialized='view'
  )
}}

WITH add_to_cart_rate AS (

SELECT 1 as col_index, count(DISTINCT session_guid) AS add_to_cart_count
FROM {{ ref('dim_events') }} 
WHERE event_type = 'add_to_cart'
) 

, page_view_rate AS (

SELECT 1 as col_index, count(DISTINCT session_guid) AS page_viewed_count
FROM {{ ref('dim_events') }} 
WHERE event_type = 'page_view'
)

, check_out_rate AS (

SELECT 1 as col_index, count(DISTINCT session_guid) AS checkout_count

FROM {{ ref('dim_events') }} 
WHERE event_type = 'checkout'
)

, total_unquie_sessions AS (

SELECT 1 as col_index, count(DISTINCT session_guid) AS unquie_session_count
FROM {{ ref('dim_events') }}
)


SELECT  
  tus.unquie_session_count as unquie_session_count, 
  pvr.page_viewed_count as page_viewed_count, 
  atcr.add_to_cart_count as add_to_cart_count, 
  cor.checkout_count as checkout_count
from total_unquie_sessions tus
JOIN page_view_rate pvr
ON tus.col_index = pvr.col_index
JOIN check_out_rate cor
ON pvr.col_index = cor.col_index
JOIN add_to_cart_rate atcr
ON cor.col_index = atcr.col_index

