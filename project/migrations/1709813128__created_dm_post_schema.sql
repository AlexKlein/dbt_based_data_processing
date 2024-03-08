CREATE SCHEMA IF NOT EXISTS dm_post;

CREATE TABLE IF NOT EXISTS dm_post.financial_report (
    client_name            VARCHAR(100),
    report_date            DATE PRIMARY KEY,
    total_amount           NUMERIC(10,2),
    currency_name          VARCHAR(100),
    number_of_transactions INTEGER
);

CREATE TABLE IF NOT EXISTS dm_post.delay_report (
    service_name       VARCHAR(100),
    origin_city        VARCHAR(100),
    destination_city   VARCHAR(100),
    average_delay_days NUMERIC(10,2),
    number_of_delays   INTEGER
);
