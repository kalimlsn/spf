{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_line__set_presentment_money_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_price_set_hashid',
        'amount',
        'currency_code',
    ]) }} as _airbyte_presentment_money_hashid,
    tmp.*
from {{ ref('sf_draft_orders_line__set_presentment_money_ab2') }} tmp
-- presentment_money at sf_draft_orders/line_items/tax_lines/price_set/presentment_money
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

