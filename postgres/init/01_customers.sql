CREATE TABLE IF NOT EXISTS customers (
    customer_id BIGINT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    segment TEXT NOT NULL,
    region TEXT NOT NULL
);

INSERT INTO customers (customer_id, customer_name, segment, region)
VALUES
    (1, 'Volga Oil Service', 'enterprise', 'Volga'),
    (2, 'North Drilling', 'enterprise', 'North-West'),
    (3, 'Siberia Energy', 'strategic', 'Siberia'),
    (4, 'Caspian Logistics', 'mid-market', 'South')
ON CONFLICT (customer_id) DO NOTHING;

