{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_products_scd') }}
{{ unnest_cte(ref('sf_products_scd'), 'sf_products', adapter.quote('options')) }}
select
    _airbyte_sf_products_hashid,
    {{ json_extract_scalar(unnested_column_value(adapter.quote('options')), ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar(unnested_column_value(adapter.quote('options')), ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_string_array(unnested_column_value(adapter.quote('options')), ['values'], ['values']) }} as {{ adapter.quote('values') }},
    {{ json_extract_scalar(unnested_column_value(adapter.quote('options')), ['position'], ['position']) }} as {{ adapter.quote('position') }},
    {{ json_extract_scalar(unnested_column_value(adapter.quote('options')), ['product_id'], ['product_id']) }} as product_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_scd') }} as table_alias
-- options at sf_products/options
{{ cross_join_unnest('sf_products', adapter.quote('options')) }}
where 1 = 1
and {{ adapter.quote('options') }} is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

