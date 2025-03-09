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

## Запрос для подсчета количества проданных сосисок за каждый день предыдущей недели

Для получения информации о количестве проданных сосисок за каждый день предыдущей недели был выполнен следующий SQL-запрос:

```sql
SELECT 
    o.date_created,
    SUM(op.quantity)
FROM 
    orders AS o
JOIN 
    order_product AS op ON o.id = op.order_id
WHERE 
    o.status = 'shipped' AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY 
    o.date_created
ORDER BY 
    o.date_created;
```

Этот запрос:
1. Соединяет таблицы `orders` и `order_product` по идентификатору заказа
2. Фильтрует заказы только за предыдущую неделю (7 дней до вчерашнего дня)
3. Группирует результаты по дате заказа
4. Суммирует количество сосисок для каждого дня
5. Сортирует результаты по дате

Результат запроса содержит две колонки:
- `дата_заказа` - дата, когда были сделаны заказы
- `количество_сосисок` - общее количество сосисок, заказанных в этот день
