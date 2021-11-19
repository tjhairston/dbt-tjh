{{
  config(
    materialized='table',
    unique_key='event_id'
  )
}}

with events_source as (
    select * from {{source('src_public','events')}}
) 

, renamed_casted as (
    SELECT 
        id as event_id
        ,event_id as event_guid
        ,session_id as session_guid
        ,user_id as user_guid
        ,page_url
        ,created_at as created_at_utc
        ,event_type
    FROM events_source
)

SELECT * from renamed_casted