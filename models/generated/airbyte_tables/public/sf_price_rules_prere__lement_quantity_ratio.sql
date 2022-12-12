{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_price_rules_prere__lement_quantity_ratio_ab3') }}
select
    _airbyte_sf_price_rules_hashid,
    entitled_quantity,
    prerequisite_quantity,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_prerequisit__quantity_ratio_hashid
from {{ ref('sf_price_rules_prere__lement_quantity_ratio_ab3') }}
-- prerequisite_to_entitlement_quantity_ratio at sf_price_rules/prerequisite_to_entitlement_quantity_ratio from {{ ref('sf_price_rules') }}
where 1 = 1

