{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_scd') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ json_extract_scalar('billing_address', ['zip'], ['zip']) }} as zip,
    {{ json_extract_scalar('billing_address', ['city'], ['city']) }} as city,
    {{ json_extract_scalar('billing_address', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_scalar('billing_address', ['phone'], ['phone']) }} as phone,
    {{ json_extract_scalar('billing_address', ['company'], ['company']) }} as company,
    {{ json_extract_scalar('billing_address', ['country'], ['country']) }} as country,
    {{ json_extract_scalar('billing_address', ['address1'], ['address1']) }} as address1,
    {{ json_extract_scalar('billing_address', ['address2'], ['address2']) }} as address2,
    {{ json_extract_scalar('billing_address', ['latitude'], ['latitude']) }} as latitude,
    {{ json_extract_scalar('billing_address', ['province'], ['province']) }} as province,
    {{ json_extract_scalar('billing_address', ['last_name'], ['last_name']) }} as last_name,
    {{ json_extract_scalar('billing_address', ['longitude'], ['longitude']) }} as longitude,
    {{ json_extract_scalar('billing_address', ['first_name'], ['first_name']) }} as first_name,
    {{ json_extract_scalar('billing_address', ['country_code'], ['country_code']) }} as country_code,
    {{ json_extract_scalar('billing_address', ['province_code'], ['province_code']) }} as province_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_scd') }} as table_alias
-- billing_address at sf_draft_orders/billing_address
where 1 = 1
and billing_address is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

