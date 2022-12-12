{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_tax_lines_price_set') }}
select
    _airbyte_price_set_hashid,
    {{ json_extract_scalar('presentment_money', ['amount'], ['amount']) }} as amount,
    {{ json_extract_scalar('presentment_money', ['currency_code'], ['currency_code']) }} as currency_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_tax_lines_price_set') }} as table_alias
-- presentment_money at sf_draft_orders/tax_lines/price_set/presentment_money
where 1 = 1
and presentment_money is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

