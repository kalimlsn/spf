{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('sf_customers_addresses_ab3') }}
select
    _airbyte_sf_customers_hashid,
    {{ adapter.quote('id') }},
    zip,
    city,
    {{ adapter.quote('name') }},
    phone,
    company,
    country,
    {{ adapter.quote('default') }},
    address1,
    address2,
    province,
    last_name,
    first_name,
    customer_id,
    country_code,
    country_name,
    province_code,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_addresses_hashid
from {{ ref('sf_customers_addresses_ab3') }}
-- addresses at sf_customers/addresses from {{ ref('sf_customers_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

