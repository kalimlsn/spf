{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_sf_draft_orders') }}
select
    {{ json_extract_scalar('_airbyte_data', ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar('_airbyte_data', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_scalar('_airbyte_data', ['note'], ['note']) }} as note,
    {{ json_extract_scalar('_airbyte_data', ['tags'], ['tags']) }} as tags,
    {{ json_extract_scalar('_airbyte_data', ['email'], ['email']) }} as email,
    {{ json_extract_scalar('_airbyte_data', ['status'], ['status']) }} as status,
    {{ json_extract_scalar('_airbyte_data', ['currency'], ['currency']) }} as currency,
    {{ json_extract('table_alias', '_airbyte_data', ['customer'], ['customer']) }} as customer,
    {{ json_extract_scalar('_airbyte_data', ['order_id'], ['order_id']) }} as order_id,
    {{ json_extract_scalar('_airbyte_data', ['shop_url'], ['shop_url']) }} as shop_url,
    {{ json_extract_array('_airbyte_data', ['tax_lines'], ['tax_lines']) }} as tax_lines,
    {{ json_extract_scalar('_airbyte_data', ['total_tax'], ['total_tax']) }} as total_tax,
    {{ json_extract_scalar('_airbyte_data', ['created_at'], ['created_at']) }} as created_at,
    {{ json_extract_array('_airbyte_data', ['line_items'], ['line_items']) }} as line_items,
    {{ json_extract_scalar('_airbyte_data', ['tax_exempt'], ['tax_exempt']) }} as tax_exempt,
    {{ json_extract_scalar('_airbyte_data', ['updated_at'], ['updated_at']) }} as updated_at,
    {{ json_extract_scalar('_airbyte_data', ['invoice_url'], ['invoice_url']) }} as invoice_url,
    {{ json_extract_scalar('_airbyte_data', ['total_price'], ['total_price']) }} as total_price,
    {{ json_extract_scalar('_airbyte_data', ['completed_at'], ['completed_at']) }} as completed_at,
    {{ json_extract('table_alias', '_airbyte_data', ['shipping_line'], ['shipping_line']) }} as shipping_line,
    {{ json_extract_scalar('_airbyte_data', ['subtotal_price'], ['subtotal_price']) }} as subtotal_price,
    {{ json_extract_scalar('_airbyte_data', ['taxes_included'], ['taxes_included']) }} as taxes_included,
    {{ json_extract('table_alias', '_airbyte_data', ['billing_address'], ['billing_address']) }} as billing_address,
    {{ json_extract_scalar('_airbyte_data', ['invoice_sent_at'], ['invoice_sent_at']) }} as invoice_sent_at,
    {{ json_extract_array('_airbyte_data', ['note_attributes'], ['note_attributes']) }} as note_attributes,
    {{ json_extract('table_alias', '_airbyte_data', ['applied_discount'], ['applied_discount']) }} as applied_discount,
    {{ json_extract('table_alias', '_airbyte_data', ['shipping_address'], ['shipping_address']) }} as shipping_address,
    {{ json_extract_scalar('_airbyte_data', ['admin_graphql_api_id'], ['admin_graphql_api_id']) }} as admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_sf_draft_orders') }} as table_alias
-- sf_draft_orders
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

