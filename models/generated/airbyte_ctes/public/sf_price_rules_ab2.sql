{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_price_rules_ab1') }}
select
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast(title as {{ dbt_utils.type_string() }}) as title,
    cast({{ adapter.quote('value') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('value') }},
    cast({{ empty_string_to_null('ends_at') }} as {{ type_timestamp_with_timezone() }}) as ends_at,
    cast(shop_url as {{ dbt_utils.type_string() }}) as shop_url,
    cast({{ empty_string_to_null('starts_at') }} as {{ type_timestamp_with_timezone() }}) as starts_at,
    cast({{ empty_string_to_null('created_at') }} as {{ type_timestamp_with_timezone() }}) as created_at,
    cast({{ empty_string_to_null('updated_at') }} as {{ type_timestamp_with_timezone() }}) as updated_at,
    cast(value_type as {{ dbt_utils.type_string() }}) as value_type,
    cast(target_type as {{ dbt_utils.type_string() }}) as target_type,
    cast(usage_limit as {{ dbt_utils.type_bigint() }}) as usage_limit,
    cast(allocation_limit as {{ dbt_utils.type_bigint() }}) as allocation_limit,
    cast(target_selection as {{ dbt_utils.type_string() }}) as target_selection,
    cast(allocation_method as {{ dbt_utils.type_string() }}) as allocation_method,
    {{ cast_to_boolean('once_per_customer') }} as once_per_customer,
    cast(customer_selection as {{ dbt_utils.type_string() }}) as customer_selection,
    entitled_country_ids,
    entitled_product_ids,
    entitled_variant_ids,
    entitled_collection_ids,
    prerequisite_product_ids,
    prerequisite_variant_ids,
    prerequisite_customer_ids,
    prerequisite_collection_ids,
    cast(prerequisite_quantity_range as {{ type_json() }}) as prerequisite_quantity_range,
    cast(prerequisite_subtotal_range as {{ type_json() }}) as prerequisite_subtotal_range,
    prerequisite_saved_search_ids,
    cast(prerequisite_shipping_price_range as {{ type_json() }}) as prerequisite_shipping_price_range,
    cast(prerequisite_to_entitlement_purchase as {{ type_json() }}) as prerequisite_to_entitlement_purchase,
    cast(prerequisite_to_entitlement_quantity_ratio as {{ type_json() }}) as prerequisite_to_entitlement_quantity_ratio,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_price_rules_ab1') }}
-- sf_price_rules
where 1 = 1

