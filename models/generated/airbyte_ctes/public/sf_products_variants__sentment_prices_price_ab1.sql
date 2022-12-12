{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_products_variants_presentment_prices') }}
select
    _airbyte_presentment_prices_hashid,
    {{ json_extract_scalar('price', ['amount'], ['amount']) }} as amount,
    {{ json_extract_scalar('price', ['currency_code'], ['currency_code']) }} as currency_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_variants_presentment_prices') }} as table_alias
-- price at sf_products/variants/presentment_prices/price
where 1 = 1
and price is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

