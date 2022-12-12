{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_products_variants__sentment_prices_price_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_presentment_prices_hashid',
        'amount',
        'currency_code',
    ]) }} as _airbyte_price_hashid,
    tmp.*
from {{ ref('sf_products_variants__sentment_prices_price_ab2') }} tmp
-- price at sf_products/variants/presentment_prices/price
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

