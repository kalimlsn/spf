{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_price_rules') }}
select
    _airbyte_sf_price_rules_hashid,
    {{ json_extract_scalar('prerequisite_shipping_price_range', ['less_than_or_equal_to'], ['less_than_or_equal_to']) }} as less_than_or_equal_to,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_price_rules') }} as table_alias
-- prerequisite_shipping_price_range at sf_price_rules/prerequisite_shipping_price_range
where 1 = 1
and prerequisite_shipping_price_range is not null

