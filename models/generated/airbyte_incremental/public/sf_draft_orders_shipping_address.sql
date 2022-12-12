{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_shipping_address_ab3') }}
select
    _airbyte_sf_draft_orders_hashid,
    zip,
    city,
    {{ adapter.quote('name') }},
    phone,
    company,
    country,
    address1,
    address2,
    latitude,
    province,
    last_name,
    longitude,
    first_name,
    country_code,
    province_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_shipping_address_hashid
from {{ ref('sf_draft_orders_shipping_address_ab3') }}
-- shipping_address at sf_draft_orders/shipping_address from {{ ref('sf_draft_orders_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

