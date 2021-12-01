{{
  config(
    materialized='table' ,
    primary_key ='product_guid'
  )
}}

SELECT
  product_guid
  , name as product_name
  , price
  , quantity
  
FROM {{ ref('stg_products') }}