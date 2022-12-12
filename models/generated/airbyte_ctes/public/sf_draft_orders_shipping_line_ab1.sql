{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_scd') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ json_extract_scalar('shipping_line', ['price'], ['price']) }} as price,
    {{ json_extract_scalar('shipping_line', ['title'], ['title']) }} as title,
    {{ json_extract_scalar('shipping_line', ['custom'], ['custom']) }} as custom,
    {{ json_extract_scalar('shipping_line', ['handle'], ['handle']) }} as handle,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_scd') }} as table_alias
-- shipping_line at sf_draft_orders/shipping_line
where 1 = 1
and shipping_line is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

