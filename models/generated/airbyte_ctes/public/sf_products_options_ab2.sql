{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_products_options_ab1') }}
select
    _airbyte_sf_products_hashid,
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast({{ adapter.quote('name') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('name') }},
    {{ adapter.quote('values') }},
    cast({{ adapter.quote('position') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('position') }},
    cast(product_id as {{ dbt_utils.type_bigint() }}) as product_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_options_ab1') }}
-- options at sf_products/options
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

