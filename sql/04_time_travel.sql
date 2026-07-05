-- 1. Check the snapshot history after the initial load.
SELECT
    snapshot_id,
    committed_at,
    operation
FROM iceberg.demo."orders$snapshots"
ORDER BY committed_at;

-- 2. Create one more snapshot. scripts/run_demo.sh saves the previous
-- snapshot id and runs a real FOR VERSION AS OF query after this insert.
INSERT INTO iceberg.demo.orders
    (order_id, customer_id, order_date, amount, channel, status)
VALUES
    (1006, 3, DATE '2026-01-14', DECIMAL '99000.00', 'iot', 'paid');

-- 3. Manual time travel example:
-- Example:
-- SELECT * FROM iceberg.demo.orders FOR VERSION AS OF 1234567890123456789;

-- 4. Current state should include order_id = 1006.
SELECT * FROM iceberg.demo.orders ORDER BY order_id;
