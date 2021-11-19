{{
  config(
    materialized='table',
    unique_key='promo_id'
  )
}}

with promos_source as (
    select * from {{source('src_public','promos')}}
) 

, renamed_casted as (
    SELECT 
        id as promo_id
        ,promo_id as promo_guid
        ,discount
        ,status
        
    FROM promos_source
)

SELECT * from renamed_casted