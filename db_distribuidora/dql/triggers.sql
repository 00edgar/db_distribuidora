- ============================================================
-- Tabla auxiliar para la auditoría de precios
-- (Requerida por el trigger tr_auditar_cambio_precio)
-- ============================================================
CREATE TABLE IF NOT EXISTS auditoria_precios (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio DATETIME NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ============================================================
-- 1. Trigger: Descontar stock al insertar detalle de pedido
-- ============================================================
DROP TRIGGER IF EXISTS tr_actualizar_stock;

CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
UPDATE productos 
SET stock_actual = stock_actual - NEW.cantidad 
WHERE id_producto = NEW.id_producto;

-- ============================================================
-- 2. Trigger: Registrar historial cuando cambia el precio
-- ============================================================
DROP TRIGGER IF EXISTS tr_auditar_cambio_precio;

CREATE TRIGGER tr_auditar_cambio_precio
AFTER UPDATE ON productos
FOR EACH ROW
INSERT INTO auditoria_precios (id_producto, precio_anterior, precio_nuevo, fecha_cambio)
SELECT NEW.id_producto, OLD.precio, NEW.precio, NOW()
WHERE OLD.precio <> NEW.precio;



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