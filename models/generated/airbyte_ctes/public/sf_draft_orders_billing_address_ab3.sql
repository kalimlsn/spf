{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_billing_address_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_draft_orders_hashid',
        'zip',
        'city',
        adapter.quote('name'),
        'phone',
        'company',
        'country',
        'address1',
        'address2',
        'latitude',
        'province',
        'last_name',
        'longitude',
        'first_name',
        'country_code',
        'province_code',
    ]) }} as _airbyte_billing_address_hashid,
    tmp.*
from {{ ref('sf_draft_orders_billing_address_ab2') }} tmp
-- billing_address at sf_draft_orders/billing_address
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

