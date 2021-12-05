{{
  config(
    materialized='view'
  )
}}

{% set event_types = [ 
    'delete_from_cart'
    ,'checkout'
    ,'page_view'
    ,'add_to_cart'
    ,'package_shipped'
    ,'account_created'
]
%}

WITH all_events AS (
    SELECT  *
    FROM {{ref ('stg_events')}} )

, all_products AS ( 
    SELECT  *
    FROM {{ref ('stg_products')}} )

, product_by_session AS (

    SELECT DISTINCT 
      session_guid
     ,event_type
     ,CASE WHEN event_type IN ('add_to_cart') AND split_part(page_url, '/',4) = 'product' THEN split_part(page_url, '/',5) END as product_guid_grab
     ,SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) OVER(PARTITION BY session_guid) as conversions

FROM all_events AS ae)


SELECT 
    session_guid
     , pbs.product_guid_grab
     , p.name
     , MAX(conversions) as session_converted
     , MAX(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS been_viewed
     , MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart

FROM product_by_session AS pbs
LEFT JOIN all_products p ON p.product_guid = pbs.product_guid_grab
GROUP BY 1,2,3