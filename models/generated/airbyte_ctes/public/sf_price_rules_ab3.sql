{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_price_rules_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('id'),
        'title',
        adapter.quote('value'),
        'ends_at',
        'shop_url',
        'starts_at',
        'created_at',
        'updated_at',
        'value_type',
        'target_type',
        'usage_limit',
        'allocation_limit',
        'target_selection',
        'allocation_method',
        boolean_to_string('once_per_customer'),
        'customer_selection',
        array_to_string('entitled_country_ids'),
        array_to_string('entitled_product_ids'),
        array_to_string('entitled_variant_ids'),
        array_to_string('entitled_collection_ids'),
        array_to_string('prerequisite_product_ids'),
        array_to_string('prerequisite_variant_ids'),
        array_to_string('prerequisite_customer_ids'),
        array_to_string('prerequisite_collection_ids'),
        object_to_string('prerequisite_quantity_range'),
        object_to_string('prerequisite_subtotal_range'),
        array_to_string('prerequisite_saved_search_ids'),
        object_to_string('prerequisite_shipping_price_range'),
        object_to_string('prerequisite_to_entitlement_purchase'),
        object_to_string('prerequisite_to_entitlement_quantity_ratio'),
    ]) }} as _airbyte_sf_price_rules_hashid,
    tmp.*
from {{ ref('sf_price_rules_ab2') }} tmp
-- sf_price_rules
where 1 = 1

