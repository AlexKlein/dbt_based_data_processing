{{
    config(
        materialized='table',
        alias='fact_shipments',
        pre_hook=[
            "DELETE FROM {{ this }} WHERE shipment_date IN (SELECT COALESCE(MAX(shipment_date), date'1900-01-01') AS max_date FROM {{ this }} )"
        ]
    )
}}

SELECT
    s.shipment_id      AS shipment_id,
    s.parcel_id        AS parcel_id,
    s.shipment_date    AS shipment_date,
    f.city_id          AS from_city_id,
    t.city_id          AS to_city_id,
    l.city_id          AS current_location_id,
    s.status           AS status

FROM
    {{ ref('shipments') }}             AS s
    LEFT  JOIN {{ ref('dim_cities') }} AS f ON s.from_city = f.city_name
    LEFT  JOIN {{ ref('dim_cities') }} AS t ON s.to_city = t.city_name
    LEFT  JOIN {{ ref('dim_cities') }} AS l ON s.current_location = l.city_name

WHERE
    DATE(s.shipment_date) NOT IN (
        SELECT
            DISTINCT
            shipment_date
        FROM
            {{ this }}
)
