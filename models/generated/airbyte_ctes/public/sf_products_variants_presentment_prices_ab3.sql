{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_products_variants_presentment_prices_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_variants_hashid',
        object_to_string('price'),
        'compare_at_price',
    ]) }} as _airbyte_presentment_prices_hashid,
    tmp.*
from {{ ref('sf_products_variants_presentment_prices_ab2') }} tmp
-- presentment_prices at sf_products/variants/presentment_prices
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

