{{
  config(
    materialized='table'
  )
}}

WITH agg_order_dtls AS (
  SELECT 
    order_guid, 
    COUNT(DISTINCT product_guid) AS unique_items_in_order,
    SUM(quantity) AS total_items_in_order
  FROM {{ ref('stg_order_items') }}
  GROUP BY 1
)

SELECT 
  order_guid, 
  user_guid,
  promo_guid, 
  address_guid, 
  created_at_utc, 
  order_cost, 
  shipping_cost, 
  order_total, 
  unique_items_in_order, 
  total_items_in_order,
  tracking_guid, 
  shipping_service, 
  estimated_delivery_at_utc, 
  delivered_at_utc, 
  status   
FROM {{ ref('stg_orders') }} 
JOIN agg_order_dtls USING (order_guid) 