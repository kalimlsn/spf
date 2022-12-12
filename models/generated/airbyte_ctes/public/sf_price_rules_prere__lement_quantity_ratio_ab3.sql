{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_price_rules_prere__lement_quantity_ratio_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_price_rules_hashid',
        'entitled_quantity',
        'prerequisite_quantity',
    ]) }} as _airbyte_prerequisit__quantity_ratio_hashid,
    tmp.*
from {{ ref('sf_price_rules_prere__lement_quantity_ratio_ab2') }} tmp
-- prerequisite_to_entitlement_quantity_ratio at sf_price_rules/prerequisite_to_entitlement_quantity_ratio
where 1 = 1

