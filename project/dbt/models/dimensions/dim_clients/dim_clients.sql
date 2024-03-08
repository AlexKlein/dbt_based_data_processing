{{
    config(
        materialized='incremental',
        unique_key = 'client_id',
        alias='dim_clients'
    )
}}

SELECT
    cl.client_id    AS client_id,
    cl.client_name  AS client_name,
    cl.client_type  AS client_type,
    cl.address      AS address,
    cl.phone_number AS phone_number,
    cl.email        AS email

FROM
    {{ ref('clients') }} AS cl
