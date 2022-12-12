{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_line__s_tax_lines_price_set_ab3') }}
select
    _airbyte_tax_lines_hashid,
    shop_money,
    presentment_money,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_price_set_hashid
from {{ ref('sf_draft_orders_line__s_tax_lines_price_set_ab3') }}
-- price_set at sf_draft_orders/line_items/tax_lines/price_set from {{ ref('sf_draft_orders_line_items_tax_lines') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

