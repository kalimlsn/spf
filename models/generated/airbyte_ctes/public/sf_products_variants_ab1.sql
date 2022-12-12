{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_products_scd') }}
{{ unnest_cte(ref('sf_products_scd'), 'sf_products', 'variants') }}
select
    _airbyte_sf_products_hashid,
    {{ json_extract_scalar(unnested_column_value('variants'), ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar(unnested_column_value('variants'), ['sku'], ['sku']) }} as sku,
    {{ json_extract_scalar(unnested_column_value('variants'), ['grams'], ['grams']) }} as grams,
    {{ json_extract_scalar(unnested_column_value('variants'), ['price'], ['price']) }} as price,
    {{ json_extract_scalar(unnested_column_value('variants'), ['title'], ['title']) }} as title,
    {{ json_extract_scalar(unnested_column_value('variants'), ['weight'], ['weight']) }} as weight,
    {{ json_extract_scalar(unnested_column_value('variants'), ['barcode'], ['barcode']) }} as barcode,
    {{ json_extract_scalar(unnested_column_value('variants'), ['option1'], ['option1']) }} as option1,
    {{ json_extract_scalar(unnested_column_value('variants'), ['option2'], ['option2']) }} as option2,
    {{ json_extract_scalar(unnested_column_value('variants'), ['option3'], ['option3']) }} as option3,
    {{ json_extract_scalar(unnested_column_value('variants'), ['taxable'], ['taxable']) }} as taxable,
    {{ json_extract_scalar(unnested_column_value('variants'), ['image_id'], ['image_id']) }} as image_id,
    {{ json_extract_scalar(unnested_column_value('variants'), ['position'], ['position']) }} as {{ adapter.quote('position') }},
    {{ json_extract_scalar(unnested_column_value('variants'), ['tax_code'], ['tax_code']) }} as tax_code,
    {{ json_extract_scalar(unnested_column_value('variants'), ['created_at'], ['created_at']) }} as created_at,
    {{ json_extract_scalar(unnested_column_value('variants'), ['updated_at'], ['updated_at']) }} as updated_at,
    {{ json_extract_scalar(unnested_column_value('variants'), ['weight_unit'], ['weight_unit']) }} as weight_unit,
    {{ json_extract_scalar(unnested_column_value('variants'), ['compare_at_price'], ['compare_at_price']) }} as compare_at_price,
    {{ json_extract_scalar(unnested_column_value('variants'), ['inventory_policy'], ['inventory_policy']) }} as inventory_policy,
    {{ json_extract_scalar(unnested_column_value('variants'), ['inventory_item_id'], ['inventory_item_id']) }} as inventory_item_id,
    {{ json_extract_scalar(unnested_column_value('variants'), ['requires_shipping'], ['requires_shipping']) }} as requires_shipping,
    {{ json_extract_scalar(unnested_column_value('variants'), ['inventory_quantity'], ['inventory_quantity']) }} as inventory_quantity,
    {{ json_extract_array(unnested_column_value('variants'), ['presentment_prices'], ['presentment_prices']) }} as presentment_prices,
    {{ json_extract_scalar(unnested_column_value('variants'), ['fulfillment_service'], ['fulfillment_service']) }} as fulfillment_service,
    {{ json_extract_scalar(unnested_column_value('variants'), ['admin_graphql_api_id'], ['admin_graphql_api_id']) }} as admin_graphql_api_id,
    {{ json_extract_scalar(unnested_column_value('variants'), ['inventory_management'], ['inventory_management']) }} as inventory_management,
    {{ json_extract_scalar(unnested_column_value('variants'), ['old_inventory_quantity'], ['old_inventory_quantity']) }} as old_inventory_quantity,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_products_scd') }} as table_alias
-- variants at sf_products/variants
{{ cross_join_unnest('sf_products', 'variants') }}
where 1 = 1
and variants is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

