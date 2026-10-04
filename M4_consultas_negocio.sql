-- ============================================================
-- Consulta 1: Resumen ejecutivo mensual
-- ============================================================
SELECT
    MONTH(fecha_venta)                     AS mes,
    SUM(cantidad * precio_unitario)        AS total_facturado,
    COUNT(*)                               AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)        AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- ============================================================
-- Consulta 2: Ranking de productos (Top 5 por facturación)
-- ============================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad)                          AS unidades_vendidas,
    SUM(cantidad * precio_unitario)        AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- ============================================================
-- Consulta 3: Clientes recurrentes (más de 1 pedido)
-- ============================================================
SELECT
    id_cliente,
    COUNT(*)                               AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)        AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- ============================================================
-- Consulta 4: Meses por encima/por debajo del promedio
-- ============================================================
WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta)                 AS mes,
        SUM(cantidad * precio_unitario)    AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual) THEN 'Por encima'
        ELSE 'Por debajo'
    END                                     AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;

-- ============================================================
-- Hallazgos
-- ============================================================
-- 1. Todas las ventas cargadas en M3 corresponden a un único mes (marzo 2024),
--    por lo que el resumen mensual y la comparación por encima/debajo del
--    promedio no muestran variación entre meses: solo hay un mes para comparar.
-- 2. El producto 1 concentra $3.600 de facturación, el 56% del total general
--    ($6.444), muy por encima del resto del ranking.
-- 3. Los 5 clientes cargados son recurrentes: cada uno hizo exactamente
--    2 pedidos, es decir que el 100% de la cartera actual repite compra.