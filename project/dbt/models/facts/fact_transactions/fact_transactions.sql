{{
    config(
        materialized='table',
        alias='fact_transactions',
        pre_hook=[
            "DELETE FROM {{ this }} WHERE transaction_date IN (SELECT COALESCE(MAX(transaction_date), date'1900-01-01') AS max_date FROM {{ this }} )"
        ]
    )
}}

SELECT
    m.transaction_id   AS transaction_id,
    m.client_id        AS client_id,
    m.transaction_date AS transaction_date,
    m.amount           AS amount,
    c.currency_id      AS currency_id

FROM
    {{ ref('money_transactions') }}        AS m
    LEFT  JOIN {{ ref('dim_currencies') }} AS c ON m.currency = c.currency_name

WHERE
    DATE(m.transaction_date) NOT IN (
        SELECT
            DISTINCT
            transaction_date
        FROM
            {{ this }}
)
