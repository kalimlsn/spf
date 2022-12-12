{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_customers_scd') }}
{{ unnest_cte(ref('sf_customers_scd'), 'sf_customers', 'addresses') }}
select
    _airbyte_sf_customers_hashid,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar(unnested_column_value('addresses'), ['zip'], ['zip']) }} as zip,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['city'], ['city']) }} as city,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_scalar(unnested_column_value('addresses'), ['phone'], ['phone']) }} as phone,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['company'], ['company']) }} as company,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['country'], ['country']) }} as country,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['default'], ['default']) }} as {{ adapter.quote('default') }},
    {{ json_extract_scalar(unnested_column_value('addresses'), ['address1'], ['address1']) }} as address1,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['address2'], ['address2']) }} as address2,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['province'], ['province']) }} as province,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['last_name'], ['last_name']) }} as last_name,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['first_name'], ['first_name']) }} as first_name,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['customer_id'], ['customer_id']) }} as customer_id,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['country_code'], ['country_code']) }} as country_code,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['country_name'], ['country_name']) }} as country_name,
    {{ json_extract_scalar(unnested_column_value('addresses'), ['province_code'], ['province_code']) }} as province_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_customers_scd') }} as table_alias
-- addresses at sf_customers/addresses
{{ cross_join_unnest('sf_customers', 'addresses') }}
where 1 = 1
and addresses is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

