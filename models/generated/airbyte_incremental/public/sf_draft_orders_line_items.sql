{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_line_items_ab3') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ adapter.quote('id') }},
    sku,
    {{ adapter.quote('name') }},
    grams,
    price,
    title,
    custom,
    vendor,
    taxable,
    quantity,
    gift_card,
    tax_lines,
    product_id,
    properties,
    variant_id,
    variant_title,
    applied_discount,
    requires_shipping,
    fulfillment_service,
    admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_line_items_hashid
from {{ ref('sf_draft_orders_line_items_ab3') }}
-- line_items at sf_draft_orders/line_items from {{ ref('sf_draft_orders_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

