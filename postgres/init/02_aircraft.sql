CREATE TABLE IF NOT EXISTS aircraft (
    aircraft_id BIGINT PRIMARY KEY,
    tail_number TEXT NOT NULL,
    aircraft_type TEXT NOT NULL,
    home_airport TEXT NOT NULL,
    max_payload_kg BIGINT NOT NULL
);

INSERT INTO aircraft (aircraft_id, tail_number, aircraft_type, home_airport, max_payload_kg)
VALUES
    (1, 'RA-76511', 'IL-76TD', 'UUEE', 48000),
    (2, 'RA-82078', 'AN-124', 'UUEE', 120000),
    (3, 'VP-BIG', 'Boeing 747F', 'UUEE', 112000),
    (4, 'RA-64024', 'TU-204C', 'ULLI', 30000)
ON CONFLICT (aircraft_id) DO NOTHING;
