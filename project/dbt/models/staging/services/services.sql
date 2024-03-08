{{
    config(
        materialized='table',
        alias='services'
    )
}}

SELECT
    s.id                  AS service_id,
    s.service_name        AS service_name,
    s.description         AS description,
    s.delivery_time_frame AS delivery_time_frame,
    s.cost                AS cost

FROM
    {{ source('post_service', 'services') }} AS s
