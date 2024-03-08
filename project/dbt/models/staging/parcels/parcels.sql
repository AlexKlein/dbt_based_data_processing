{{
    config(
        materialized='table',
        alias='parcels'
    )
}}

SELECT
    p.id                      AS parcel_id,
    p.sender_id               AS sender_id,
    p.receiver_id             AS receiver_id,
    p.origin_city             AS origin_city,
    p.destination_city        AS destination_city,
    p.weight                  AS weight,
    p.service_type            AS service_type,
    p.sent_date               AS sent_date,
    p.estimated_delivery_date AS estimated_delivery_date,
    p.actual_delivery_date    AS actual_delivery_date,
    p.status                  AS status,
    p.tracking_number         AS tracking_number

FROM
    {{ source('post_service', 'parcels') }} AS p
