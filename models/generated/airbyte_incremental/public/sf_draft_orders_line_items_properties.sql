{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_line_items_properties_ab3') }}
select
    _airbyte_line_items_hashid,
    {{ adapter.quote('name') }},
    {{ adapter.quote('value') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_properties_hashid
from {{ ref('sf_draft_orders_line_items_properties_ab3') }}
-- properties at sf_draft_orders/line_items/properties from {{ ref('sf_draft_orders_line_items') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

