{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_price_rules') }}
select
    _airbyte_sf_price_rules_hashid,
    {{ json_extract_scalar('prerequisite_to_entitlement_quantity_ratio', ['entitled_quantity'], ['entitled_quantity']) }} as entitled_quantity,
    {{ json_extract_scalar('prerequisite_to_entitlement_quantity_ratio', ['prerequisite_quantity'], ['prerequisite_quantity']) }} as prerequisite_quantity,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_price_rules') }} as table_alias
-- prerequisite_to_entitlement_quantity_ratio at sf_price_rules/prerequisite_to_entitlement_quantity_ratio
where 1 = 1
and prerequisite_to_entitlement_quantity_ratio is not null

