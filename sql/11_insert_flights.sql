INSERT INTO iceberg.aviation.flight_events
    (flight_id, aircraft_id, flight_date, origin_airport, destination_airport, cargo_kg, fuel_kg, delay_minutes, status)
WITH generated_flights AS (
    SELECT
        n,
        CAST(((n - 1) % 4) + 1 AS BIGINT) AS aircraft_id
    FROM UNNEST(sequence(1, 500)) AS t(n)
)
SELECT
    2000 + n AS flight_id,
    aircraft_id,
    date_add('day', CAST((n - 1) % 30 AS INTEGER), DATE '2026-07-01') AS flight_date,
    element_at(ARRAY['UUEE', 'ULLI', 'UNNT', 'UHWW', 'UHHH', 'UWWW'], CAST(((n - 1) % 6) + 1 AS INTEGER)) AS origin_airport,
    element_at(ARRAY['UNNT', 'UHWW', 'UHHH', 'UWWW', 'UUEE', 'ULLI'], CAST((n % 6) + 1 AS INTEGER)) AS destination_airport,
    CAST(
        CASE aircraft_id
            WHEN 1 THEN 18000 + ((n * 137) % 25000)
            WHEN 2 THEN 65000 + ((n * 211) % 48000)
            WHEN 3 THEN 58000 + ((n * 193) % 46000)
            ELSE 12000 + ((n * 89) % 15000)
        END AS BIGINT
    ) AS cargo_kg,
    CAST(
        CASE aircraft_id
            WHEN 1 THEN 14500 + ((n * 71) % 5200)
            WHEN 2 THEN 33500 + ((n * 113) % 9800)
            WHEN 3 THEN 31200 + ((n * 97) % 9200)
            ELSE 9800 + ((n * 43) % 2600)
        END AS BIGINT
    ) AS fuel_kg,
    CAST(
        CASE
            WHEN n % 17 = 0 THEN 45 + (n % 35)
            WHEN n % 9 = 0 THEN 15 + (n % 20)
            ELSE n % 12
        END AS INTEGER
    ) AS delay_minutes,
    CASE
        WHEN n % 41 = 0 THEN 'cancelled'
        WHEN n % 17 = 0 THEN 'delayed'
        ELSE 'completed'
    END AS status
FROM generated_flights;
