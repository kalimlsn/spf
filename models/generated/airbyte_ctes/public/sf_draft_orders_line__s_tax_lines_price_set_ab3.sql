{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_line__s_tax_lines_price_set_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_tax_lines_hashid',
        object_to_string('shop_money'),
        object_to_string('presentment_money'),
    ]) }} as _airbyte_price_set_hashid,
    tmp.*
from {{ ref('sf_draft_orders_line__s_tax_lines_price_set_ab2') }} tmp
-- price_set at sf_draft_orders/line_items/tax_lines/price_set
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

