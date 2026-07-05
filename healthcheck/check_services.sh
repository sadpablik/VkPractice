#!/usr/bin/env bash
set -euo pipefail

TRINO_URL="${TRINO_URL:-http://localhost:8080}"
MINIO_URL="${MINIO_URL:-http://localhost:9000}"
print_check() {
  printf '\n==> %s\n' "$1"
}

print_check "Trino API"
curl -fsS "$TRINO_URL/v1/info"

print_check "MinIO health"
curl -fsS "$MINIO_URL/minio/health/live"

print_check "PostgreSQL"
docker compose exec -T postgres psql -U trino -d metastore -c "SELECT 1 AS postgres_ok;"

print_check "Trino catalogs"
docker compose exec -T trino trino --execute "SHOW CATALOGS;"

print_check "Iceberg tables"
docker compose exec -T trino trino --execute "SHOW TABLES FROM iceberg.demo;"

print_check "Row count"
docker compose exec -T trino trino --execute "SELECT count(*) AS orders_count FROM iceberg.demo.orders;"
