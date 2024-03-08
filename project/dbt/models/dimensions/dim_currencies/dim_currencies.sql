{{
    config(
        materialized='incremental',
        unique_key = 'currency_id',
        alias='dim_currencies'
    )
}}

WITH currency_data AS (

    SELECT
        DISTINCT
        m.currency AS currency

    FROM
        {{ ref('money_transactions') }} AS m

)

SELECT
    ROW_NUMBER() OVER (ORDER BY cd.currency) AS currency_id,
    cd.currency                              AS currency_name

FROM
    currency_data AS cd
