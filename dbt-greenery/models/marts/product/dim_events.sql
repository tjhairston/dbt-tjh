{{
  config(
    materialized='table',
    unique_key='event_id'
  )
}}

SELECT
    event_guid
    ,session_guid
    ,user_guid
    ,event_type
    ,page_url
    ,created_at_utc as event_created_at_utc
    ,DATE(created_at_utc) as session_date_utc

FROM {{ ref('stg_events') }} 