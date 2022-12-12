{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_tax____price_set_shop_money_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_price_set_hashid',
        'amount',
        'currency_code',
    ]) }} as _airbyte_shop_money_hashid,
    tmp.*
from {{ ref('sf_draft_orders_tax____price_set_shop_money_ab2') }} tmp
-- shop_money at sf_draft_orders/tax_lines/price_set/shop_money
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

