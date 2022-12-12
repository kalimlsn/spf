{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_draft_orders_line__s_tax_lines_price_set_ab1') }}
select
    _airbyte_tax_lines_hashid,
    cast(shop_money as {{ type_json() }}) as shop_money,
    cast(presentment_money as {{ type_json() }}) as presentment_money,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_line__s_tax_lines_price_set_ab1') }}
-- price_set at sf_draft_orders/line_items/tax_lines/price_set
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

