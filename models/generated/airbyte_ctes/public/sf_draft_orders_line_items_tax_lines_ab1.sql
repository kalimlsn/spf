{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_line_items') }}
{{ unnest_cte(ref('sf_draft_orders_line_items'), 'line_items', 'tax_lines') }}
select
    _airbyte_line_items_hashid,
    {{ json_extract_scalar(unnested_column_value('tax_lines'), ['rate'], ['rate']) }} as rate,
    {{ json_extract_scalar(unnested_column_value('tax_lines'), ['price'], ['price']) }} as price,
    {{ json_extract_scalar(unnested_column_value('tax_lines'), ['title'], ['title']) }} as title,
    {{ json_extract('', unnested_column_value('tax_lines'), ['price_set'], ['price_set']) }} as price_set,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_line_items') }} as table_alias
-- tax_lines at sf_draft_orders/line_items/tax_lines
{{ cross_join_unnest('line_items', 'tax_lines') }}
where 1 = 1
and tax_lines is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

