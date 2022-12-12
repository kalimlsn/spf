{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_draft_orders_billing_address_ab1') }}
select
    _airbyte_sf_draft_orders_hashid,
    cast(zip as {{ dbt_utils.type_string() }}) as zip,
    cast(city as {{ dbt_utils.type_string() }}) as city,
    cast({{ adapter.quote('name') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('name') }},
    cast(phone as {{ dbt_utils.type_string() }}) as phone,
    cast(company as {{ dbt_utils.type_string() }}) as company,
    cast(country as {{ dbt_utils.type_string() }}) as country,
    cast(address1 as {{ dbt_utils.type_string() }}) as address1,
    cast(address2 as {{ dbt_utils.type_string() }}) as address2,
    cast(latitude as {{ dbt_utils.type_float() }}) as latitude,
    cast(province as {{ dbt_utils.type_string() }}) as province,
    cast(last_name as {{ dbt_utils.type_string() }}) as last_name,
    cast(longitude as {{ dbt_utils.type_float() }}) as longitude,
    cast(first_name as {{ dbt_utils.type_string() }}) as first_name,
    cast(country_code as {{ dbt_utils.type_string() }}) as country_code,
    cast(province_code as {{ dbt_utils.type_string() }}) as province_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_billing_address_ab1') }}
-- billing_address at sf_draft_orders/billing_address
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

