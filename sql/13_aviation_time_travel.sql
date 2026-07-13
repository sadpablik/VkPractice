SELECT
    snapshot_id,
    committed_at,
    operation
FROM iceberg.aviation."flight_events$snapshots"
ORDER BY committed_at;

INSERT INTO iceberg.aviation.flight_events
    (flight_id, aircraft_id, flight_date, origin_airport, destination_airport, cargo_kg, fuel_kg, delay_minutes, status)
VALUES
    (2007, 3, DATE '2026-07-04', 'UHHH', 'UUEE', 91000, 40500, 7, 'completed');

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
ORDER BY flight_id;
