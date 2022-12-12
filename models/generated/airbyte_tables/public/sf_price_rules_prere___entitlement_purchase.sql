{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_price_rules_prere___entitlement_purchase_ab3') }}
select
    _airbyte_sf_price_rules_hashid,
    prerequisite_amount,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_prerequisit__ement_purchase_hashid
from {{ ref('sf_price_rules_prere___entitlement_purchase_ab3') }}
-- prerequisite_to_entitlement_purchase at sf_price_rules/prerequisite_to_entitlement_purchase from {{ ref('sf_price_rules') }}
where 1 = 1

