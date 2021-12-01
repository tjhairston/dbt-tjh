/* 
  Dimension model at the user granularity, contains data thats relevant at the custumer level 
  including address information and tenure of customer.
*/ 
{{
    config(
        materialized = 'table',
        unique_key = 'user_guid'
        )
}}

SELECT
  u.user_guid
  ,u.first_name
  ,u.last_name
  ,u.email
  ,u.phone_number
  ,u.address_guid
  ,u.created_at_utc as user_created_at_utc
  ,u.updated_at_utc
  ,NOW()-u.created_at_utc as customer_tenure
  ,a.address
  ,a.state
  ,a.zipcode
  ,a.country
FROM {{ ref('stg_users') }} AS u
LEFT JOIN {{ ref('stg_addresses') }} AS a
  on u.address_guid = a.address_guid

