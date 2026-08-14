USE db_distribuidora;

-- ============================================================
-- 1. Vista: Resumen de pedidos y ventas por sede
-- ============================================================
CREATE OR REPLACE VIEW vista_resumen_pedidos_por_sede AS
SELECT 
    s.id_sede,
    s.nombre_sede,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(p.total_sin_iva) AS total_ventas_sin_iva,
    SUM(p.total_con_iva) AS total_ventas_con_iva
FROM sedes s
LEFT JOIN pedidos p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede;

-- ============================================================
-- 2. Vista: Productos con stock bajo
-- ============================================================
CREATE OR REPLACE VIEW vista_productos_bajo_stock AS
SELECT 
    id_producto,
    nombre,
    stock_actual,
    stock_minimo,
    (stock_minimo - stock_actual) AS diferencia_faltante
FROM productos
WHERE stock_actual <= stock_minimo;

-- ============================================================
-- 3. Vista: Clientes activos (con al menos un pedido)
-- ============================================================
CREATE OR REPLACE VIEW vista_clientes_activos AS
SELECT DISTINCT
    c.id_cliente,
    c.nombre_completo,
    c.identificacion,
    c.telefono,
    c.correo_electronico
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente;