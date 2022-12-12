{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_products_variants_presentment_prices_ab1') }}
select
    _airbyte_variants_hashid,
    cast(price as {{ type_json() }}) as price,
    cast(compare_at_price as {{ dbt_utils.type_float() }}) as compare_at_price,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_variants_presentment_prices_ab1') }}
-- presentment_prices at sf_products/variants/presentment_prices
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

