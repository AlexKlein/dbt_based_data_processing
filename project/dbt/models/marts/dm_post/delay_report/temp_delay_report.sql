{{
    config(
        materialized='ephemeral',
        alias='temp_delay_report'
    )
}}

SELECT
    s.service_name AS service_name,
    o.city_name    AS origin_city,
    d.city_name    AS destination_city,
    AVG(
        p.actual_delivery_date -
        p.estimated_delivery_date
    )              AS average_delay_days,
    COUNT(
        p.parcel_id
    )              AS number_of_delays

FROM
    {{ ref('fact_parcels') }}            AS p
    INNER JOIN {{ ref('dim_services') }} AS s ON p.service_id = s.service_id
    INNER JOIN {{ ref('dim_cities') }}   AS o ON p.origin_city_id = o.city_id
    INNER JOIN {{ ref('dim_cities') }}   AS d ON p.destination_city_id = d.city_id

WHERE
    p.actual_delivery_date > p.estimated_delivery_date

GROUP BY
    s.service_name,
    o.city_name,
    d.city_name
