{% snapshot users_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='user_id',

      strategy='timestamp',
      updated_at='updated_at_utc'
    )
  }}

  select * 
  from {{ ref('stg_users') }}

{% endsnapshot %}