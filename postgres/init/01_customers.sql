CREATE TABLE IF NOT EXISTS customers (
    customer_id BIGINT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    segment TEXT NOT NULL,
    region TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS iceberg_namespace_properties (
    catalog_name VARCHAR(255) NOT NULL,
    namespace VARCHAR(255) NOT NULL,
    property_key VARCHAR(5500) NOT NULL,
    property_value VARCHAR(5500),
    PRIMARY KEY (catalog_name, namespace, property_key)
);

CREATE TABLE IF NOT EXISTS iceberg_tables (
    catalog_name VARCHAR(255) NOT NULL,
    table_namespace VARCHAR(255) NOT NULL,
    table_name VARCHAR(255) NOT NULL,
    metadata_location VARCHAR(5500),
    previous_metadata_location VARCHAR(5500),
    PRIMARY KEY (catalog_name, table_namespace, table_name)
);

INSERT INTO customers (customer_id, customer_name, segment, region)
VALUES
    (1, 'Volga Oil Service', 'enterprise', 'Volga'),
    (2, 'North Drilling', 'enterprise', 'North-West'),
    (3, 'Siberia Energy', 'strategic', 'Siberia'),
    (4, 'Caspian Logistics', 'mid-market', 'South')
ON CONFLICT (customer_id) DO NOTHING;
