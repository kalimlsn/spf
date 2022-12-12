{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_price_rules_ab3') }}
select
    {{ adapter.quote('id') }},
    title,
    {{ adapter.quote('value') }},
    ends_at,
    shop_url,
    starts_at,
    created_at,
    updated_at,
    value_type,
    target_type,
    usage_limit,
    allocation_limit,
    target_selection,
    allocation_method,
    once_per_customer,
    customer_selection,
    entitled_country_ids,
    entitled_product_ids,
    entitled_variant_ids,
    entitled_collection_ids,
    prerequisite_product_ids,
    prerequisite_variant_ids,
    prerequisite_customer_ids,
    prerequisite_collection_ids,
    prerequisite_quantity_range,
    prerequisite_subtotal_range,
    prerequisite_saved_search_ids,
    prerequisite_shipping_price_range,
    prerequisite_to_entitlement_purchase,
    prerequisite_to_entitlement_quantity_ratio,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_sf_price_rules_hashid
from {{ ref('sf_price_rules_ab3') }}
-- sf_price_rules from {{ source('public', '_airbyte_raw_sf_price_rules') }}
where 1 = 1

