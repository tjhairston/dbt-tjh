{{
  config(
    materialized='table',
    unique_key = 'address_id'
  )
}}

with addresses_source as (
    select * from {{source('src_public','addresses')}}
) 

, renamed_casted as (
    SELECT 
        id as address_id
        ,address_id as address_guid
        ,address
        ,zipcode
        ,state
        ,country
    FROM addresses_source
)

SELECT * from renamed_casted