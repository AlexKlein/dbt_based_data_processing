{{
    config(
        materialized='incremental',
        unique_key = 'parcel_id',
        alias='fact_parcels'
    )
}}

SELECT
    p.parcel_id               AS parcel_id,
    p.sender_id               AS sender_id,
    p.receiver_id             AS receiver_id,
    o.city_id                 AS origin_city_id,
    d.city_id                 AS destination_city_id,
    s.service_id              AS service_id,
    p.sent_date               AS sent_date,
    p.estimated_delivery_date AS estimated_delivery_date,
    p.actual_delivery_date    AS actual_delivery_date,
    p.weight                  AS weight,
    p.status                  AS status

FROM
    {{ ref('parcels') }}                 AS p
    LEFT  JOIN {{ ref('dim_services') }} AS s ON p.service_type = s.service_name
    LEFT  JOIN {{ ref('dim_cities') }}   AS o ON p.origin_city = o.city_name
    LEFT  JOIN {{ ref('dim_cities') }}   AS d ON p.destination_city = d.city_name
