{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_price_rules_prerequisite_subtotal_range_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_price_rules_hashid',
        'greater_than_or_equal_to',
    ]) }} as _airbyte_prerequisite_subtotal_range_hashid,
    tmp.*
from {{ ref('sf_price_rules_prerequisite_subtotal_range_ab2') }} tmp
-- prerequisite_subtotal_range at sf_price_rules/prerequisite_subtotal_range
where 1 = 1

