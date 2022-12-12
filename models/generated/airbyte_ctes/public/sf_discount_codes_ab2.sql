{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_discount_codes_ab1') }}
select
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast(code as {{ dbt_utils.type_string() }}) as code,
    cast(shop_url as {{ dbt_utils.type_string() }}) as shop_url,
    cast({{ empty_string_to_null('created_at') }} as {{ type_timestamp_with_timezone() }}) as created_at,
    cast({{ empty_string_to_null('updated_at') }} as {{ type_timestamp_with_timezone() }}) as updated_at,
    cast(usage_count as {{ dbt_utils.type_bigint() }}) as usage_count,
    cast(price_rule_id as {{ dbt_utils.type_bigint() }}) as price_rule_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_discount_codes_ab1') }}
-- sf_discount_codes
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

