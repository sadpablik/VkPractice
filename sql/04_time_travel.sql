-- 1. Save the first snapshot id after the initial load.
SELECT
    snapshot_id,
    committed_at,
    operation
FROM iceberg.demo."orders$snapshots"
ORDER BY committed_at;

-- 2. Create one more snapshot.
INSERT INTO iceberg.demo.orders
    (order_id, customer_id, order_date, amount, channel, status)
VALUES
    (1006, 3, DATE '2026-01-14', DECIMAL '99000.00', 'iot', 'paid');

-- 3. Copy any older snapshot_id from step 1 and paste it into this query.
-- Example:
-- SELECT * FROM iceberg.demo.orders FOR VERSION AS OF 1234567890123456789;

-- 4. Current state should include order_id = 1006.
SELECT * FROM iceberg.demo.orders ORDER BY order_id;

