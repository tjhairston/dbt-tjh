{{
  config(
    materialized='table'
  )
}}

SELECT
   oi.order_guid
  ,oi.product_guid
  ,oi.quantity
  ,ioq.user_guid
  ,ioq.order_cost
  ,ioq.shipping_cost
  ,ioq.order_total
  ,ioq.unique_items_in_order
  ,ioq.total_items_in_order
  ,ioq.tracking_guid
  ,pm.discount
  ,pm.promo_guid
  ,ioq.created_at_utc as order_created_at_utc
  ,ioq.delivered_at_utc as order_delivered_at_utc
  ,ioq.shipping_service
  ,ioq.status as order_status
  ,ioq.delivered_at_utc - ioq.estimated_delivery_at_utc as actual_vs_estimated_delivery_diff
  ,ioq.delivered_at_utc - ioq.created_at_utc as time_to_delivery
  ,p.name as product_name
  ,p.price as product_price

FROM {{ ref('stg_order_items') }} oi
    LEFT JOIN {{ ref('int_order_qty_dtls') }} ioq
        ON oi.order_guid = ioq.order_guid
    LEFT JOIN {{ ref('stg_products') }} p
        ON oi.product_guid = p.product_guid
    LEFT JOIN {{ ref('stg_promos') }} pm
        ON pm.promo_guid = ioq.promo_guid

WHERE order_total > 0

GROUP BY 
    oi.order_guid
    ,ioq.user_guid
    ,order_created_at_utc
    ,order_delivered_at_utc
    ,order_cost
    ,pm.promo_guid
    ,ioq.order_total
    ,ioq.shipping_service
    ,ioq.shipping_cost
    ,order_status
    ,ioq.tracking_guid
    ,pm.discount
    ,actual_vs_estimated_delivery_diff
    ,time_to_delivery
    ,oi.product_guid 
    ,oi.quantity
    ,product_name
    ,product_price
    ,ioq.unique_items_in_order
    ,ioq.total_items_in_order