SELECT
    parcel_id

FROM
    {{ ref('fact_parcels' )}}

WHERE
    weight <= 0
