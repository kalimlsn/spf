{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_products_variants__sentment_prices_price_ab1') }}
select
    _airbyte_presentment_prices_hashid,
    cast(amount as {{ dbt_utils.type_float() }}) as amount,
    cast(currency_code as {{ dbt_utils.type_string() }}) as currency_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_variants__sentment_prices_price_ab1') }}
-- price at sf_products/variants/presentment_prices/price
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

