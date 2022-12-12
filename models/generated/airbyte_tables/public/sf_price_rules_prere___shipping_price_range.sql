{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_price_rules_prere___shipping_price_range_ab3') }}
select
    _airbyte_sf_price_rules_hashid,
    less_than_or_equal_to,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_prerequisit__ng_price_range_hashid
from {{ ref('sf_price_rules_prere___shipping_price_range_ab3') }}
-- prerequisite_shipping_price_range at sf_price_rules/prerequisite_shipping_price_range from {{ ref('sf_price_rules') }}
where 1 = 1

