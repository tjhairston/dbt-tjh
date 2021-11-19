{{
  config(
    materialized='table',
    unique_key='user_id'
  )
}}

with users_source as (
    select * from {{source('src_public','users')}}
) 

, renamed_casted as (
    SELECT 
        id as user_id
        , user_id as user_guid
        ,address_id as address_guid
        ,first_name
        ,last_name
        ,email
        ,phone_number
        ,created_at as created_at_utc
        ,updated_at as updated_at_utc
    FROM users_source
)

SELECT * from renamed_casted