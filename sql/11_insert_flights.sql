INSERT INTO iceberg.aviation.flight_events
    (flight_id, aircraft_id, flight_date, origin_airport, destination_airport, cargo_kg, fuel_kg, delay_minutes, status)
VALUES
    (2001, 1, DATE '2026-07-01', 'UUEE', 'UNNT', 39000, 18500, 12, 'completed'),
    (2002, 2, DATE '2026-07-01', 'UUEE', 'UHWW', 95000, 43200, 0, 'completed'),
    (2003, 3, DATE '2026-07-02', 'UUEE', 'UHHH', 87000, 39800, 35, 'delayed'),
    (2004, 1, DATE '2026-07-02', 'UNNT', 'UUEE', 21000, 17100, 5, 'completed'),
    (2005, 4, DATE '2026-07-03', 'ULLI', 'UWWW', 26000, 11900, 0, 'completed'),
    (2006, 2, DATE '2026-07-03', 'UHWW', 'UUEE', 104000, 45100, 18, 'completed');
