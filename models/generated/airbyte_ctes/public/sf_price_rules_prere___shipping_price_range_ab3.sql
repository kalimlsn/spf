{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_price_rules_prere___shipping_price_range_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_price_rules_hashid',
        'less_than_or_equal_to',
    ]) }} as _airbyte_prerequisit__ng_price_range_hashid,
    tmp.*
from {{ ref('sf_price_rules_prere___shipping_price_range_ab2') }} tmp
-- prerequisite_shipping_price_range at sf_price_rules/prerequisite_shipping_price_range
where 1 = 1

