{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_customers_addresses_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_customers_hashid',
        adapter.quote('id'),
        'zip',
        'city',
        adapter.quote('name'),
        'phone',
        'company',
        'country',
        boolean_to_string(adapter.quote('default')),
        'address1',
        'address2',
        'province',
        'last_name',
        'first_name',
        'customer_id',
        'country_code',
        'country_name',
        'province_code',
    ]) }} as _airbyte_addresses_hashid,
    tmp.*
from {{ ref('sf_customers_addresses_ab2') }} tmp
-- addresses at sf_customers/addresses
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

