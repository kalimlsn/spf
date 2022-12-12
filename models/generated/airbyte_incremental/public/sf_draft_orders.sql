{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_scd') }}
select
    _airbyte_unique_key,
    {{ adapter.quote('id') }},
    {{ adapter.quote('name') }},
    note,
    tags,
    email,
    status,
    currency,
    customer,
    order_id,
    shop_url,
    tax_lines,
    total_tax,
    created_at,
    line_items,
    tax_exempt,
    updated_at,
    invoice_url,
    total_price,
    completed_at,
    shipping_line,
    subtotal_price,
    taxes_included,
    billing_address,
    invoice_sent_at,
    note_attributes,
    applied_discount,
    shipping_address,
    admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_sf_draft_orders_hashid
from {{ ref('sf_draft_orders_scd') }}
-- sf_draft_orders from {{ source('public', '_airbyte_raw_sf_draft_orders') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

