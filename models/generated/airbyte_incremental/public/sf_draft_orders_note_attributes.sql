{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_note_attributes_ab3') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ adapter.quote('name') }},
    {{ adapter.quote('value') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_note_attributes_hashid
from {{ ref('sf_draft_orders_note_attributes_ab3') }}
-- note_attributes at sf_draft_orders/note_attributes from {{ ref('sf_draft_orders_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

