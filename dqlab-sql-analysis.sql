-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS dqlab;

-- Selección de base de datos a trabajar
USE dqlab;

-- Cargamos el dataset en la base de datos

-- Mostramos el dataset
SELECT * FROM dqlabdata;

-- Observación de discrepancias
-- Corregimos el error en la columna discount: algunos descuentos del 1% han sido tratados como 0.1 en vez de 0.01 en la carga de los datos.
SET SQL_SAFE_UPDATES = 0;
UPDATE dqlabdata
SET discount = 0.01
WHERE discount = 0.1;
SET SQL_SAFE_UPDATES = 1;

-- ANÁLISIS DE ÓRDENES
-- Cantidad de pedidos, completados, devueltos, cancelados
SELECT
    COUNT(order_id) AS "# of orders",
    SUM(CASE WHEN order_status = "Order Finished" THEN 1 ELSE 0 END) AS "# of orders finished",
    SUM(CASE WHEN order_status = "Order Returned" THEN 1 ELSE 0 END) AS "# of orders returned",
    SUM(CASE WHEN order_status = "Order Cancelled" THEN 1 ELSE 0 END) AS "# of orders cancelled"
FROM dqlabdata;
-- Para filtrar por año, descomenta la siguiente linea:
-- WHERE YEAR(order_date) = "2010";

-- Tasa de devoluciones (pedidos devueltos respecto el total de pedidos)
SELECT
    ROUND((SUM(CASE WHEN order_status = "Order Returned" THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id)),2) AS "Return rate (%)"
FROM dqlabdata;
-- WHERE YEAR(order_date) = "2010";

-- Total de pedidos completados (sin contar los finalizados que han sido cancelados), pedidos finalizados y pedidos con y sin descuento
-- Creamos una vista para recoger solamente los order_id no duplicados valid_orders_view, ya que la utilizaremos en la mayoría de consultas
CREATE VIEW valid_orders_view AS
SELECT order_id
FROM dqlabdata
GROUP BY order_id
HAVING COUNT(DISTINCT order_status) = 1;

SELECT
    COUNT(order_id) AS "# of orders",
    SUM(CASE WHEN order_status = "Order Finished" THEN 1 ELSE 0 END) AS "# of orders completed",
    SUM(CASE WHEN order_status = "Order Finished" AND discount <> 0 THEN 1 ELSE 0 END) AS "# of orders with discount",
    SUM(CASE WHEN order_status = "Order Finished" AND discount = 0 THEN 1 ELSE 0 END) AS "# of orders without discount"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view);
-- AND YEAR(order_date) = "2010";

-- Cantidad de productos pedidos y media de productos por pedido en pedidos completados
SELECT 
	SUM(order_quantity) AS "# of products ordered", 
    ROUND(AVG(order_quantity),0) AS "Avg products per order"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished";
-- AND YEAR(order_date) = "2010";

-- Ticket medio sobre pedidos finalizados
SELECT 
	ROUND(((SUM(sales) / COUNT(order_id)) / 1000000),2) AS "Avg ticket (in millions)"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished";
-- AND YEAR(order_date) = "2010";

-- ANÁLISIS DE VENTAS Y PRODUCTO
-- Ventas brutas, Ventas netas, Descuentos aplicados (sobre pedidos completados)
SELECT 
	ROUND(SUM(sales + discount_value)/1000000,2) AS "Gross sales (in millions)",
	ROUND(SUM(sales)/1000000,2) AS "Net sales (in millions)",
    ROUND(SUM(discount_value)/1000000,2) AS "Total discounts (in millions)"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished";
-- AND YEAR(order_date) = "2010";

-- Descuento medio aplicado en pedidos completados
SELECT 
	FORMAT(AVG(discount) * 100,2) AS "Avg discount applied"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished";
-- AND YEAR(order_date) = "2010";

-- Ventas netas por mes (pedidos completados)
SELECT 
    MONTHNAME(order_date) AS "Month",
    ROUND(SUM(sales)/1000000, 0) AS "Net sales (in millions)"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date) ASC;

-- ANÁLISIS DE CATEGORÍAS Y SUBCATEGORÍAS DE PRODUCTO
-- Ventas por categoría de producto ordenado por ventas netas (pedidos completados)
SELECT
    product_category AS "Product category",
    SUM(order_quantity) AS "Items sold",
    ROUND(SUM(sales)/1000000, 0) AS "Net sales (in millions)"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
-- AND YEAR(order_date) = "2010"
GROUP BY 1
ORDER BY 3 DESC;

-- Ventas por subcategoría de producto ordenado por ventas netas (pedidos completados)
SELECT
    product_sub_category AS "Product sub-category",
    SUM(order_quantity) AS "Items sold",
    ROUND(SUM(sales)/1000000, 0) AS "Net sales (in millions)"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
-- AND YEAR(order_date) = "2010"
GROUP BY 1
ORDER BY 3 DESC;

-- TOP5 subcategorías de producto más vendidas (pedidos completados)
SELECT
    product_sub_category AS "Product sub-category",
    SUM(order_quantity) AS "Items sold"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
-- AND YEAR(order_date) = "2010"
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;

-- ANÁLISIS DE CLIENTES
-- Clientes ordenados por gasto (pedidos completados)
SELECT
    customer AS "Customer",
    ROUND(SUM(sales)/1000000,2) AS "Spent (in millions)"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished" 
-- AND YEAR(order_date) = "2010"
-- AND product_category = "Technology"
GROUP BY 1
ORDER BY 2 DESC;

-- Datos de cliente en específico: Búsqueda por cualquier cliente
-- Datos de cliente en específico (INSERTAR NOMBRE DE CLIENTE)
SET @customer_name = 'Grant Carroll';

SELECT 
    'Customer' AS "Metric", 
    customer AS "Value"
FROM dqlabdata
WHERE customer = @customer_name
GROUP BY customer

UNION ALL

-- Ventas brutas en millones
SELECT 
    'Gross sales (in millions)' AS "Metric", 
    ROUND(SUM(sales + discount_value)/1000000,2) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Ventas netas en millones
SELECT 
    'Net sales (in millions)' AS "Metric", 
    ROUND(SUM(sales)/1000000,2) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Descuento total aplicado en millones
SELECT 
    'Total discounts (in millions)' AS "Metric", 
    ROUND(SUM(discount_value)/1000000,2) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Número de pedidos
SELECT 
    '# of orders' AS "Metric", 
    COUNT(order_id) AS "Value"
FROM dqlabdata
WHERE customer = @customer_name

UNION ALL

-- Número de pedidos finalizados
SELECT 
    '# of orders finished' AS "Metric", 
    SUM(CASE WHEN order_status = 'Order Finished' THEN 1 ELSE 0 END) AS "Value"
FROM dqlabdata
WHERE customer = @customer_name

UNION ALL

-- Número de pedidos devueltos
SELECT 
    '# of orders returned' AS "Metric", 
    SUM(CASE WHEN order_status = 'Order Returned' THEN 1 ELSE 0 END) AS "Value"
FROM dqlabdata
WHERE customer = @customer_name

UNION ALL

-- Número de pedidos cancelados
SELECT 
    '# of orders cancelled' AS "Metric", 
    SUM(CASE WHEN order_status = 'Order Cancelled' THEN 1 ELSE 0 END) AS "Value"
FROM dqlabdata
WHERE customer = @customer_name

UNION ALL

-- Tasa de devolución
SELECT 
    'Return rate (%)' AS "Metric", 
    ROUND((SUM(CASE WHEN order_status = 'Order Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id)), 2) AS "Value"
FROM dqlabdata
WHERE customer = @customer_name

UNION ALL

-- Número de pedidos completados
SELECT 
    '# of orders completed' AS "Metric", 
    SUM(CASE WHEN order_status = 'Order Finished' THEN 1 ELSE 0 END) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Número de productos pedidos
SELECT 
    '# of products ordered' AS "Metric", 
    SUM(order_quantity) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Número de pedidos con descuento
SELECT 
    '# of orders with discount' AS "Metric", 
    SUM(CASE WHEN discount <> 0 THEN 1 ELSE 0 END) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Número de pedidos sin descuento
SELECT 
    '# of orders without discount' AS "Metric", 
    SUM(CASE WHEN discount = 0 THEN 1 ELSE 0 END) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Promedio de descuentos aplicados en %
SELECT 
    'Avg discount applied (%)' AS "Metric", 
    FORMAT(AVG(discount) * 100, 2) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Promedio de productos por pedido
SELECT 
    'Avg products per order' AS "Metric", 
    ROUND(AVG(order_quantity), 0) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Ticket medio
SELECT 
    'Avg ticket (in millions)' AS "Metric", 
    ROUND((SUM(sales) / COUNT(order_id)) / 1000000, 2) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name

UNION ALL

-- Subcategoría de producto más comprada
SELECT 
    'Most purchased sub-category' AS "Metric", 
    product_sub_category AS "Value"
FROM (
	SELECT
		product_sub_category,
        SUM(sales) AS total_sales
	FROM dqlabdata
	WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
	AND customer = @customer_name
	GROUP BY product_sub_category
	ORDER BY total_sales DESC
	LIMIT 1
) AS most_purchased_sub_category

UNION ALL

-- Duración de la relación del cliente en días
SELECT 
	'Customer lifespan (in days)' AS "Metric",
    DATEDIFF(last_purchase_date, first_purchase_date) AS "Value"
FROM (
    SELECT 
        MIN(order_date) AS first_purchase_date,
        MAX(order_date) AS last_purchase_date
    FROM dqlabdata
    WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
	AND customer = @customer_name
) AS purchase_dates

UNION ALL

-- Proyección del CLV para 2013 (solo órdenes finalizadas)
SELECT 
    'Projected CLV for 2013 (in millions)' AS "Metric",
    ROUND(
        (
            (SUM(sales) / COUNT(order_id)) -- Ticket medio
            * (COUNT(order_id) / DATEDIFF(MAX(order_date), MIN(order_date))) -- Promedio de pedidos por día
            * 365 -- Proyección a un año
        ) / 1000000, 2) AS "Value"
FROM dqlabdata
WHERE order_id IN (SELECT order_id FROM valid_orders_view) AND order_status = "Order Finished"
AND customer = @customer_name




