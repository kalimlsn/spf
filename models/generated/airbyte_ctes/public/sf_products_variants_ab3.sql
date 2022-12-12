{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_products_variants_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_products_hashid',
        adapter.quote('id'),
        'sku',
        'grams',
        'price',
        'title',
        'weight',
        'barcode',
        'option1',
        'option2',
        'option3',
        boolean_to_string('taxable'),
        'image_id',
        adapter.quote('position'),
        'shop_url',
        'created_at',
        'product_id',
        'updated_at',
        'weight_unit',
        'compare_at_price',
        'inventory_policy',
        'inventory_item_id',
        boolean_to_string('requires_shipping'),
        'inventory_quantity',
        array_to_string('presentment_prices'),
        'fulfillment_service',
        'admin_graphql_api_id',
        'inventory_management',
        'old_inventory_quantity',
    ]) }} as _airbyte_variants_hashid,
    tmp.*
from {{ ref('sf_products_variants_ab2') }} tmp
-- variants at sf_products/variants
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

