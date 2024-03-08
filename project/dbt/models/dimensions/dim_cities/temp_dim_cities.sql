{{
    config(
        materialized='ephemeral',
        alias='temp_dim_cities'
    )
}}

SELECT
    DISTINCT
    p.origin_city AS city

FROM
    {{ ref('parcels') }} AS p

UNION

SELECT
    DISTINCT
    p.destination_city AS city

FROM
    {{ ref('parcels') }} AS p

UNION

SELECT
    DISTINCT
    s.from_city AS city

FROM
    {{ ref('shipments') }} AS s

UNION

SELECT
    DISTINCT
    s.to_city AS city

FROM
    {{ ref('shipments') }} AS s

UNION

SELECT
    DISTINCT
    s.current_location AS city

FROM
    {{ ref('shipments') }} AS s
