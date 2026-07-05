SELECT
    c.region,
    c.segment,
    count(*) AS orders_count,
    sum(o.amount) AS total_amount
FROM iceberg.demo.orders o
JOIN postgresql.public.customers c
    ON o.customer_id = c.customer_id
WHERE o.status <> 'cancelled'
GROUP BY c.region, c.segment
ORDER BY total_amount DESC;

