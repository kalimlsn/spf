{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('sf_products_variants_ab1') }}
select
    _airbyte_sf_products_hashid,
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast(sku as {{ dbt_utils.type_string() }}) as sku,
    cast(grams as {{ dbt_utils.type_bigint() }}) as grams,
    cast(price as {{ dbt_utils.type_float() }}) as price,
    cast(title as {{ dbt_utils.type_string() }}) as title,
    cast(weight as {{ dbt_utils.type_float() }}) as weight,
    cast(barcode as {{ dbt_utils.type_string() }}) as barcode,
    cast(option1 as {{ dbt_utils.type_string() }}) as option1,
    cast(option2 as {{ dbt_utils.type_string() }}) as option2,
    cast(option3 as {{ dbt_utils.type_string() }}) as option3,
    {{ cast_to_boolean('taxable') }} as taxable,
    cast(image_id as {{ dbt_utils.type_bigint() }}) as image_id,
    cast({{ adapter.quote('position') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('position') }},
    cast(shop_url as {{ dbt_utils.type_string() }}) as shop_url,
    cast({{ empty_string_to_null('created_at') }} as {{ type_timestamp_with_timezone() }}) as created_at,
    cast(product_id as {{ dbt_utils.type_bigint() }}) as product_id,
    cast({{ empty_string_to_null('updated_at') }} as {{ type_timestamp_with_timezone() }}) as updated_at,
    cast(weight_unit as {{ dbt_utils.type_string() }}) as weight_unit,
    cast(compare_at_price as {{ dbt_utils.type_string() }}) as compare_at_price,
    cast(inventory_policy as {{ dbt_utils.type_string() }}) as inventory_policy,
    cast(inventory_item_id as {{ dbt_utils.type_bigint() }}) as inventory_item_id,
    {{ cast_to_boolean('requires_shipping') }} as requires_shipping,
    cast(inventory_quantity as {{ dbt_utils.type_bigint() }}) as inventory_quantity,
    presentment_prices,
    cast(fulfillment_service as {{ dbt_utils.type_string() }}) as fulfillment_service,
    cast(admin_graphql_api_id as {{ dbt_utils.type_string() }}) as admin_graphql_api_id,
    cast(inventory_management as {{ dbt_utils.type_string() }}) as inventory_management,
    cast(old_inventory_quantity as {{ dbt_utils.type_bigint() }}) as old_inventory_quantity,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_variants_ab1') }}
-- variants at sf_products/variants
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

