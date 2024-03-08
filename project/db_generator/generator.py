import glob
import os

import psycopg2
from datetime import date, timedelta
import random

def create_database_connection():
    """Create a connection to the PostgreSQL database."""
    conn = psycopg2.connect(
        dbname='postgres',
        user='postgres',
        password='postgres',
        host='my_small_dwh',
        port=5432
    )
    return conn

def setup_post_service_schema(cur):
    """Create the necessary schema and tables for the post service system."""
    cur.execute('''
        CREATE SCHEMA IF NOT EXISTS post_service;
    ''')

    # Parcels table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS post_service.parcels (
            id SERIAL PRIMARY KEY,
            sender_id INTEGER,
            receiver_id INTEGER,
            origin_city VARCHAR(100),
            destination_city VARCHAR(100),
            weight NUMERIC(10,2),
            service_type VARCHAR(50),
            sent_date DATE,
            estimated_delivery_date DATE,
            actual_delivery_date DATE,
            status VARCHAR(50),
            tracking_number VARCHAR(100)
        );
    ''')

    # Money transactions table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS post_service.money_transactions (
            id SERIAL PRIMARY KEY,
            client_id INTEGER,
            transaction_date DATE,
            amount NUMERIC(10,2),
            currency VARCHAR(10),
            transaction_type VARCHAR(50),
            details VARCHAR(255)
        );
    ''')

    # Shipments table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS post_service.shipments (
            id SERIAL PRIMARY KEY,
            parcel_id INTEGER REFERENCES post_service.parcels(id),
            shipment_date DATE,
            shipment_type VARCHAR(50),
            from_city VARCHAR(100),
            to_city VARCHAR(100),
            current_location VARCHAR(100),
            status VARCHAR(50)
        );
    ''')

    # Clients table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS post_service.clients (
            id SERIAL PRIMARY KEY,
            client_name VARCHAR(100),
            client_type VARCHAR(50),
            address VARCHAR(255),
            phone_number VARCHAR(20),
            email VARCHAR(100)
        );
    ''')

    # Services table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS post_service.services (
            id SERIAL PRIMARY KEY,
            service_name VARCHAR(100),
            description VARCHAR(255),
            delivery_time_frame VARCHAR(50),
            cost NUMERIC(10,2)
        );
    ''')

def insert_post_service_sample_data(cur):
    """Insert sample data into the post service tables."""

    # Clients
    clients = ["Alpha Corp", "Beta Ltd", "Gamma Industries", "Delta Services"]
    for client in clients:
        cur.execute('''
            INSERT INTO post_service.clients (client_name, client_type, address, phone_number, email)
            VALUES (%s, %s, %s, %s, %s);
        ''', (client, "Business", "123 Main St", "555-1234", client.lower().replace(" ", "") + "@example.com"))

    # Services
    services = [
        ("Standard", "Most popular service", "3-5 business days", 5.99),
        ("Express", "You order - we've already delivered", "1-2 business days", 15.99),
        ("International", "Your close people far? We can help", "5-10 business days", 25.99)
    ]
    for service in services:
        cur.execute('''
            INSERT INTO post_service.services (service_name, description, delivery_time_frame, cost)
            VALUES (%s, %s, %s, %s);
        ''', service)

    # Parcels and Money Transactions
    cities = ["Los Angeles", "New York", "London", "Tokyo", "Sydney"]
    statuses = ["Sent", "In Transit", "Delivered"]
    for i in range(42):
        sender_id = random.randint(1, len(clients))
        receiver_id = random.randint(1, len(clients))
        while sender_id == receiver_id:
            receiver_id = random.randint(1, len(clients))

        origin_city = random.choice(cities)
        destination_city = random.choice(cities)
        while destination_city == origin_city:
            destination_city = random.choice(cities)

        sent_date = date.today() - timedelta(days=random.randint(1, 30))
        estimated_delivery_date = sent_date + timedelta(days=random.randint(1, 10))
        actual_delivery_date = estimated_delivery_date + timedelta(days=random.randint(-2, 2))
        status = random.choice(statuses)

        cur.execute('''
            INSERT INTO post_service.parcels (sender_id, receiver_id, origin_city, destination_city, weight, service_type, sent_date, estimated_delivery_date, actual_delivery_date, status, tracking_number)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
        ''', (sender_id, receiver_id, origin_city, destination_city, random.uniform(0.1, 10.0), "Standard", sent_date, estimated_delivery_date, actual_delivery_date, status, f"TRK{i:04d}"))

        cur.execute('''
            INSERT INTO post_service.money_transactions (client_id, transaction_date, amount, currency, transaction_type, details)
            VALUES (%s, %s, %s, %s, %s, %s);
        ''', (sender_id, sent_date, random.uniform(5.0, 100.0), "USD", "Postage", f"Parcel ID: {i+1}"))

    # Shipments
    for i in range(42):
        parcel_id = i + 1  # Assuming parcel IDs are sequential and start from 1
        shipment_date = date.today() - timedelta(days=random.randint(1, 30))
        shipment_type = random.choice(["Ground", "Air"])
        from_city = random.choice(cities)
        to_city = random.choice(cities)
        while to_city == from_city:
            to_city = random.choice(cities)
        current_location = random.choice(cities)
        status = random.choice(["Shipped", "In Transit", "Arrived"])

        cur.execute('''
            INSERT INTO post_service.shipments (parcel_id, shipment_date, shipment_type, from_city, to_city, current_location, status)
            VALUES (%s, %s, %s, %s, %s, %s, %s);
        ''', (parcel_id, shipment_date, shipment_type, from_city, to_city, current_location, status))


def execute_sql_scripts_from_directory(cur, directory="migrations"):
    """Executes all SQL scripts found in the specified directory."""
    full_path = os.path.join(os.getcwd(), directory)

    sql_files = glob.glob(os.path.join(full_path, "*.sql"))

    for sql_file in sql_files:
        with open(sql_file, 'r') as file:
            sql_script = file.read()
            try:
                cur.execute(sql_script)
                print(f"Successfully executed {sql_file}")
            except Exception as e:
                print(f"Error executing {sql_file}: {e}")


def start_generation():
    """Main function to generate the sample data in the post service database."""
    conn = create_database_connection()
    cur = conn.cursor()

    setup_post_service_schema(cur)
    insert_post_service_sample_data(cur)
    execute_sql_scripts_from_directory(cur)

    conn.commit()
    cur.close()
    conn.close()
