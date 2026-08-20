USE db_distribuidora;
-- 1. Crear una función MySQL llamada total_pedidos_cliente_periodo que:
--   Reciba como parámetros el ID del cliente, la fecha de inicio y la fecha final.
-- Retorne el valor total de los pedidos realizados por ese cliente dentro del rango de fechas.
--  Si el cliente no tiene pedidos en ese período, debe retornar 0.alter
USE db_distribuidora;

DROP FUNCTION IF EXISTS total_pedidos_cliente_periodo;
DELIMITER //
CREATE FUNCTION total_pedidos_cliente_periodo(
    cliente_id INT,
    fecha_inicio DATE,
    fecha_final DATE
)
 RETURNS DECIMAL(10, 2)
 DETERMINISTIC
 BEGIN 
    DECLARE total DECIMAL(10, 2);
    SELECT IFNULL(SUM(total_pedido), 0) INTO total
    FROM pedidos
    WHERE cliente_id = cliente_id
      AND fecha_pedido BETWEEN fecha_inicio AND fecha_final;
    RETURN total;
END //

DELIMITER 


-- Crear una vista llamada vista_clientes_activos que:
-- Muestre los clientes que han realizado al menos un pedido en los últimos 90 días.
-- Incluya el nombre del cliente, número total de pedidos y valor total comprado.
-- Debe usar JOIN entre clientes y pedidos, y aplicar funciones de agregación.
CREATE VIEW vista_clientes_activos AS
SELECT 
    c.nombre_completo AS nombre_cliente,
    COUNT(p.id_pedido) AS numero_total_pedidos,
    SUM(p.valor_total) AS valor_total_comprado
FROM 
    clientes c
JOIN 
    pedidos p ON c.id_cliente = p.id_cliente
WHERE 
    p.fecha_pedido >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
GROUP BY 
    c.id_cliente, c.nombre;
    
SELECT * FROM vista_clientes_activos;

-- 3. Realizar una consulta analítica que:
-- Liste los cinco clientes con mayor valor total en pedidos durante el año actual.
-- Debe mostrar: nombre del cliente, cantidad de pedidos y total comprado.
-- Usa ORDER BY y LIMIT 5 para presentar los resultados en orden descendente.

SELECT 
    c.nombre_completo AS nombre_cliente,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    SUM(p.total) AS total_comprado
FROM 
    clientes c
JOIN 
    pedidos p ON c.id_cliente = p.id_cliente
WHERE 
    EXTRACT(YEAR FROM p.fecha_pedido) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY 
    c.nombre
ORDER BY 
    total_comprado DESC
LIMIT 5;



-- 4. Crear un trigger llamado registrar_nuevo_pedido_trigger que:
-- Se ejecute después de insertar un nuevo pedido.
-- Registre en una tabla auditoria_pedidos los campos:
-- id_pedido, id_cliente, fecha_registro, total_pedido y usuario_responsable (puede ser un valor fijo o por defecto).
-- Debe garantizar que cada pedido nuevo quede auditado correctamente.
DELIMITER //
CREATE TRIGGER registrar_nuevo_pedido_trigger
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_pedidos (id_pedido, id_cliente, fecha_registro, total_pedido),
END;
DELIMITER;
