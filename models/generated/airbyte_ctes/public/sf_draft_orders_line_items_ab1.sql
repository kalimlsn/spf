{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('sf_draft_orders_scd') }}
{{ unnest_cte(ref('sf_draft_orders_scd'), 'sf_draft_orders', 'line_items') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar(unnested_column_value('line_items'), ['sku'], ['sku']) }} as sku,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_scalar(unnested_column_value('line_items'), ['grams'], ['grams']) }} as grams,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['price'], ['price']) }} as price,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['title'], ['title']) }} as title,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['custom'], ['custom']) }} as custom,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['vendor'], ['vendor']) }} as vendor,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['taxable'], ['taxable']) }} as taxable,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['quantity'], ['quantity']) }} as quantity,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['gift_card'], ['gift_card']) }} as gift_card,
    {{ json_extract_array(unnested_column_value('line_items'), ['tax_lines'], ['tax_lines']) }} as tax_lines,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['product_id'], ['product_id']) }} as product_id,
    {{ json_extract_array(unnested_column_value('line_items'), ['properties'], ['properties']) }} as properties,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['variant_id'], ['variant_id']) }} as variant_id,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['variant_title'], ['variant_title']) }} as variant_title,
    {{ json_extract('', unnested_column_value('line_items'), ['applied_discount'], ['applied_discount']) }} as applied_discount,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['requires_shipping'], ['requires_shipping']) }} as requires_shipping,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['fulfillment_service'], ['fulfillment_service']) }} as fulfillment_service,
    {{ json_extract_scalar(unnested_column_value('line_items'), ['admin_graphql_api_id'], ['admin_graphql_api_id']) }} as admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('sf_draft_orders_scd') }} as table_alias
-- line_items at sf_draft_orders/line_items
{{ cross_join_unnest('sf_draft_orders', 'line_items') }}
where 1 = 1
and line_items is not null
{{ incremental_clause('_airbyte_emitted_at', this) }}

