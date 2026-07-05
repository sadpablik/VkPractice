# VK Practice: mini-Lakehouse in Docker

Первый этап домашнего задания: локальный mini-Lakehouse на Docker Compose с Trino, Iceberg, MinIO и PostgreSQL.

## Стек

| Компонент | Назначение | URL / порт |
| --- | --- | --- |
| Trino | SQL-движок, federated queries | http://localhost:8080 |
| MinIO | S3-хранилище для Iceberg warehouse | http://localhost:9000 |
| MinIO Console | UI для бакетов и объектов | http://localhost:9001 |
| PostgreSQL | JDBC-каталог Iceberg + таблица `customers` | localhost:5432 |
| Apache Iceberg | Табличный формат поверх S3 | catalog `iceberg` в Trino |

Доступы для локального стенда:

| Сервис | Логин | Пароль |
| --- | --- | --- |
| MinIO | `minioadmin` | `minioadmin` |
| PostgreSQL | `trino` | `trino` |

## Структура репозитория

```text
.
├── docker-compose.yml
├── trino/catalog/
│   ├── iceberg.properties
│   └── postgresql.properties
├── postgres/init/
│   └── 01_customers.sql
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_insert_orders.sql
│   ├── 03_federated_join.sql
│   └── 04_time_travel.sql
├── healthcheck/
│   └── check_services.sh
├── scripts/
│   └── run_demo.sh
└── docs/
    └── architecture.md
```

## Быстрый запуск

Перед запуском должен быть включён Docker Desktop.

```bash
docker compose up -d
```

Дождаться статуса `healthy`:

```bash
docker compose ps
```

Запустить SQL-демо:

```bash
chmod +x scripts/run_demo.sh healthcheck/check_services.sh
./scripts/run_demo.sh
```

Проверить сервисы:

```bash
./healthcheck/check_services.sh
```

## Ручной запуск SQL

```bash
docker compose exec -T trino trino < sql/01_create_schema.sql
docker compose exec -T trino trino < sql/02_insert_orders.sql
docker compose exec -T trino trino < sql/03_federated_join.sql
docker compose exec -T trino trino < sql/04_time_travel.sql
```

## Что проверяется

1. Health-check каждого сервиса:
   - Trino: `curl http://localhost:8080/v1/info`
   - MinIO: `curl http://localhost:9000/minio/health/live`
   - PostgreSQL: `SELECT 1`
2. Создание Iceberg-схемы и таблицы.
3. Вставка тестовых заказов в Iceberg-таблицу.
4. Federated JOIN: Iceberg `orders` + PostgreSQL `customers`.
5. Time Travel через Iceberg snapshot:
   - посмотреть `iceberg.demo."orders$snapshots"`;
   - взять старый `snapshot_id`;
   - выполнить `SELECT * FROM iceberg.demo.orders FOR VERSION AS OF <snapshot_id>;`.

## Скриншоты для сдачи

После запуска нужно добавить в папку `screenshots/`:

- `minio-buckets.png` — MinIO UI с бакетами `iceberg-warehouse` и `raw`;
- `trino-query.png` — Trino UI или терминал с результатом SQL-запроса;
- `healthcheck.png` — результат запуска `./healthcheck/check_services.sh`.

## Остановка стенда

```bash
docker compose down
```

Полная очистка volumes:

```bash
docker compose down -v
```
