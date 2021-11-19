% snapshot snap_addresses_check %}

    {{
        config(
          target_schema='snapshots',
          strategy='check',
          unique_key='address_id',
          check_cols=['address', 'zipcode','state','country'],
        )
    }}

    select * from {{ref('stg_addresses')}}

{% endsnapshot %}