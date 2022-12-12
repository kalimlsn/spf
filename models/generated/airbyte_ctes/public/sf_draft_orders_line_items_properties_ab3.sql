{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_line_items_properties_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_line_items_hashid',
        adapter.quote('name'),
        adapter.quote('value'),
    ]) }} as _airbyte_properties_hashid,
    tmp.*
from {{ ref('sf_draft_orders_line_items_properties_ab2') }} tmp
-- properties at sf_draft_orders/line_items/properties
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

