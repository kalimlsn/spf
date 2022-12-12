{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_products_images_ab1') }}
select
    _airbyte_sf_products_hashid,
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast(alt as {{ dbt_utils.type_string() }}) as alt,
    cast(src as {{ dbt_utils.type_string() }}) as src,
    cast(width as {{ dbt_utils.type_bigint() }}) as width,
    cast(height as {{ dbt_utils.type_bigint() }}) as height,
    cast({{ adapter.quote('position') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('position') }},
    cast({{ empty_string_to_null('created_at') }} as {{ type_timestamp_with_timezone() }}) as created_at,
    cast({{ empty_string_to_null('updated_at') }} as {{ type_timestamp_with_timezone() }}) as updated_at,
    variant_ids,
    cast(admin_graphql_api_id as {{ dbt_utils.type_string() }}) as admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_images_ab1') }}
-- images at sf_products/images
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

