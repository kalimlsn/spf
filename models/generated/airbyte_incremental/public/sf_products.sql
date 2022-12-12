{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_products_scd') }}
select
    _airbyte_unique_key,
    {{ adapter.quote('id') }},
    tags,
    image,
    title,
    handle,
    images,
    status,
    vendor,
    {{ adapter.quote('options') }},
    shop_url,
    variants,
    body_html,
    created_at,
    updated_at,
    product_type,
    published_at,
    published_scope,
    template_suffix,
    admin_graphql_api_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_sf_products_hashid
from {{ ref('sf_products_scd') }}
-- sf_products from {{ source('public', '_airbyte_raw_sf_products') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

