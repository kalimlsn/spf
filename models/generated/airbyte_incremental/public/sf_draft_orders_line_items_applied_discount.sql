{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_line_items_applied_discount_ab3') }}
select
    _airbyte_line_items_hashid,
    title,
    {{ adapter.quote('value') }},
    amount,
    value_type,
    description,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_applied_discount_hashid
from {{ ref('sf_draft_orders_line_items_applied_discount_ab3') }}
-- applied_discount at sf_draft_orders/line_items/applied_discount from {{ ref('sf_draft_orders_line_items') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

