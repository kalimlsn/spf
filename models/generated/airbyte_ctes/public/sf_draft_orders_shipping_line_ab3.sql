{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_shipping_line_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_draft_orders_hashid',
        'price',
        'title',
        boolean_to_string('custom'),
        'handle',
    ]) }} as _airbyte_shipping_line_hashid,
    tmp.*
from {{ ref('sf_draft_orders_shipping_line_ab2') }} tmp
-- shipping_line at sf_draft_orders/shipping_line
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

