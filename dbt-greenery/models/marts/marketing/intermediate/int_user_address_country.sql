
{{
  config(
    materialized='table'
  )
}}


WITH address_location AS (
  SELECT
    address_guid, 
    state,
    country
  FROM {{ ref('stg_addresses') }}
), 

address_validity AS (
  SELECT
    user_guid, 
    address_guid, 
    dbt_valid_from as address_valid_from, 
    dbt_valid_to as address_valid_to
  FROM {{ ref('users_snapshot') }}
)

SELECT 
  user_guid,
  state, 
  country, 
  address_valid_from, 
  address_valid_to
FROM address_validity
JOIN address_location USING (address_guid)