{% snapshot snap_products_check %}

    {{
        config(
          target_schema='snapshots',
          strategy='check',
          unique_key='product_id',
          check_cols=['price','quantity'],
        )
    }}

    select * from {{ref('stg_products')}}

{% endsnapshot %}