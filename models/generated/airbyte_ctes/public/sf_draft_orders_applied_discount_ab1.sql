{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_scd') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ json_extract_scalar('applied_discount', ['title'], ['title']) }} as title,
    {{ json_extract_scalar('applied_discount', ['value'], ['value']) }} as {{ adapter.quote('value') }},
    {{ json_extract_scalar('applied_discount', ['amount'], ['amount']) }} as amount,
    {{ json_extract_scalar('applied_discount', ['value_type'], ['value_type']) }} as value_type,
    {{ json_extract_scalar('applied_discount', ['description'], ['description']) }} as description,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_scd') }} as table_alias
-- applied_discount at sf_draft_orders/applied_discount
where 1 = 1
and applied_discount is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

