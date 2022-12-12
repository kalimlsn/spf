{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_sf_price_rules') }}
select
    {{ json_extract_scalar('_airbyte_data', ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar('_airbyte_data', ['title'], ['title']) }} as title,
    {{ json_extract_scalar('_airbyte_data', ['value'], ['value']) }} as {{ adapter.quote('value') }},
    {{ json_extract_scalar('_airbyte_data', ['ends_at'], ['ends_at']) }} as ends_at,
    {{ json_extract_scalar('_airbyte_data', ['shop_url'], ['shop_url']) }} as shop_url,
    {{ json_extract_scalar('_airbyte_data', ['starts_at'], ['starts_at']) }} as starts_at,
    {{ json_extract_scalar('_airbyte_data', ['created_at'], ['created_at']) }} as created_at,
    {{ json_extract_scalar('_airbyte_data', ['updated_at'], ['updated_at']) }} as updated_at,
    {{ json_extract_scalar('_airbyte_data', ['value_type'], ['value_type']) }} as value_type,
    {{ json_extract_scalar('_airbyte_data', ['target_type'], ['target_type']) }} as target_type,
    {{ json_extract_scalar('_airbyte_data', ['usage_limit'], ['usage_limit']) }} as usage_limit,
    {{ json_extract_scalar('_airbyte_data', ['allocation_limit'], ['allocation_limit']) }} as allocation_limit,
    {{ json_extract_scalar('_airbyte_data', ['target_selection'], ['target_selection']) }} as target_selection,
    {{ json_extract_scalar('_airbyte_data', ['allocation_method'], ['allocation_method']) }} as allocation_method,
    {{ json_extract_scalar('_airbyte_data', ['once_per_customer'], ['once_per_customer']) }} as once_per_customer,
    {{ json_extract_scalar('_airbyte_data', ['customer_selection'], ['customer_selection']) }} as customer_selection,
    {{ json_extract_string_array('_airbyte_data', ['entitled_country_ids'], ['entitled_country_ids']) }} as entitled_country_ids,
    {{ json_extract_string_array('_airbyte_data', ['entitled_product_ids'], ['entitled_product_ids']) }} as entitled_product_ids,
    {{ json_extract_string_array('_airbyte_data', ['entitled_variant_ids'], ['entitled_variant_ids']) }} as entitled_variant_ids,
    {{ json_extract_string_array('_airbyte_data', ['entitled_collection_ids'], ['entitled_collection_ids']) }} as entitled_collection_ids,
    {{ json_extract_string_array('_airbyte_data', ['prerequisite_product_ids'], ['prerequisite_product_ids']) }} as prerequisite_product_ids,
    {{ json_extract_string_array('_airbyte_data', ['prerequisite_variant_ids'], ['prerequisite_variant_ids']) }} as prerequisite_variant_ids,
    {{ json_extract_string_array('_airbyte_data', ['prerequisite_customer_ids'], ['prerequisite_customer_ids']) }} as prerequisite_customer_ids,
    {{ json_extract_string_array('_airbyte_data', ['prerequisite_collection_ids'], ['prerequisite_collection_ids']) }} as prerequisite_collection_ids,
    {{ json_extract('table_alias', '_airbyte_data', ['prerequisite_quantity_range'], ['prerequisite_quantity_range']) }} as prerequisite_quantity_range,
    {{ json_extract('table_alias', '_airbyte_data', ['prerequisite_subtotal_range'], ['prerequisite_subtotal_range']) }} as prerequisite_subtotal_range,
    {{ json_extract_string_array('_airbyte_data', ['prerequisite_saved_search_ids'], ['prerequisite_saved_search_ids']) }} as prerequisite_saved_search_ids,
    {{ json_extract('table_alias', '_airbyte_data', ['prerequisite_shipping_price_range'], ['prerequisite_shipping_price_range']) }} as prerequisite_shipping_price_range,
    {{ json_extract('table_alias', '_airbyte_data', ['prerequisite_to_entitlement_purchase'], ['prerequisite_to_entitlement_purchase']) }} as prerequisite_to_entitlement_purchase,
    {{ json_extract('table_alias', '_airbyte_data', ['prerequisite_to_entitlement_quantity_ratio'], ['prerequisite_to_entitlement_quantity_ratio']) }} as prerequisite_to_entitlement_quantity_ratio,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_sf_price_rules') }} as table_alias
-- sf_price_rules
where 1 = 1

