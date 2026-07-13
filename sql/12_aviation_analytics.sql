SELECT
    a.aircraft_type,
    a.tail_number,
    count(*) AS flights_count,
    sum(f.cargo_kg) AS total_cargo_kg,
    round(avg(CAST(f.cargo_kg AS DOUBLE) / a.max_payload_kg) * 100, 2) AS avg_payload_utilization_pct,
    round(avg(f.delay_minutes), 2) AS avg_delay_minutes
FROM iceberg.aviation.flight_events f
JOIN postgresql.public.aircraft a
    ON f.aircraft_id = a.aircraft_id
GROUP BY a.aircraft_type, a.tail_number
ORDER BY total_cargo_kg DESC;
