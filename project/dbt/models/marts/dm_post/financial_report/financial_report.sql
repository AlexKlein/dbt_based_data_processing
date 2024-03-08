{{
    config(
        materialized='table',
        alias='financial_report',
        pre_hook=[
            "DELETE FROM {{ this }} WHERE report_date IN (SELECT COALESCE(MAX(report_date), date'1900-01-01') AS max_date FROM {{ this }} )"
        ]
    )
}}

SELECT
    f.client_name            AS client_name,
    f.report_date            AS report_date,
    f.total_amount           AS total_amount,
    f.currency_name          AS currency_name,
    f.number_of_transactions AS number_of_transactions

FROM
    {{ ref('temp_financial_summary_monthly') }} AS f

WHERE
    DATE(f.report_date) NOT IN (
        SELECT
            DISTINCT
            report_date
        FROM
            {{ this }}
)
