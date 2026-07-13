# VK Practice: mini-Lakehouse in Docker

Локальный mini-Lakehouse на Docker Compose с Trino, Iceberg, MinIO и PostgreSQL.

На текущем этапе приоритет отдан демонстрации основного аналитического контура:

```text
PostgreSQL / тестовые данные -> Iceberg в MinIO -> Trino SQL -> аналитические запросы
```

Потоковый контур с Apache Kafka остаётся частью целевой архитектуры, но не входит в первый локальный MVP. Его реализация запланирована на следующие 6 месяцев развития платформы, после стабилизации хранения, SQL-доступа и базового ETL.

## Стек

| Компонент | Назначение | URL / порт |
| --- | --- | --- |
| Trino | SQL-движок, federated queries | http://localhost:8080 |
| MinIO | S3-хранилище для Iceberg warehouse | http://localhost:9000 |
| MinIO Console | UI для бакетов и объектов | http://localhost:9001 |
| PostgreSQL | JDBC-каталог Iceberg + справочники `customers`, `aircraft` | localhost:5432 |
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
│   ├── 01_customers.sql
│   └── 02_aircraft.sql
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_insert_orders.sql
│   ├── 03_federated_join.sql
│   ├── 04_time_travel.sql
│   ├── 10_create_aviation_schema.sql
│   ├── 11_insert_flights.sql
│   ├── 12_aviation_analytics.sql
│   └── 13_aviation_time_travel.sql
├── healthcheck/
│   └── check_services.sh
├── scripts/
│   ├── run_demo.sh
│   └── run_aviation_demo.sh
└── screenshots/
    ├── demo-time-travel.png
    ├── healthcheck.png
    ├── minio-buckets.png
    └── trino-query.png
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

## Демо для домашнего задания 2: авиалогистика

Второй сценарий приземляет финальный проект команды на локальный стенд. Вместо абстрактных заказов используется учебная область авиалогистики:

- `postgresql.public.aircraft` — справочник бортов: бортовой номер, тип ВС, базовый аэропорт, максимальная полезная нагрузка;
- `iceberg.aviation.flight_events` — события рейсов: дата, аэропорты, груз, расход топлива, задержка, статус.

Запуск:

```bash
chmod +x scripts/run_aviation_demo.sh
./scripts/run_aviation_demo.sh
```

Что демонстрируется:

1. Создание Iceberg-схемы `aviation`.
2. Загрузка тестовых рейсов в `iceberg.aviation.flight_events`.
3. Federated JOIN между Iceberg-таблицей рейсов и PostgreSQL-справочником бортов.
4. Расчет простых метрик авиалогистики:
   - количество рейсов по борту;
   - суммарный перевезенный груз;
   - средняя загрузка борта относительно максимальной полезной нагрузки;
   - средняя задержка.
5. Time Travel по таблице рейсов: исторический snapshot содержит 6 строк, текущая таблица после добавления рейса содержит 7 строк.

Этот сценарий не заменяет production-платформу. Он показывает, как финальная задача команды может быть локально приземлена на текущий Lakehouse MVP без Kafka, ClickHouse, Superset и OpenMetadata.

## Ручной запуск SQL

```bash
docker compose exec -T trino trino < sql/01_create_schema.sql
docker compose exec -T trino trino < sql/02_insert_orders.sql
docker compose exec -T trino trino < sql/03_federated_join.sql
docker compose exec -T trino trino < sql/04_time_travel.sql
```

Для авиационного сценария:

```bash
docker compose exec -T postgres psql -U trino -d metastore < postgres/init/02_aircraft.sql
docker compose exec -T trino trino < sql/10_create_aviation_schema.sql
docker compose exec -T trino trino < sql/11_insert_flights.sql
docker compose exec -T trino trino < sql/12_aviation_analytics.sql
docker compose exec -T trino trino < sql/13_aviation_time_travel.sql
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

Итого в первом инкременте уже реализовано:

- Docker Compose;
- MinIO (S3);
- PostgreSQL;
- Trino;
- Iceberg catalog;
- создание Iceberg-таблиц;
- загрузка тестовых данных;
- SQL-запросы;
- Federated JOIN;
- Time Travel.

## Что не входит в первый MVP

Первый MVP не пытается поднять весь production-стек за один шаг. За рамками текущего этапа остаются:

- полноценный Kafka pipeline;
- ClickHouse-витрины;
- Superset-дашборды;
- OpenMetadata с lineage;
- RBAC, мониторинг и production-конфигурация.

Следующий реалистичный шаг разработки — добавить простой ETL-пайплайн:

```text
CSV / PostgreSQL -> Spark ETL -> Iceberg (S3/MinIO) -> Trino -> Superset
```

Kafka будет добавлена позже как отдельный streaming-контур. На текущем этапе её отсутствие не ломает архитектуру: уже реализованный MVP доказывает базовую идею Lakehouse через хранение, SQL-доступ и аналитику.

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
