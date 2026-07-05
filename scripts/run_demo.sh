#!/usr/bin/env bash
set -euo pipefail

run_sql() {
  local file="$1"
  printf '\n==> Running %s\n' "$file"
  docker compose exec -T trino trino < "$file"
}

run_query() {
  local title="$1"
  local query="$2"
  printf '\n==> %s\n' "$title"
  docker compose exec -T trino trino --execute "$query"
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

printf '\n==> Running Iceberg time travel check\n'
base_snapshot_id="$(
  docker compose exec -T trino trino --output-format TSV --execute \
    'SELECT snapshot_id FROM iceberg.demo."orders$snapshots" ORDER BY committed_at DESC LIMIT 1;' \
  | tr -d '[:space:]'
)"

run_sql sql/04_time_travel.sql
run_query "Rows in historical snapshot ${base_snapshot_id}" \
  "SELECT count(*) AS historical_rows FROM iceberg.demo.orders FOR VERSION AS OF ${base_snapshot_id};"
run_query "Rows in current table" \
  "SELECT count(*) AS current_rows FROM iceberg.demo.orders;"

printf '\n==> Demo is complete. Open Trino UI: http://localhost:8080\n'
printf '==> Open MinIO UI: http://localhost:9001 (minioadmin / minioadmin)\n'
