{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_draft_orders_ab1') }}
select
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast({{ adapter.quote('name') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('name') }},
    cast(note as {{ dbt_utils.type_string() }}) as note,
    cast(tags as {{ dbt_utils.type_string() }}) as tags,
    cast(email as {{ dbt_utils.type_string() }}) as email,
    cast(status as {{ dbt_utils.type_string() }}) as status,
    cast(currency as {{ dbt_utils.type_string() }}) as currency,
    cast(customer as {{ type_json() }}) as customer,
    cast(order_id as {{ dbt_utils.type_bigint() }}) as order_id,
    cast(shop_url as {{ dbt_utils.type_string() }}) as shop_url,
    tax_lines,
    cast(total_tax as {{ dbt_utils.type_string() }}) as total_tax,
    cast({{ empty_string_to_null('created_at') }} as {{ type_timestamp_with_timezone() }}) as created_at,
    line_items,
    {{ cast_to_boolean('tax_exempt') }} as tax_exempt,
    cast({{ empty_string_to_null('updated_at') }} as {{ type_timestamp_with_timezone() }}) as updated_at,
    cast(invoice_url as {{ dbt_utils.type_string() }}) as invoice_url,
    cast(total_price as {{ dbt_utils.type_string() }}) as total_price,
    cast({{ empty_string_to_null('completed_at') }} as {{ type_timestamp_with_timezone() }}) as completed_at,
    cast(shipping_line as {{ type_json() }}) as shipping_line,
    cast(subtotal_price as {{ dbt_utils.type_string() }}) as subtotal_price,
    {{ cast_to_boolean('taxes_included') }} as taxes_included,
    cast(billing_address as {{ type_json() }}) as billing_address,
    cast({{ empty_string_to_null('invoice_sent_at') }} as {{ type_timestamp_with_timezone() }}) as invoice_sent_at,
    note_attributes,
    cast(applied_discount as {{ type_json() }}) as applied_discount,
    cast(shipping_address as {{ type_json() }}) as shipping_address,
    cast(admin_graphql_api_id as {{ dbt_utils.type_string() }}) as admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_ab1') }}
-- sf_draft_orders
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

