{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_products_scd') }}
{{ unnest_cte(ref('sf_products_scd'), 'sf_products', 'images') }}
select
    _airbyte_sf_products_hashid,
    {{ json_extract_scalar(unnested_column_value('images'), ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar(unnested_column_value('images'), ['alt'], ['alt']) }} as alt,
    {{ json_extract_scalar(unnested_column_value('images'), ['src'], ['src']) }} as src,
    {{ json_extract_scalar(unnested_column_value('images'), ['width'], ['width']) }} as width,
    {{ json_extract_scalar(unnested_column_value('images'), ['height'], ['height']) }} as height,
    {{ json_extract_scalar(unnested_column_value('images'), ['position'], ['position']) }} as {{ adapter.quote('position') }},
    {{ json_extract_scalar(unnested_column_value('images'), ['created_at'], ['created_at']) }} as created_at,
    {{ json_extract_scalar(unnested_column_value('images'), ['updated_at'], ['updated_at']) }} as updated_at,
    {{ json_extract_string_array(unnested_column_value('images'), ['variant_ids'], ['variant_ids']) }} as variant_ids,
    {{ json_extract_scalar(unnested_column_value('images'), ['admin_graphql_api_id'], ['admin_graphql_api_id']) }} as admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_scd') }} as table_alias
-- images at sf_products/images
{{ cross_join_unnest('sf_products', 'images') }}
where 1 = 1
and images is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

