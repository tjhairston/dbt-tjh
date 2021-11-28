{{
  config(
    materialized='table'
  )
}}

SELECT
     du.user_id
    ,du.user_guid
    ,du.first_name
    ,du.last_name
    ,du.email
    ,du.phone_number
    ,du.address_guid
    ,du.address
    ,du.zipcode
    ,du.state
    ,du.country
    ,du.created_at_utc
    ,du.updated_at_utc
    ,du.customer_tenure
    ,MIN(fo.order_created_at_utc) as first_order_created_at_utc
    ,MAX(fo.order_created_at_utc) as last_order_created_at_utc
    ,COUNT(distinct fo.order_guid) as count_orders
    ,AVG(fo.order_total) as avg_order_total
    ,AVG(fo.order_cost) as avg_order_cost
    ,SUM(fo.quantity)/count(fo.order_guid) as avg_cart_size_per_order
    ,SUM(CASE WHEN fo.order_status = 'shipped' THEN 1 ELSE 0 END) as count_orders_shipped
    ,SUM(CASE WHEN fo.order_status = 'pending' THEN 1 ELSE 0 END) as count_orders_pending
    ,SUM(CASE WHEN fo.order_status = 'preparing' THEN 1 ELSE 0 END) as count_orders_preparing
    ,SUM(CASE WHEN fo.order_status = 'delivered' THEN 1 ELSE 0 END) as count_orders_delivered
    ,SUM(CASE fo.discount WHEN NULL THEN 0 ELSE 1 END) as count_orders_with_promo

FROM {{ ref('fact_orders') }} fo
  LEFT JOIN {{ ref('dim_users') }} du
    on fo.user_guid = du.user_guid

GROUP BY
    du.user_id
    ,du.user_guid
    ,du.first_name
    ,du.last_name
    ,du.email
    ,du.address_guid
    ,du.address
    ,du.zipcode
    ,du.state
    ,du.country
    ,du.phone_number
    ,du.created_at_utc
    ,du.updated_at_utc
    ,du.customer_tenure