{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_customers_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('id'),
        'note',
        'tags',
        'email',
        'phone',
        adapter.quote('state'),
        'currency',
        'shop_url',
        array_to_string('addresses'),
        'last_name',
        'created_at',
        'first_name',
        boolean_to_string('tax_exempt'),
        'updated_at',
        'total_spent',
        'orders_count',
        'last_order_id',
        boolean_to_string('verified_email'),
        object_to_string('default_address'),
        'last_order_name',
        boolean_to_string('accepts_marketing'),
        'admin_graphql_api_id',
        'multipass_identifier',
        'accepts_marketing_updated_at',
    ]) }} as _airbyte_sf_customers_hashid,
    tmp.*
from {{ ref('sf_customers_ab2') }} tmp
-- sf_customers
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

