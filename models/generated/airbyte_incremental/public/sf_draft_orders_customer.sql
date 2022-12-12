{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_draft_orders_customer_ab3') }}
select
    _airbyte_sf_draft_orders_hashid,
    {{ adapter.quote('id') }},
    note,
    tags,
    email,
    phone,
    {{ adapter.quote('state') }},
    currency,
    last_name,
    created_at,
    first_name,
    tax_exempt,
    updated_at,
    total_spent,
    orders_count,
    last_order_id,
    tax_exemptions,
    verified_email,
    default_address,
    last_order_name,
    accepts_marketing,
    admin_graphql_api_id,
    multipass_identifier,
    marketing_opt_in_level,
    accepts_marketing_updated_at,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_customer_hashid
from {{ ref('sf_draft_orders_customer_ab3') }}
-- customer at sf_draft_orders/customer from {{ ref('sf_draft_orders_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

