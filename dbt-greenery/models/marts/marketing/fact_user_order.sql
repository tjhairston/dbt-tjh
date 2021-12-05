{{
  config(
    materialized='table'
  )
}}

WITH users AS (
  SELECT
    DISTINCT user_guid
  FROM {{ ref('stg_users') }} 
),

order_details AS (
  SELECT 
    order_guid, 
  user_guid,
  promo_guid, 
  address_guid, 
  created_at_utc,  
  order_total, 
  unique_items_in_order, 
  total_items_in_order  
  FROM {{ ref('int_order_qty_dtls') }} 
) 

SELECT 
  user_guid, 
  order_guid,
  MIN(created_at_utc) as first_order_placed_at, 
  MAX(created_at_utc) as latest_order_placed_at, 
  COALESCE(COUNT(distinct order_guid), 0) as total_orders_placed, 
  SUM(CASE WHEN unique_items_in_order > 1 THEN 1 END ) as orders_with_multiple_unique_items, 
  MAX(total_items_in_order) as largest_order_quantity, 
  MAX(order_total) as largest_order_amount, 
  SUM(total_items_in_order) as lifetime_items_ordered, 
  SUM(order_total) as lifetime_order_amount
FROM users 
LEFT JOIN order_details USING (user_guid)
GROUP BY 1, 2