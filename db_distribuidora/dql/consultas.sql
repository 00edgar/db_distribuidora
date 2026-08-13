-- ============================================================
-- 1. Función para calcular total con IVA (19%)
-- ============================================================
CREATE FUNCTION fn_calcular_total_con_iva(id_pedido INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
RETURN (
    SELECT IFNULL(SUM(subtotal), 0) * 1.19 
    FROM detalle_pedido 
    WHERE id_pedido = id_pedido
);
-- ============================================================
-- 2. Función para validar stock
-- ============================================================
CREATE FUNCTION fn_validar_stock(id_producto INT, cantidad INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
RETURN (
    SELECT IF(
        IFNULL(stock_actual, 0) >= cantidad, 
        'Hay stock suficiente', 
        'No hay suficiente stock para este pedido'
    )
    FROM productos 
    WHERE id_producto = id_producto
);