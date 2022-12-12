{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_price_rules_prere___entitlement_purchase_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_price_rules_hashid',
        'prerequisite_amount',
    ]) }} as _airbyte_prerequisit__ement_purchase_hashid,
    tmp.*
from {{ ref('sf_price_rules_prere___entitlement_purchase_ab2') }} tmp
-- prerequisite_to_entitlement_purchase at sf_price_rules/prerequisite_to_entitlement_purchase
where 1 = 1

