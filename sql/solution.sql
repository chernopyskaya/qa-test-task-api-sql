-- Категории товаров, у которых:
--   средняя сумма заказа > 25 000 ₽;
--   уникальных покупателей >= 4;
--   учтены только заказы за 2024 год;
--   учтены только покупатели из Москвы и Санкт-Петербурга.
-- СУБД: PostgreSQL 15 и выше.

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
