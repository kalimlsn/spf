{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_price_rules_prere__lement_quantity_ratio_ab1') }}
select
    _airbyte_sf_price_rules_hashid,
    cast(entitled_quantity as {{ dbt_utils.type_bigint() }}) as entitled_quantity,
    cast(prerequisite_quantity as {{ dbt_utils.type_bigint() }}) as prerequisite_quantity,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_price_rules_prere__lement_quantity_ratio_ab1') }}
-- prerequisite_to_entitlement_quantity_ratio at sf_price_rules/prerequisite_to_entitlement_quantity_ratio
where 1 = 1

