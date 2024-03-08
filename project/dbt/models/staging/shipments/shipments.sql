{{
    config(
        materialized='table',
        alias='shipments'
    )
}}

SELECT
    s.id               AS shipment_id,
    s.parcel_id        AS parcel_id,
    s.shipment_date    AS shipment_date,
    s.shipment_type    AS shipment_type,
    s.from_city        AS from_city,
    s.to_city          AS to_city,
    s.current_location AS current_location,
    s.status           AS status

FROM
    {{ source('post_service', 'shipments') }} AS s
