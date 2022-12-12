{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_price_rules_prere___entitlement_purchase_ab1') }}
select
    _airbyte_sf_price_rules_hashid,
    cast(prerequisite_amount as {{ dbt_utils.type_float() }}) as prerequisite_amount,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_price_rules_prere___entitlement_purchase_ab1') }}
-- prerequisite_to_entitlement_purchase at sf_price_rules/prerequisite_to_entitlement_purchase
where 1 = 1

