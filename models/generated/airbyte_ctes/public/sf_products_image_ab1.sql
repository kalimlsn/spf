{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_products_scd') }}
select
    _airbyte_sf_products_hashid,
    {{ json_extract_scalar('image', ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar('image', ['alt'], ['alt']) }} as alt,
    {{ json_extract_scalar('image', ['src'], ['src']) }} as src,
    {{ json_extract_scalar('image', ['width'], ['width']) }} as width,
    {{ json_extract_scalar('image', ['height'], ['height']) }} as height,
    {{ json_extract_scalar('image', ['position'], ['position']) }} as {{ adapter.quote('position') }},
    {{ json_extract_scalar('image', ['created_at'], ['created_at']) }} as created_at,
    {{ json_extract_scalar('image', ['updated_at'], ['updated_at']) }} as updated_at,
    {{ json_extract_string_array('image', ['variant_ids'], ['variant_ids']) }} as variant_ids,
    {{ json_extract_scalar('image', ['admin_graphql_api_id'], ['admin_graphql_api_id']) }} as admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_scd') }} as table_alias
-- image at sf_products/image
where 1 = 1
and image is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

