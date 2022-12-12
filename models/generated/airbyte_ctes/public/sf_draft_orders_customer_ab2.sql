{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_draft_orders_customer_ab1') }}
select
    _airbyte_sf_draft_orders_hashid,
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast(note as {{ dbt_utils.type_string() }}) as note,
    cast(tags as {{ dbt_utils.type_string() }}) as tags,
    cast(email as {{ dbt_utils.type_string() }}) as email,
    cast(phone as {{ dbt_utils.type_string() }}) as phone,
    cast({{ adapter.quote('state') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('state') }},
    cast(currency as {{ dbt_utils.type_string() }}) as currency,
    cast(last_name as {{ dbt_utils.type_string() }}) as last_name,
    cast({{ empty_string_to_null('created_at') }} as {{ type_timestamp_with_timezone() }}) as created_at,
    cast(first_name as {{ dbt_utils.type_string() }}) as first_name,
    {{ cast_to_boolean('tax_exempt') }} as tax_exempt,
    cast({{ empty_string_to_null('updated_at') }} as {{ type_timestamp_with_timezone() }}) as updated_at,
    cast(total_spent as {{ dbt_utils.type_float() }}) as total_spent,
    cast(orders_count as {{ dbt_utils.type_bigint() }}) as orders_count,
    cast(last_order_id as {{ dbt_utils.type_bigint() }}) as last_order_id,
    tax_exemptions,
    {{ cast_to_boolean('verified_email') }} as verified_email,
    cast(default_address as {{ type_json() }}) as default_address,
    cast(last_order_name as {{ dbt_utils.type_string() }}) as last_order_name,
    {{ cast_to_boolean('accepts_marketing') }} as accepts_marketing,
    cast(admin_graphql_api_id as {{ dbt_utils.type_string() }}) as admin_graphql_api_id,
    cast(multipass_identifier as {{ dbt_utils.type_string() }}) as multipass_identifier,
    cast(marketing_opt_in_level as {{ dbt_utils.type_string() }}) as marketing_opt_in_level,
    cast(accepts_marketing_updated_at as {{ dbt_utils.type_string() }}) as accepts_marketing_updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_customer_ab1') }}
-- customer at sf_draft_orders/customer
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

