USE db_distribuidora;

-- ============================================================
-- 1. Productos con stock por debajo del mínimo
-- ============================================================
SELECT 
    id_producto, 
    nombre, 
    stock_actual, 
    stock_minimo
FROM productos
WHERE stock_actual < stock_minimo;

-- ============================================================
-- 2. Pedidos realizados entre dos fechas (BETWEEN)
-- ============================================================
SELECT 
    id_pedido, 
    fecha_pedido, 
    id_cliente, 
    id_sede, 
    total_con_iva
FROM pedidos
WHERE fecha_pedido BETWEEN '2026-01-01 00:00:00' AND '2026-01-05 23:59:59';

-- ============================================================
-- 3. Productos más vendidos (JOIN y GROUP BY)
-- ============================================================
SELECT 
    p.id_producto,
    p.nombre,
    SUM(dp.cantidad) AS total_unidades_vendidas
FROM productos p
JOIN detalle_pedido dp ON p.id_producto = dp.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY total_unidades_vendidas DESC;

-- ============================================================
-- 4. Clientes y la cantidad de pedidos realizados
-- ============================================================
SELECT 
    c.id_cliente,
    c.nombre_completo,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo;

-- ============================================================
-- 5. Buscar clientes por nombre parcial usando LIKE
-- ============================================================
SELECT 
    id_cliente,
    nombre_completo,
    identificacion,
    telefono
FROM clientes
WHERE nombre_completo LIKE '%Tienda%';

-- ============================================================
-- 6. Productos de ciertas categorías usando IN
-- ============================================================
SELECT 
    p.id_producto,
    p.nombre,
    c.nombre_categoria,
    p.precio
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE p.id_categoria IN (1, 3, 5);

-- ============================================================
-- 7. Cliente con mayor número de pedidos (Subconsulta)
-- ============================================================
SELECT 
    id_cliente,
    nombre_completo,
    identificacion
FROM clientes
WHERE id_cliente = (
    SELECT id_cliente
    FROM pedidos
    GROUP BY id_cliente
    ORDER BY COUNT(id_pedido) DESC
    LIMIT 1
);

-- ============================================================
-- 8. Pedidos y sus totales agrupados por sede
-- ============================================================
SELECT 
    s.id_sede,
    s.nombre_sede,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(p.total_sin_iva) AS gran_total_sin_iva,
    SUM(p.total_con_iva) AS gran_total_con_iva
FROM sedes s
JOIN pedidos p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede;