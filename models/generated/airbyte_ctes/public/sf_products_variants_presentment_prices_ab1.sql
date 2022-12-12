{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_products_variants') }}
{{ unnest_cte(ref('sf_products_variants'), 'variants', 'presentment_prices') }}
select
    _airbyte_variants_hashid,
    {{ json_extract('', unnested_column_value('presentment_prices'), ['price'], ['price']) }} as price,
    {{ json_extract_scalar(unnested_column_value('presentment_prices'), ['compare_at_price'], ['compare_at_price']) }} as compare_at_price,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_variants') }} as table_alias
-- presentment_prices at sf_products/variants/presentment_prices
{{ cross_join_unnest('variants', 'presentment_prices') }}
where 1 = 1
and presentment_prices is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

