{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_tax_lines_ab3') }}
select
    _airbyte_sf_draft_orders_hashid,
    rate,
    price,
    title,
    price_set,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_tax_lines_hashid
from {{ ref('sf_draft_orders_tax_lines_ab3') }}
-- tax_lines at sf_draft_orders/tax_lines from {{ ref('sf_draft_orders_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

