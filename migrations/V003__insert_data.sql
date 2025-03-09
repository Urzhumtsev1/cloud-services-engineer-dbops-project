-- Миграция для вставки данных в нормализованную базу данных

-- Вставка данных в таблицу product (теперь включает цену)
INSERT INTO product (id, name, picture_url, price) VALUES 
    (1, 'Сливочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/6.jpg', 320.00),
    (2, 'Особая', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/5.jpg', 179.00),
    (3, 'Молочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/4.jpg', 225.00),
    (4, 'Нюренбергская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/3.jpg', 315.00),
    (5, 'Мюнхенская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/2.jpg', 330.00),
    (6, 'Русская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/1.jpg', 189.00);

-- Сбросим последовательность для id, чтобы следующая вставка начиналась с 7
SELECT setval(pg_get_serial_sequence('product', 'id'), 6);

-- Вставка данных в таблицу orders (теперь включает date_created)
-- Создадим 100 заказов вместо 10000000 для демонстрационных целей
INSERT INTO orders (id, status, date_created)
SELECT 
    i, 
    (array['pending', 'shipped', 'cancelled'])[floor(random() * 3 + 1)],
    DATE(NOW() - (random() * (NOW()+'90 days' - NOW())))
FROM generate_series(1, 100) s(i);

-- Сбросим последовательность для id, чтобы следующая вставка начиналась с 101
SELECT setval(pg_get_serial_sequence('orders', 'id'), 100);

-- Вставка данных в таблицу order_product
-- Создадим записи для 100 заказов вместо 10000000 для демонстрационных целей
INSERT INTO order_product (quantity, order_id, product_id)
SELECT 
    floor(1+random()*50)::int,
    i,
    1 + floor(random()*6)::int % 6
FROM generate_series(1, 100) s(i);

-- Добавим еще несколько записей, чтобы некоторые заказы содержали несколько продуктов
INSERT INTO order_product (quantity, order_id, product_id)
SELECT 
    floor(1+random()*20)::int,
    floor(random()*100)::int + 1,
    floor(random()*6)::int + 1
FROM generate_series(1, 50) s(i)
WHERE random() > 0.5; 