

/* =========================================================
   1) BASIC SELECT
   ========================================================= */

-- عرض جميع المنتجات
SELECT * FROM product_table;

-- عرض اسم المنتج والسعر فقط
SELECT product_name, base_price
FROM product_table;

-- عرض المنتجات المفعّلة فقط
SELECT product_name, base_price
FROM product_table
WHERE is_active = 1;

-- ترتيب المنتجات من الأغلى إلى الأرخص
SELECT product_name, base_price
FROM product_table
ORDER BY base_price DESC;

-- عرض أعلى 5 منتجات سعرًا
SELECT product_name, base_price
FROM product_table
ORDER BY base_price DESC
LIMIT 5;


/* =========================================================
   2) JOIN OPERATIONS
   ========================================================= */

-- عرض المنتج مع الفئة التي ينتمي إليها
SELECT p.product_name, c.category_name
FROM product_table p
JOIN product_category_table pc 
    ON p.product_id = pc.product_id
JOIN category_table c 
    ON pc.category_id = c.category_id;

-- عرض كل Variant مع خصائصه (لون، حجم، ...)
SELECT v.variant_id, p.product_name,
       a.attribute_name, o.option_name
FROM product_variant_table v
JOIN product_table p 
    ON v.product_id = p.product_id
JOIN variant_attributes_table va 
    ON v.variant_id = va.variant_id
JOIN attributes_table a 
    ON va.attribute_id = a.attribute_id
JOIN attributes_options_table o 
    ON va.option_id = o.option_id;

-- LEFT JOIN: عرض كل المنتجات حتى التي لم تبع
SELECT p.product_name, oi.order_item_id
FROM product_table p
LEFT JOIN order_items_table oi
    ON p.product_id = oi.product_id;


/* =========================================================
   3) AGGREGATE FUNCTIONS
   ========================================================= */

-- عدد المستخدمين
SELECT COUNT(*) AS total_users
FROM user_table;

-- مجموع المبيعات الكلي
SELECT SUM(total_amount) AS total_sales
FROM order_table;

-- متوسط سعر المنتجات
SELECT AVG(base_price) AS avg_price
FROM product_table;

-- أعلى سعر Variant
SELECT MAX(price) AS max_variant_price
FROM product_variant_table;


/* =========================================================
   4) GROUP BY + HAVING
   ========================================================= */

-- مجموع ما أنفقه كل مستخدم
SELECT u.full_name,
       SUM(o.total_amount) AS total_spent
FROM user_table u
JOIN order_table o
    ON u.user_id = o.user_id
GROUP BY u.user_id;

-- عدد الطلبات لكل مستخدم
SELECT user_id,
       COUNT(order_id) AS total_orders
FROM order_table
GROUP BY user_id;

-- المستخدمون الذين أنفقوا أكثر من 1000
SELECT u.full_name,
       SUM(o.total_amount) AS total_spent
FROM user_table u
JOIN order_table o
    ON u.user_id = o.user_id
GROUP BY u.user_id
HAVING total_spent > 1000;


/* =========================================================
   5) SUBQUERIES
   ========================================================= */

-- جلب أغلى منتج
SELECT product_name
FROM product_table
WHERE base_price = (
    SELECT MAX(base_price)
    FROM product_table
);

-- المستخدم صاحب أكبر طلب
SELECT full_name
FROM user_table
WHERE user_id = (
    SELECT user_id
    FROM order_table
    ORDER BY total_amount DESC
    LIMIT 1
);


/* =========================================================
   6) EXISTS / IN
   ========================================================= */

-- المنتجات التي تم بيعها
SELECT product_name
FROM product_table p
WHERE EXISTS (
    SELECT 1
    FROM order_items_table oi
    WHERE oi.product_id = p.product_id
);

-- المستخدمون الذين لديهم طلبات
SELECT full_name
FROM user_table
WHERE user_id IN (
    SELECT DISTINCT user_id
    FROM order_table
);


/* =========================================================
   7) UPDATE
   ========================================================= */

-- إنقاص المخزون بعد عملية شراء
UPDATE product_variant_table
SET stock_quantity = stock_quantity - 1
WHERE variant_id = 1;


/* =========================================================
   8) DELETE
   ========================================================= */

-- حذف مستخدم
DELETE FROM user_table
WHERE user_id = 9;


/* =========================================================
   9) CASE STATEMENT
   ========================================================= */

-- تصنيف الطلبات حسب القيمة
SELECT order_id,
       CASE
           WHEN total_amount > 1000 THEN 'High Value'
           WHEN total_amount BETWEEN 100 AND 1000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS order_category
FROM order_table;


/* =========================================================
   10) TRANSACTIONS
   ========================================================= */

-- مثال عملية شراء كاملة
START TRANSACTION;

UPDATE product_variant_table
SET stock_quantity = stock_quantity - 1
WHERE variant_id = 2;

INSERT INTO order_table (user_id, total_amount, status)
VALUES (1, 900, 'paid');

COMMIT;

-- في حال حدوث خطأ
-- ROLLBACK;


/* =========================================================
   11) VIEW
   ========================================================= */

-- إنشاء View لتلخيص المبيعات لكل مستخدم
CREATE VIEW sales_summary AS
SELECT u.full_name,
       SUM(o.total_amount) AS total_sales
FROM user_table u
JOIN order_table o
    ON u.user_id = o.user_id
GROUP BY u.user_id;

-- استعمال الـ View
SELECT * FROM sales_summary;


/* =========================================================
   12) INDEX
   ========================================================= */

-- تحسين البحث باسم المنتج
CREATE INDEX idx_product_name
ON product_table(product_name);


/* =========================================================
   13) ADVANCED ANALYTICS
   ========================================================= */

-- أكثر Variant مبيعًا
SELECT v.sku,
       SUM(oi.quantity) AS total_sold
FROM order_items_table oi
JOIN product_variant_table v
    ON oi.variant_id = v.variant_id
GROUP BY v.variant_id
ORDER BY total_sold DESC
LIMIT 1;

-- أقل المخزون
SELECT sku, stock_quantity
FROM product_variant_table
ORDER BY stock_quantity ASC
LIMIT 5;

-- إجمالي المبيعات لكل فئة
SELECT c.category_name,
       SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items_table oi
JOIN product_table p
    ON oi.product_id = p.product_id
JOIN product_category_table pc
    ON p.product_id = pc.product_id
JOIN category_table c
    ON pc.category_id = c.category_id
GROUP BY c.category_id;

