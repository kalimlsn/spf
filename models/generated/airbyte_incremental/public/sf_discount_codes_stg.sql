{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_discount_codes_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('id'),
        'code',
        'shop_url',
        'created_at',
        'updated_at',
        'usage_count',
        'price_rule_id',
    ]) }} as _airbyte_sf_discount_codes_hashid,
    tmp.*
from {{ ref('sf_discount_codes_ab2') }} tmp
-- sf_discount_codes
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

