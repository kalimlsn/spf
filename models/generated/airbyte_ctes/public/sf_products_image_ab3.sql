{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_products_image_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_products_hashid',
        adapter.quote('id'),
        'alt',
        'src',
        'width',
        'height',
        adapter.quote('position'),
        'created_at',
        'updated_at',
        array_to_string('variant_ids'),
        'admin_graphql_api_id',
    ]) }} as _airbyte_image_hashid,
    tmp.*
from {{ ref('sf_products_image_ab2') }} tmp
-- image at sf_products/image
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

