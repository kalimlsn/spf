{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_line_items_tax_lines_ab3') }}
select
    _airbyte_line_items_hashid,
    rate,
    price,
    title,
    price_set,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_tax_lines_hashid
from {{ ref('sf_draft_orders_line_items_tax_lines_ab3') }}
-- tax_lines at sf_draft_orders/line_items/tax_lines from {{ ref('sf_draft_orders_line_items') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

