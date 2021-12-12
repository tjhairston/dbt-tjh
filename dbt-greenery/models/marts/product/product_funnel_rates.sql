{{
  config(
    materialized='table'
  )
}}

SELECT  
  ROUND((page_viewed_count / unquie_session_count::DECIMAL),2) * 100 as page_view_rate, 
  ROUND((add_to_cart_count / unquie_session_count::DECIMAL),2) * 100 as add_to_cart_rate, 
  ROUND((checkout_count / unquie_session_count::DECIMAL),2) * 100 as checkout_rate
FROM {{ ref('product_funnel_rates_agg') }} 