#!/usr/bin/env bash
set -euo pipefail

run_sql() {
  local file="$1"
  printf '\n==> Running %s\n' "$file"
  docker compose exec -T trino trino < "$file"
}

docker compose up -d

printf '\n==> Waiting for Trino to become healthy'
until curl -fsS http://localhost:8080/v1/info >/dev/null 2>&1; do
  printf '.'
  sleep 3
done
printf '\n'

run_sql sql/01_create_schema.sql
run_sql sql/02_insert_orders.sql
run_sql sql/03_federated_join.sql
run_sql sql/04_time_travel.sql

printf '\n==> Demo is complete. Open Trino UI: http://localhost:8080\n'
printf '==> Open MinIO UI: http://localhost:9001 (minioadmin / minioadmin)\n'

