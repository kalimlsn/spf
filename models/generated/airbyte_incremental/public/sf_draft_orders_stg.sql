{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('sf_draft_orders_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('id'),
        adapter.quote('name'),
        'note',
        'tags',
        'email',
        'status',
        'currency',
        object_to_string('customer'),
        'order_id',
        'shop_url',
        array_to_string('tax_lines'),
        'total_tax',
        'created_at',
        array_to_string('line_items'),
        boolean_to_string('tax_exempt'),
        'updated_at',
        'invoice_url',
        'total_price',
        'completed_at',
        object_to_string('shipping_line'),
        'subtotal_price',
        boolean_to_string('taxes_included'),
        object_to_string('billing_address'),
        'invoice_sent_at',
        array_to_string('note_attributes'),
        object_to_string('applied_discount'),
        object_to_string('shipping_address'),
        'admin_graphql_api_id',
    ]) }} as _airbyte_sf_draft_orders_hashid,
    tmp.*
from {{ ref('sf_draft_orders_ab2') }} tmp
-- sf_draft_orders
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

