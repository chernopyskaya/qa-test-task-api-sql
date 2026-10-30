# 🗄️ Задание 2. SQL

## 🎯 Задача

Написать SQL-запрос (PostgreSQL 15 и выше), который выводит данные о категориях товаров, у которых:

- 💰 средняя сумма заказа превышает 25 000 рублей;
- 👥 количество уникальных покупателей не меньше 4;
- 📅 учитываются только заказы за 2024 год;
- 🏙️ учитываются только покупатели из Москвы и Санкт-Петербурга.

В результате нужны: название категории, средняя сумма заказа, количество уникальных покупателей.

## 🧱 Структура базы

| Таблица | Назначение | Ключевые поля |
|---|---|---|
| 📦 `products` | товары | `product_id`, `category`, `price` |
| 👤 `customers` | покупатели | `customer_id`, `name`, `city` |
| 🧾 `orders` | заказы | `order_id`, `customer_id`, `order_date` |
| 🛒 `order_items` | позиции заказов | `order_item_id`, `order_id`, `product_id`, `quantity`, `total_price` |

## 💾 Решение

Файл: [../sql/solution.sql](../sql/solution.sql)

```sql
SELECT
    p.category                        AS category,
    ROUND(AVG(oi.total_price), 2)     AS avg_order_amount,
    COUNT(DISTINCT c.customer_id)     AS unique_customers
FROM order_items AS oi
JOIN orders    AS o ON o.order_id    = oi.order_id
JOIN customers AS c ON c.customer_id = o.customer_id
JOIN products  AS p ON p.product_id  = oi.product_id
WHERE o.order_date >= DATE '2024-01-01'
  AND o.order_date <  DATE '2025-01-01'
  AND c.city IN ('Москва', 'Санкт-Петербург')
GROUP BY p.category
HAVING AVG(oi.total_price) > 25000
   AND COUNT(DISTINCT c.customer_id) >= 4
ORDER BY avg_order_amount DESC;
```

## 🔍 Как это работает

1. 🔗 `JOIN` объединяет четыре таблицы по первичным и внешним ключам.
2. 🧹 `WHERE` оставляет заказы за 2024 год и покупателей из Москвы и Санкт-Петербурга. Верхняя граница даты строгая (`< 2025-01-01`), чтобы учесть весь декабрь.
3. 🗂️ `GROUP BY` собирает данные по категориям товаров.
4. 🧮 `AVG` считает среднюю сумму, `COUNT(DISTINCT ...)` считает каждого покупателя один раз, даже если у него несколько заказов.
5. 🎯 `HAVING` оставляет категории, подходящие по условиям на среднее и число покупателей. Эти условия относятся к группам, поэтому их нельзя писать в `WHERE`.

## 📊 Результат на тестовых данных

| category | avg_order_amount | unique_customers |
|---|---|---|
| 📱 Смартфоны | 89987.50 | 4 |

✅ Результат совпал с основным решением: в заказах с несколькими позициями товары относятся к разным категориям, поэтому сумма позиции и сумма заказа внутри категории равны.
