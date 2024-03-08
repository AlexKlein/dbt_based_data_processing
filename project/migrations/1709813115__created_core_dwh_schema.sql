CREATE SCHEMA IF NOT EXISTS core_dwh;

-- Dimension Tables

CREATE TABLE IF NOT EXISTS core_dwh.dim_clients (
    client_id    SERIAL PRIMARY KEY,
    client_name  VARCHAR(100),
    client_type  VARCHAR(50),
    address      VARCHAR(255),
    phone_number VARCHAR(20),
    email        VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS core_dwh.dim_services (
    service_id          SERIAL PRIMARY KEY,
    service_name        VARCHAR(100),
    description         VARCHAR(255),
    delivery_time_frame VARCHAR(50),
    cost                NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS core_dwh.dim_cities (
    city_id   SERIAL PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS core_dwh.dim_currencies (
    currency_id   SERIAL PRIMARY KEY,
    currency_name VARCHAR(10)
);

-- Fact Tables

CREATE TABLE IF NOT EXISTS core_dwh.fact_parcels (
    parcel_id               SERIAL PRIMARY KEY,
    sender_id               INTEGER,
    receiver_id             INTEGER,
    origin_city_id          INTEGER,
    destination_city_id     INTEGER,
    service_id              INTEGER,
    sent_date               DATE,
    estimated_delivery_date DATE,
    actual_delivery_date    DATE,
    weight                  NUMERIC(10,2),
    status                  VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS core_dwh.fact_transactions (
    transaction_id   SERIAL PRIMARY KEY,
    client_id        INTEGER,
    transaction_date DATE,
    amount           NUMERIC(10,2),
    currency_id      INTEGER,
    transaction_type VARCHAR(50),
    details          VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS core_dwh.fact_shipments (
    shipment_id         SERIAL PRIMARY KEY,
    parcel_id           INTEGER,
    shipment_date       DATE,
    from_city_id        INTEGER,
    to_city_id          INTEGER,
    current_location_id INTEGER,
    status              VARCHAR(50)
);
