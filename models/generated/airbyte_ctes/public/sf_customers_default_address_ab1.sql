{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_customers_scd') }}
select
    _airbyte_sf_customers_hashid,
    {{ json_extract_scalar('default_address', ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar('default_address', ['zip'], ['zip']) }} as zip,
    {{ json_extract_scalar('default_address', ['city'], ['city']) }} as city,
    {{ json_extract_scalar('default_address', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_scalar('default_address', ['phone'], ['phone']) }} as phone,
    {{ json_extract_scalar('default_address', ['company'], ['company']) }} as company,
    {{ json_extract_scalar('default_address', ['country'], ['country']) }} as country,
    {{ json_extract_scalar('default_address', ['default'], ['default']) }} as {{ adapter.quote('default') }},
    {{ json_extract_scalar('default_address', ['address1'], ['address1']) }} as address1,
    {{ json_extract_scalar('default_address', ['address2'], ['address2']) }} as address2,
    {{ json_extract_scalar('default_address', ['province'], ['province']) }} as province,
    {{ json_extract_scalar('default_address', ['last_name'], ['last_name']) }} as last_name,
    {{ json_extract_scalar('default_address', ['first_name'], ['first_name']) }} as first_name,
    {{ json_extract_scalar('default_address', ['customer_id'], ['customer_id']) }} as customer_id,
    {{ json_extract_scalar('default_address', ['country_code'], ['country_code']) }} as country_code,
    {{ json_extract_scalar('default_address', ['country_name'], ['country_name']) }} as country_name,
    {{ json_extract_scalar('default_address', ['province_code'], ['province_code']) }} as province_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_customers_scd') }} as table_alias
-- default_address at sf_customers/default_address
where 1 = 1
and default_address is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

