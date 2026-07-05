# Mini-Lakehouse architecture

## Services

| Service | Role | Port |
| --- | --- | --- |
| Trino | SQL engine and federated queries | 8080 |
| MinIO | S3-compatible object storage | 9000, 9001 |
| PostgreSQL | Iceberg JDBC catalog and OLTP source table | 5432 |
| Iceberg | Table format used by Trino connector | via Trino |

## Data flow

```text
PostgreSQL customers
        |
        | federated JOIN
        v
Trino SQL engine <----> Iceberg table metadata in PostgreSQL
        |
        v
MinIO / S3 bucket: iceberg-warehouse
        |
        v
Parquet data files + Iceberg metadata
```

This is the implemented MVP flow. It demonstrates the core analytical loop:

```text
Source data -> Lakehouse storage -> Trino SQL -> analytical result
```

The next development iteration should add a simple ETL layer:

```text
CSV / PostgreSQL -> Spark ETL -> Iceberg (S3/MinIO) -> Trino -> Superset
```

Apache Kafka is kept in the target architecture, but it is not part of the first local MVP. The streaming layer is planned for the next 6 months of platform development, after the storage, SQL and basic ETL layers are stable.

## Why these components

Trino is used as the single SQL access layer. It can query Iceberg tables and PostgreSQL tables in one SQL statement, which demonstrates federated analytics.

MinIO is used as a local S3-compatible storage layer. It keeps the homework runnable on a laptop while preserving the same storage interface as a production Lakehouse.

PostgreSQL has two roles in this mini-stand: it stores Iceberg JDBC catalog metadata and also provides a small OLTP-like `customers` table for the federated JOIN.

Apache Iceberg is the table format for analytical data. It provides snapshots, schema evolution and time travel over files stored in object storage.

## Scope

Implemented in the first stage:

- Docker Compose;
- MinIO / S3;
- PostgreSQL;
- Trino;
- Iceberg catalog;
- Iceberg table creation;
- test data load;
- SQL queries;
- federated JOIN;
- Time Travel.

Deferred to later iterations:

- Spark ETL;
- Airflow DAG;
- Kafka streaming pipeline;
- ClickHouse marts;
- Superset dashboard;
- OpenMetadata lineage;
- RBAC, monitoring and production setup.
