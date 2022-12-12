{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_line_items_tax_lines_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_line_items_hashid',
        'rate',
        'price',
        'title',
        object_to_string('price_set'),
    ]) }} as _airbyte_tax_lines_hashid,
    tmp.*
from {{ ref('sf_draft_orders_line_items_tax_lines_ab2') }} tmp
-- tax_lines at sf_draft_orders/line_items/tax_lines
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

