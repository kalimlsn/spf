{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_draft_orders_line_items_properties_ab1') }}
select
    _airbyte_line_items_hashid,
    cast({{ adapter.quote('name') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('name') }},
    cast({{ adapter.quote('value') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('value') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_line_items_properties_ab1') }}
-- properties at sf_draft_orders/line_items/properties
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

