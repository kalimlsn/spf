{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_draft_orders_shipping_line_ab1') }}
select
    _airbyte_sf_draft_orders_hashid,
    cast(price as {{ dbt_utils.type_float() }}) as price,
    cast(title as {{ dbt_utils.type_string() }}) as title,
    {{ cast_to_boolean('custom') }} as custom,
    cast(handle as {{ dbt_utils.type_string() }}) as handle,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_shipping_line_ab1') }}
-- shipping_line at sf_draft_orders/shipping_line
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

