{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_products_variants_ab3') }}
select
    _airbyte_sf_products_hashid,
    {{ adapter.quote('id') }},
    sku,
    price,
    title as name,
 	'[{"name":"option1" ,"option" :option1},{"name":"option1" ,"option" : option2"},{"name":"option1" ,"option" : option3}]'::json  as attributes,

    shop_url,
    created_at,
    product_id as parent_id,
    updated_at,
    presentment_prices,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_variants_hashid
from {{ ref('sf_products_variants_ab3') }}
-- variants at sf_products/variants from {{ ref('sf_products_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

