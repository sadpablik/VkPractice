INSERT INTO iceberg.demo.orders
    (order_id, customer_id, order_date, amount, channel, status)
VALUES
    (1001, 1, DATE '2026-01-10', DECIMAL '125000.00', 'erp', 'paid'),
    (1002, 2, DATE '2026-01-11', DECIMAL '88000.50', 'crm', 'paid'),
    (1003, 3, DATE '2026-01-12', DECIMAL '241500.00', 'mobile', 'new'),
    (1004, 1, DATE '2026-01-12', DECIMAL '45000.75', 'web', 'paid'),
    (1005, 4, DATE '2026-01-13', DECIMAL '30500.00', 'erp', 'cancelled');

