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
until docker compose exec -T trino trino --execute "SELECT 1" >/dev/null 2>&1; do
  printf '.'
  sleep 3
done
printf '\n'

printf '\n==> Preparing PostgreSQL aircraft reference data\n'
docker compose exec -T postgres psql -U trino -d metastore < postgres/init/02_aircraft.sql

run_sql sql/10_create_aviation_schema.sql
run_sql sql/11_insert_flights.sql
run_sql sql/12_aviation_analytics.sql

printf '\n==> Running aviation Iceberg time travel check\n'
base_snapshot_id="$(
  docker compose exec -T trino trino --output-format TSV --execute \
    'SELECT snapshot_id FROM iceberg.aviation."flight_events$snapshots" ORDER BY committed_at DESC LIMIT 1;' \
  | tr -d '[:space:]'
)"

run_sql sql/13_aviation_time_travel.sql
run_query "Rows in historical aviation snapshot ${base_snapshot_id}" \
  "SELECT count(*) AS historical_rows FROM iceberg.aviation.flight_events FOR VERSION AS OF ${base_snapshot_id};"
run_query "Rows in current aviation table" \
  "SELECT count(*) AS current_rows FROM iceberg.aviation.flight_events;"

printf '\n==> Aviation demo is complete.\n'
