CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.parcels (
    id                      SERIAL PRIMARY KEY,
    sender_id               INTEGER,
    receiver_id             INTEGER,
    origin_city             VARCHAR(100),
    destination_city        VARCHAR(100),
    weight                  NUMERIC(10,2),
    service_type            VARCHAR(50),
    sent_date               DATE,
    estimated_delivery_date DATE,
    actual_delivery_date    DATE,
    status                  VARCHAR(50),
    tracking_number         VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS staging.money_transactions (
    id               SERIAL PRIMARY KEY,
    client_id        INTEGER,
    transaction_date DATE,
    amount           NUMERIC(10,2),
    currency         VARCHAR(10),
    transaction_type VARCHAR(50),
    details          VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS staging.shipments (
    id               SERIAL PRIMARY KEY,
    parcel_id        INTEGER,
    shipment_date    DATE,
    shipment_type    VARCHAR(50),
    from_city        VARCHAR(100),
    to_city          VARCHAR(100),
    current_location VARCHAR(100),
    status           VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS staging.clients (
    id           SERIAL PRIMARY KEY,
    client_name  VARCHAR(100),
    client_type  VARCHAR(50),
    address      VARCHAR(255),
    phone_number VARCHAR(20),
    email        VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS staging.services (
    id                  SERIAL PRIMARY KEY,
    service_name        VARCHAR(100),
    description         VARCHAR(255),
    delivery_time_frame VARCHAR(50),
    cost                NUMERIC(10,2)
);
