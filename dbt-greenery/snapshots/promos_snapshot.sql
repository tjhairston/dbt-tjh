{% snapshot snap_promos_check %}

    {{
        config(
          target_schema='snapshots',
          strategy='check',
          unique_key='promo_id',
          check_cols=['discount','status'],
        )
    }}

    select * from {{ref('stg_promos')}}

{% endsnapshot %}