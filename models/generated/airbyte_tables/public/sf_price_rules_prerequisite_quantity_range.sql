{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_price_rules_prerequisite_quantity_range_ab3') }}
select
    _airbyte_sf_price_rules_hashid,
    greater_than_or_equal_to,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_prerequisite_quantity_range_hashid
from {{ ref('sf_price_rules_prerequisite_quantity_range_ab3') }}
-- prerequisite_quantity_range at sf_price_rules/prerequisite_quantity_range from {{ ref('sf_price_rules') }}
where 1 = 1

