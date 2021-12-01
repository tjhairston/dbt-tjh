{{
  config(
    materialized='table'
  )
}}

SELECT
  user_guid
  ,session_guid
  ,session_date_utc
  ,event_created_at_utc
  ,COUNT(DISTINCT session_guid) total_sessions
  ,COUNT(DISTINCT event_guid) total_views
  ,SUM(CASE WHEN event_type = 'delete_from_cart' THEN 1 ELSE 0 END) as count_delete_from_cart
  ,SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) as count_checkout
  ,SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) as count_page_view
  ,SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) as count_add_to_cart
  ,SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) as count_package_shipped
  ,SUM(CASE WHEN event_type = 'account_created' THEN 1 ELSE 0 END) as count_account_created

FROM {{ ref('dim_events') }} 

GROUP BY    
user_guid
,session_guid
,session_date_utc
,event_created_at_utc