{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_draft_orders_line_items_ab1') }}
select
    _airbyte_sf_draft_orders_hashid,
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast(sku as {{ dbt_utils.type_string() }}) as sku,
    cast({{ adapter.quote('name') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('name') }},
    cast(grams as {{ dbt_utils.type_float() }}) as grams,
    cast(price as {{ dbt_utils.type_float() }}) as price,
    cast(title as {{ dbt_utils.type_string() }}) as title,
    {{ cast_to_boolean('custom') }} as custom,
    cast(vendor as {{ dbt_utils.type_string() }}) as vendor,
    {{ cast_to_boolean('taxable') }} as taxable,
    cast(quantity as {{ dbt_utils.type_bigint() }}) as quantity,
    {{ cast_to_boolean('gift_card') }} as gift_card,
    tax_lines,
    cast(product_id as {{ dbt_utils.type_bigint() }}) as product_id,
    properties,
    cast(variant_id as {{ dbt_utils.type_bigint() }}) as variant_id,
    cast(variant_title as {{ dbt_utils.type_string() }}) as variant_title,
    cast(applied_discount as {{ type_json() }}) as applied_discount,
    {{ cast_to_boolean('requires_shipping') }} as requires_shipping,
    cast(fulfillment_service as {{ dbt_utils.type_string() }}) as fulfillment_service,
    cast(admin_graphql_api_id as {{ dbt_utils.type_string() }}) as admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_line_items_ab1') }}
-- line_items at sf_draft_orders/line_items
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

