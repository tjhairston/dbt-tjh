{{
  config(
    materialized='view',
    unique_key='product_guid'
  )
}}

with products_source as (
    select * from {{source('src_public','products')}}
) 

, renamed_casted as (
    SELECT 
        id as product_id
        ,product_id as product_guid
        ,name
        ,price
        ,quantity
    FROM products_source
)

SELECT * from renamed_casted