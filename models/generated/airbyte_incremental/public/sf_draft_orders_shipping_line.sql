{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_shipping_line_ab3') }}
select
    _airbyte_sf_draft_orders_hashid,
    price,
    title,
    custom,
    handle,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_shipping_line_hashid
from {{ ref('sf_draft_orders_shipping_line_ab3') }}
-- shipping_line at sf_draft_orders/shipping_line from {{ ref('sf_draft_orders_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

