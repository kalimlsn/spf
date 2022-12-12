{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_line_items_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_draft_orders_hashid',
        adapter.quote('id'),
        'sku',
        adapter.quote('name'),
        'grams',
        'price',
        'title',
        boolean_to_string('custom'),
        'vendor',
        boolean_to_string('taxable'),
        'quantity',
        boolean_to_string('gift_card'),
        array_to_string('tax_lines'),
        'product_id',
        array_to_string('properties'),
        'variant_id',
        'variant_title',
        object_to_string('applied_discount'),
        boolean_to_string('requires_shipping'),
        'fulfillment_service',
        'admin_graphql_api_id',
    ]) }} as _airbyte_line_items_hashid,
    tmp.*
from {{ ref('sf_draft_orders_line_items_ab2') }} tmp
-- line_items at sf_draft_orders/line_items
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

