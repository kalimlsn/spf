{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_scd') }}
{{ unnest_cte(ref('sf_draft_orders_scd'), 'sf_draft_orders', 'note_attributes') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ json_extract_scalar(unnested_column_value('note_attributes'), ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_scalar(unnested_column_value('note_attributes'), ['value'], ['value']) }} as {{ adapter.quote('value') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_scd') }} as table_alias
-- note_attributes at sf_draft_orders/note_attributes
{{ cross_join_unnest('sf_draft_orders', 'note_attributes') }}
where 1 = 1
and note_attributes is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

