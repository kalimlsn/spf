{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_scd') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ json_extract_scalar('customer', ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar('customer', ['note'], ['note']) }} as note,
    {{ json_extract_scalar('customer', ['tags'], ['tags']) }} as tags,
    {{ json_extract_scalar('customer', ['email'], ['email']) }} as email,
    {{ json_extract_scalar('customer', ['phone'], ['phone']) }} as phone,
    {{ json_extract_scalar('customer', ['state'], ['state']) }} as {{ adapter.quote('state') }},
    {{ json_extract_scalar('customer', ['currency'], ['currency']) }} as currency,
    {{ json_extract_scalar('customer', ['last_name'], ['last_name']) }} as last_name,
    {{ json_extract_scalar('customer', ['created_at'], ['created_at']) }} as created_at,
    {{ json_extract_scalar('customer', ['first_name'], ['first_name']) }} as first_name,
    {{ json_extract_scalar('customer', ['tax_exempt'], ['tax_exempt']) }} as tax_exempt,
    {{ json_extract_scalar('customer', ['updated_at'], ['updated_at']) }} as updated_at,
    {{ json_extract_scalar('customer', ['total_spent'], ['total_spent']) }} as total_spent,
    {{ json_extract_scalar('customer', ['orders_count'], ['orders_count']) }} as orders_count,
    {{ json_extract_scalar('customer', ['last_order_id'], ['last_order_id']) }} as last_order_id,
    {{ json_extract_string_array('customer', ['tax_exemptions'], ['tax_exemptions']) }} as tax_exemptions,
    {{ json_extract_scalar('customer', ['verified_email'], ['verified_email']) }} as verified_email,
    {{ json_extract('table_alias', 'customer', ['default_address'], ['default_address']) }} as default_address,
    {{ json_extract_scalar('customer', ['last_order_name'], ['last_order_name']) }} as last_order_name,
    {{ json_extract_scalar('customer', ['accepts_marketing'], ['accepts_marketing']) }} as accepts_marketing,
    {{ json_extract_scalar('customer', ['admin_graphql_api_id'], ['admin_graphql_api_id']) }} as admin_graphql_api_id,
    {{ json_extract_scalar('customer', ['multipass_identifier'], ['multipass_identifier']) }} as multipass_identifier,
    {{ json_extract_scalar('customer', ['marketing_opt_in_level'], ['marketing_opt_in_level']) }} as marketing_opt_in_level,
    {{ json_extract_scalar('customer', ['accepts_marketing_updated_at'], ['accepts_marketing_updated_at']) }} as accepts_marketing_updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_scd') }} as table_alias
-- customer at sf_draft_orders/customer
where 1 = 1
and customer is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

