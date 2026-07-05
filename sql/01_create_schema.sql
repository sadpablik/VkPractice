CREATE SCHEMA IF NOT EXISTS iceberg.demo
WITH (location = 's3://iceberg-warehouse/demo/');

DROP TABLE IF EXISTS iceberg.demo.orders;

CREATE TABLE iceberg.demo.orders (
    order_id BIGINT,
    customer_id BIGINT,
    order_date DATE,
    amount DECIMAL(12, 2),
    channel VARCHAR,
    status VARCHAR
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['day(order_date)']
);

