{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_discount_codes_scd') }}
select
    _airbyte_unique_key,
    {{ adapter.quote('id') }},
    code,
    shop_url,
    created_at,
    updated_at,
    usage_count,
    price_rule_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_sf_discount_codes_hashid
from {{ ref('sf_discount_codes_scd') }}
-- sf_discount_codes from {{ source('public', '_airbyte_raw_sf_discount_codes') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

