# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"

## Создание пользователя PostgreSQL для автотестов и миграций

**ОБРАЩАЮ ВНИМАНИЕ** в связи с тем что мне не были предоставлены ресурсы в облаке для БД, все задание выполнил через github actions, включая установку самой БД (см. `.github/workflows/main.yml` в step `Setup PostgreSQL 16`). Кроме того добавлен step (`Run SQL Query`) по запуску запроса для получения информации о кол-ве проданных сосисок и установлено ограничение на кол-во строк (100 шт. вместо 10 млн. для ускорения прохождения пайплайна). Этого нет в требованиях, но условиях непредоставления облачных ресурсов вижу это оптимальным вариантом для сдачи работы.

Для создания БД и пользователя и выдачи ему необходимых прав были выполнены следующие SQL-запросы:

```sql
-- Создание пользователя для автотестов и миграций и БД
CREATE USER autotest WITH PASSWORD 'autotest_password';
CREATE DATABASE store;
-- Выдача прав
GRANT ALL PRIVILEGES ON DATABASE store TO autotest;
GRANT ALL PRIVILEGES ON SCHEMA public TO autotest;
-- Установка прав по умолчанию для новых объектов
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO autotest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO autotest;
```

Эти запросы предоставляют пользователю `autotest` все необходимые права

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
