-- Миграция для нормализации базы данных

-- 1. Добавление первичных ключей в таблицы, где их нет
ALTER TABLE product ADD PRIMARY KEY (id);
ALTER TABLE orders ADD PRIMARY KEY (id);

-- 2. Перенос данных из product_info в product
ALTER TABLE product ADD COLUMN price double precision;
UPDATE product p SET price = pi.price
FROM product_info pi
WHERE p.id = pi.product_id;

-- 3. Добавление поля date_created в таблицу orders
ALTER TABLE orders ADD COLUMN date_created date DEFAULT current_date;
UPDATE orders o SET date_created = od.date_created
FROM orders_date od
WHERE o.id = od.order_id;

-- 4. Добавление внешних ключей в таблицу order_product
ALTER TABLE order_product ADD CONSTRAINT fk_order_product_order_id
    FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE order_product ADD CONSTRAINT fk_order_product_product_id
    FOREIGN KEY (product_id) REFERENCES product(id);

-- 5. Удаление неиспользуемых таблиц
DROP TABLE IF EXISTS product_info;
DROP TABLE IF EXISTS orders_date; 