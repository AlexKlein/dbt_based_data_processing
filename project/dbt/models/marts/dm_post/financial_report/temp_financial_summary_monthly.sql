{{
    config(
        materialized='ephemeral',
        alias='temp_financial_summary_monthly'
    )
}}

SELECT
    c.client_name           AS client_name,
    DATE(
        DATE_TRUNC(
            'month',
            t.transaction_date
        )
    )                       AS report_date,
    SUM(t.amount)           AS total_amount,
    r.currency_name         AS currency_name,
    COUNT(t.transaction_id) AS number_of_transactions

FROM
    {{ ref('fact_transactions') }}         AS t
    INNER JOIN {{ ref('dim_clients') }}    AS c ON t.client_id = c.client_id
    INNER JOIN {{ ref('dim_currencies') }} AS r ON t.currency_id = r.currency_id

GROUP BY
    c.client_name,
    DATE_TRUNC(
        'month',
        t.transaction_date
    ),
    r.currency_name
