{{
  config(
    materialized='table',
    unique_key='order_id'
  )
}}

with order_items_source as (
    select * from {{source('src_public','order_items')}}
) 

, renamed_casted as (
    SELECT 
        id as order_items_id
        ,order_id as order_guid
        ,product_id as product_guid
        ,quantity
    FROM order_items_source
)

SELECT * from renamed_casted