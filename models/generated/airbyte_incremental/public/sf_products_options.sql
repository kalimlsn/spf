{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_products_options_ab3') }}
select
    _airbyte_sf_products_hashid,
    {{ adapter.quote('id') }},
    {{ adapter.quote('name') }},
    {{ adapter.quote('values') }},
    {{ adapter.quote('position') }},
    product_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_options_hashid
from {{ ref('sf_products_options_ab3') }}
-- options at sf_products/options from {{ ref('sf_products_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

