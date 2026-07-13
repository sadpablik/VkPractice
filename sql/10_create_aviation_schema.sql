CREATE SCHEMA IF NOT EXISTS iceberg.aviation
WITH (location = 's3://iceberg-warehouse/aviation/');

DROP TABLE IF EXISTS iceberg.aviation.flight_events;

CREATE TABLE iceberg.aviation.flight_events (
    flight_id BIGINT,
    aircraft_id BIGINT,
    flight_date DATE,
    origin_airport VARCHAR,
    destination_airport VARCHAR,
    cargo_kg BIGINT,
    fuel_kg BIGINT,
    delay_minutes INTEGER,
    status VARCHAR
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['day(flight_date)']
);
