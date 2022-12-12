{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_products_options_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_products_hashid',
        adapter.quote('id'),
        adapter.quote('name'),
        array_to_string(adapter.quote('values')),
        adapter.quote('position'),
        'product_id',
    ]) }} as _airbyte_options_hashid,
    tmp.*
from {{ ref('sf_products_options_ab2') }} tmp
-- options at sf_products/options
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

