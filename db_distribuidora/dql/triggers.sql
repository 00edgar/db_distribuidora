-- ============================================================
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