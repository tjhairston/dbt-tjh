{{
  config(
    materialized='table'
  )
}}

SELECT
   oi.order_guid
  ,oi.product_guid
  ,oi.quantity
  ,o.user_guid
  ,o.order_cost
  ,o.shipping_cost
  ,o.order_total
  ,pm.discount
  ,pm.promo_guid
  ,o.created_at_utc as order_created_at_utc
  ,o.delivered_at_utc as order_delivered_at_utc
  ,o.shipping_service
  ,o.status as order_status
  ,o.tracking_guid
  ,o.delivered_at_utc - o.estimated_delivery_at_utc as actual_vs_estimated_delivery_diff
  ,o.delivered_at_utc - o.created_at_utc as time_to_delivery
  ,p.name as product_name
  ,p.price as product_price

FROM {{ ref('stg_order_items') }} oi
    LEFT JOIN {{ ref('stg_orders') }} o
        ON oi.order_guid = o.order_guid
    LEFT JOIN {{ ref('stg_products') }} p
        ON oi.product_guid = p.product_guid
    LEFT JOIN {{ ref('stg_promos') }} pm
        ON pm.promo_guid = o.promo_guid

WHERE order_total > 0

GROUP BY 
    oi.order_guid
    ,o.user_guid
    ,order_created_at_utc
    ,order_delivered_at_utc
    ,order_cost
    ,pm.promo_guid
    ,o.order_total
    ,o.shipping_service
    ,o.shipping_cost
    ,order_status
    ,o.tracking_guid
    ,pm.discount
    ,actual_vs_estimated_delivery_diff
    ,time_to_delivery
    ,oi.product_guid 
    ,oi.quantity
    ,product_name
    ,product_price