# DBT Project based on Post Domain Data Processing

This project integrates Airflow and dbt to automate data processing workflows for the Post Domain dataset. It includes DAGs for data generation and ETL processes, alongside dbt models for transforming data within a PostgreSQL database.

## Airflow

As the scheduler I choose Airflow v2. You can get local access there using Access it locally at [this link](http://localhost:8080/home/). For login credentials, refer to [entrypoint.sh](./project/entrypoint.sh).

## Build and Run

When you need to start the app with all infrastructure, you have to make this steps:
1. Modify the environment variables in [env-file](./project/local.env) and [entrypoint.sh](./project/entrypoint.sh) (now there are default values) 
2. Correct your credential files in the [YML-file](./project/docker-compose.yml).
3. Run the following: `docker-compose up -d --build` command. Give it some time. Your app, tables, and Airflow will soon be ready.

## Data Pipelines

This document provides an overview of the data processing workflows.

### Data Generating (`db_generation`)

This DAG is responsible for data generating in `MY_SMALL_DWH` database. Should be launched as the first step if you use current build.

- **DAG ID:** `db_generation`
- **Schedule:** Only manual trigger.

### Data Processing (`dwh_uploading`)

The primary DAG responsible for running the dbt process to transform and load data into the data warehouse.

- **DAG ID:** `dwh_uploading`
- **Schedule:** On Monday at 8:30 AM.

#### dbt Models

The dbt component structures data transformation logic into models organized as follows:

```css
dbt
|- macros
| └-- generate_schema_name.sql
|- models
| |-- dimensions
| | └-- ...
| |-- facts
| | └-- ...
| |-- marts
| | └-- ...
| └-- staging
| └-- ...
| └-- sources.yml
|- dbt_project.yml
└- profiles.yml
```

#### Configuration Files

- **dbt_project.yml**: Configures dbt project settings, model paths, and schema naming conventions based on the environment (`prod` or `dev`).
- **profiles.yml**: Defines connection settings for different environments, pointing to the PostgreSQL instance.
- **generate_schema_name.sql (macro)**: A dbt macro used to dynamically generate schema names based on the environment and custom logic.

### Documentation Generation (`dbt_docs_generation`)

A DAG that generates dbt documentation and serves it on [this host](http://localhost:8081) for easy access and review. It takes really long time to build the web-server. After running the `dbt_docs_generation` DAG, dbt documentation will be providing a comprehensive overview of the dbt models, their relationships, and transformations.

- **DAG ID:** `dbt_docs_generation`
- **Schedule:** Only manual trigger.

## List of tables

```sql
-- Source data from a Post Service
select * from post_service.parcels;
select * from post_service.money_transactions;
select * from post_service.shipments;
select * from post_service.clients;
select * from post_service.services;

-- Copies of source tables in staging layer
select * from staging.clients;
select * from staging.money_transactions;
select * from staging.parcels;
select * from staging.services;
select * from staging.shipments;

-- Core layer of DWH with fact and dimension tables
select * from core_dwh.dim_cities;
select * from core_dwh.dim_clients;
select * from core_dwh.dim_currencies;
select * from core_dwh.dim_services;

select * from core_dwh.fact_parcels;
select * from core_dwh.fact_shipments;
select * from core_dwh.fact_transactions;

-- Post Service domain with two datamarts
select * from dm_post.delay_report;
select * from dm_post.financial_report;
```

## Database Migrations

- **generate_migration.sh**: A shell script used for generating generic SQL migration files. These files can be customized to include SQL statements for schema creation, table creation, permission grants, etc.

## Troubleshooting

### standard_init_linux.go:228

If you encounter the error message **standard_init_linux.go:228: exec user process caused: no such file or directory** when running your Docker container, it may be due to an issue with the encoding of your [entrypoint.sh](./project/entrypoint.sh) file.

To resolve this issue, follow these steps:

1. **Check File Encoding:** Ensure that the [entrypoint.sh](./project/entrypoint.sh) file is encoded correctly. It should be in UTF-8.
2. **Correct Encoding Issues:** If you suspect encoding issues, you can use a text editor that allows you to change the file's encoding to UTF-8. Save the file with UTF-8 encoding, and then try running your Docker container again.
3. **Line Endings:** Verify that the line endings (Unix vs. Windows) in your [entrypoint.sh](./project/entrypoint.sh) file are appropriate for your platform. Use a text editor that allows you to convert line endings if necessary.
By following these steps, you can resolve the "no such file or directory" error related to the [entrypoint.sh](./project/entrypoint.sh) file encoding.
