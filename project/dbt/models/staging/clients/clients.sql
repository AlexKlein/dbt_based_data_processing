{{
    config(
        materialized='table',
        alias='clients'
    )
}}

SELECT
    cl.id           AS client_id,
    cl.client_name  AS client_name,
    cl.client_type  AS client_type,
    cl.address      AS address,
    cl.phone_number AS phone_number,
    cl.email        AS email

FROM
    {{ source('post_service', 'clients') }} AS cl
