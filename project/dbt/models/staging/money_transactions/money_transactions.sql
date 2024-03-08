{{
    config(
        materialized='table',
        alias='money_transactions'
    )
}}

SELECT
    m.id               AS transaction_id,
    m.client_id        AS client_id,
    m.transaction_date AS transaction_date,
    m.amount           AS amount,
    m.currency         AS currency,
    m.transaction_type AS transaction_type,
    m.details          AS details

FROM
    {{ source('post_service', 'money_transactions') }} AS m
