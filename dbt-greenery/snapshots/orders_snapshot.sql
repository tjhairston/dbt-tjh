{% snapshot snap_orders_check %}

    {{
        config(
          target_schema='snapshots',
          strategy='check',
          unique_key='order_id',
          check_cols=['status'],
        )
    }}

    select * from {{ref('stg_orders')}}

{% endsnapshot %}