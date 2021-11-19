{{
  config(
    materialized='table',
    unique_key='orders_id'
  )
}}

with orders_source as (
    select * from {{source('src_public','orders')}}
) 

, renamed_casted as (
    SELECT 
        id as order_id
        ,order_id as order_guid
        ,user_id as user_guid
        ,promo_id as promo_guid
        ,address_id as address_guid
        ,created_at as created_at_utc
        ,order_cost
        ,shipping_cost
        ,order_total
        ,tracking_id as tracking_guid
        ,shipping_service
        ,estimated_delivery_at as estimated_delivery_at_utc
        ,delivered_at as delivered_at_utc
        ,status
    FROM orders_source
)

SELECT * from renamed_casted