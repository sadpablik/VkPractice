SELECT
    snapshot_id,
    committed_at,
    operation
FROM iceberg.aviation."flight_events$snapshots"
ORDER BY committed_at;

INSERT INTO iceberg.aviation.flight_events
    (flight_id, aircraft_id, flight_date, origin_airport, destination_airport, cargo_kg, fuel_kg, delay_minutes, status)
VALUES
    (3001, 3, DATE '2026-07-31', 'UHHH', 'UUEE', 91000, 40500, 7, 'completed');

SELECT
    count(*) AS total_flights,
    min(flight_id) AS first_flight_id,
    max(flight_id) AS last_flight_id,
    sum(cargo_kg) AS total_cargo_kg
FROM iceberg.aviation.flight_events;

SELECT
    flight_id,
    aircraft_id,
    flight_date,
    origin_airport,
    destination_airport,
    cargo_kg,
    fuel_kg,
    delay_minutes,
    status
FROM iceberg.aviation.flight_events
ORDER BY flight_id
LIMIT 12;
