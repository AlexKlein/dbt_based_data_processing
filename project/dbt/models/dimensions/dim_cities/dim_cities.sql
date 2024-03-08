{{
    config(
        materialized='incremental',
        unique_key = 'city_id',
        alias='dim_cities'
    )
}}

SELECT
    ROW_NUMBER() OVER (ORDER BY cd.city) AS city_id,
    cd.city                              AS city_name

FROM
    {{ ref('temp_dim_cities') }} AS cd
