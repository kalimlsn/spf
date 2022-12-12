{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_products_variants_presentment_prices_ab3') }}
select
    _airbyte_variants_hashid,
    price,
    compare_at_price,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_presentment_prices_hashid
from {{ ref('sf_products_variants_presentment_prices_ab3') }}
-- presentment_prices at sf_products/variants/presentment_prices from {{ ref('sf_products_variants') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

