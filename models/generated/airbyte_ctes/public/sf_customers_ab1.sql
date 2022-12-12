{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_sf_customers') }}
select
    {{ json_extract_scalar('_airbyte_data', ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar('_airbyte_data', ['note'], ['note']) }} as note,
    {{ json_extract_scalar('_airbyte_data', ['tags'], ['tags']) }} as tags,
    {{ json_extract_scalar('_airbyte_data', ['email'], ['email']) }} as email,
    {{ json_extract_scalar('_airbyte_data', ['phone'], ['phone']) }} as phone,
    {{ json_extract_scalar('_airbyte_data', ['state'], ['state']) }} as {{ adapter.quote('state') }},
    {{ json_extract_scalar('_airbyte_data', ['currency'], ['currency']) }} as currency,
    {{ json_extract_scalar('_airbyte_data', ['shop_url'], ['shop_url']) }} as shop_url,
    {{ json_extract_array('_airbyte_data', ['addresses'], ['addresses']) }} as addresses,
    {{ json_extract_scalar('_airbyte_data', ['last_name'], ['last_name']) }} as last_name,
    {{ json_extract_scalar('_airbyte_data', ['created_at'], ['created_at']) }} as created_at,
    {{ json_extract_scalar('_airbyte_data', ['first_name'], ['first_name']) }} as first_name,
    {{ json_extract_scalar('_airbyte_data', ['tax_exempt'], ['tax_exempt']) }} as tax_exempt,
    {{ json_extract_scalar('_airbyte_data', ['updated_at'], ['updated_at']) }} as updated_at,
    {{ json_extract_scalar('_airbyte_data', ['total_spent'], ['total_spent']) }} as total_spent,
    {{ json_extract_scalar('_airbyte_data', ['orders_count'], ['orders_count']) }} as orders_count,
    {{ json_extract_scalar('_airbyte_data', ['last_order_id'], ['last_order_id']) }} as last_order_id,
    {{ json_extract_scalar('_airbyte_data', ['verified_email'], ['verified_email']) }} as verified_email,
    {{ json_extract('table_alias', '_airbyte_data', ['default_address'], ['default_address']) }} as default_address,
    {{ json_extract_scalar('_airbyte_data', ['last_order_name'], ['last_order_name']) }} as last_order_name,
    {{ json_extract_scalar('_airbyte_data', ['accepts_marketing'], ['accepts_marketing']) }} as accepts_marketing,
    {{ json_extract_scalar('_airbyte_data', ['admin_graphql_api_id'], ['admin_graphql_api_id']) }} as admin_graphql_api_id,
    {{ json_extract_scalar('_airbyte_data', ['multipass_identifier'], ['multipass_identifier']) }} as multipass_identifier,
    {{ json_extract('table_alias', '_airbyte_data', ['accepts_marketing_updated_at']) }} as accepts_marketing_updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_sf_customers') }} as table_alias
-- sf_customers
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

