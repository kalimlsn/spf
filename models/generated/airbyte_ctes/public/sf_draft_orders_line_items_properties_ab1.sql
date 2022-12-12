{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_line_items') }}
{{ unnest_cte(ref('sf_draft_orders_line_items'), 'line_items', 'properties') }}
select
    _airbyte_line_items_hashid,
    {{ json_extract_scalar(unnested_column_value('properties'), ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_scalar(unnested_column_value('properties'), ['value'], ['value']) }} as {{ adapter.quote('value') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_line_items') }} as table_alias
-- properties at sf_draft_orders/line_items/properties
{{ cross_join_unnest('line_items', 'properties') }}
where 1 = 1
and properties is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

