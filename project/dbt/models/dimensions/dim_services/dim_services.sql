{{
    config(
        materialized='incremental',
        unique_key = 'service_id',
        alias='dim_services'
    )
}}

SELECT
    DISTINCT
    s.service_id          AS service_id,
    s.service_name        AS service_name,
    s.description         AS description,
    s.delivery_time_frame AS delivery_time_frame,
    s.cost                AS cost

FROM
    {{ ref('services') }} AS s
