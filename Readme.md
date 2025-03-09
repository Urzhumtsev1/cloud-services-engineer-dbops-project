# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"

## Создание пользователя PostgreSQL для автотестов и миграций

Для создания пользователя и выдачи ему необходимых прав были выполнены следующие SQL-запросы:

```sql
-- Создание пользователя для автотестов и миграций
CREATE USER autotest WITH PASSWORD 'autotest_password';

-- Выдача прав на подключение к базе данных store
GRANT CONNECT ON DATABASE store TO autotest;

-- Выдача прав на все таблицы в схеме public
GRANT USAGE ON SCHEMA public TO autotest;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO autotest;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO autotest;

-- Установка прав по умолчанию для новых объектов
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO autotest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO autotest;
```

Эти запросы предоставляют пользователю `autotest` все необходимые права для:
- Подключения к базе данных
- Чтения и изменения всех существующих таблиц
- Чтения и изменения всех таблиц, которые будут созданы в будущем
- Выполнения миграций с помощью Flyway
