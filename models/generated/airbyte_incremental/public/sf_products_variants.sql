{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_products_variants_ab3') }}
select
    _airbyte_sf_products_hashid,
    {{ adapter.quote('id') }},
    sku,
    grams,
    price,
    title,
    image_id,
    {{ adapter.quote('position') }},
    shop_url,
    created_at,
    product_id,
    updated_at,
    weight_unit,
    compare_at_price,
    inventory_policy,
    inventory_item_id,
    requires_shipping,
    inventory_quantity,
    presentment_prices,
    fulfillment_service,
    admin_graphql_api_id,
    inventory_management,
    old_inventory_quantity,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_variants_hashid
from {{ ref('sf_products_variants_ab3') }}
-- variants at sf_products/variants from {{ ref('sf_products_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

