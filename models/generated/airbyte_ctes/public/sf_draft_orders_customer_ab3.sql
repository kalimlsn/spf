{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_customer_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_sf_draft_orders_hashid',
        adapter.quote('id'),
        'note',
        'tags',
        'email',
        'phone',
        adapter.quote('state'),
        'currency',
        'last_name',
        'created_at',
        'first_name',
        boolean_to_string('tax_exempt'),
        'updated_at',
        'total_spent',
        'orders_count',
        'last_order_id',
        array_to_string('tax_exemptions'),
        boolean_to_string('verified_email'),
        object_to_string('default_address'),
        'last_order_name',
        boolean_to_string('accepts_marketing'),
        'admin_graphql_api_id',
        'multipass_identifier',
        'marketing_opt_in_level',
        'accepts_marketing_updated_at',
    ]) }} as _airbyte_customer_hashid,
    tmp.*
from {{ ref('sf_draft_orders_customer_ab2') }} tmp
-- customer at sf_draft_orders/customer
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

