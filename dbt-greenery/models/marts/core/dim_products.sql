{{
  config(
    materialized='table' ,
    primary_key ='product_id'
  )
}}

SELECT
  product_id
  , name as product_name
  , price
  , quantity
  
FROM {{ ref('stg_products') }}