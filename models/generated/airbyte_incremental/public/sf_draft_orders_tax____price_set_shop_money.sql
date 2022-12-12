{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_tax____price_set_shop_money_ab3') }}
select
    _airbyte_price_set_hashid,
    amount,
    currency_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_shop_money_hashid
from {{ ref('sf_draft_orders_tax____price_set_shop_money_ab3') }}
-- shop_money at sf_draft_orders/tax_lines/price_set/shop_money from {{ ref('sf_draft_orders_tax_lines_price_set') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

