{{
    config(
        materialized='incremental',
        unique_key = [
            'service_name',
            'origin_city',
            'destination_city'
        ],
        alias='delay_report'
    )
}}

SELECT
    d.service_name       AS service_name,
    d.origin_city        AS origin_city,
    d.destination_city   AS destination_city,
    d.average_delay_days AS average_delay_days,
    d.number_of_delays   AS number_of_delays

FROM
    {{ ref('temp_delay_report') }} AS d
