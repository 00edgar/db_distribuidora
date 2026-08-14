# DEDSARROLLO DEL PROYECTO DE MYSQL II
### Desarrollador: Edgar Manolo Polanco Sanchez
Este proyecto permite llevar a la practica los diferentes conocimientos adquiridos durante el skill de MySQL_II


Este documento contiene la explicación paso a paso de cómo se llevó a cabo el desarrollo de la base de datos `db_distribuidora`, incluyendo sus funciones, triggers, consultas avanzadas y vistas.

---

## 📄 Explicación del Proyecto

El proyecto consiste en la creación, parametrización y manipulación de una base de datos relacional para la gestión de ventas, inventario, clientes y sedes de una empresa distribuidora.

### 1. Funciones Almacenadas (`CREATE FUNCTION`)
Se crearon funciones deterministas de lectura SQL para automatizar cálculos puntuales sin usar delimitadores complejos:
* **`fn_calcular_total_con_iva(id_pedido)`**: Realiza la sumatoria de todos los subtotales asociados a un pedido específico desde la tabla `detalle_pedido` y aplica la tarifa de IVA del 19%.
* **`fn_validar_stock(id_producto, cantidad)`**: Verifica en tiempo real si el `stock_actual` de un producto registrado es suficiente para suplir la cantidad solicitada en una orden, retornando un mensaje interactivo.

### 2. Disparadores (`CREATE TRIGGER`)
Se definieron dos triggers automáticos para garantizar la integridad de los datos y el rastreo de cambios:
* **`tr_actualizar_stock`**: Disparador de tipo `AFTER INSERT` sobre la tabla `detalle_pedido` que descuenta automáticamente la cantidad vendida del `stock_actual` en la tabla `productos`.
* **`tr_auditar_cambio_precio`**: Disparador de tipo `AFTER UPDATE` sobre la tabla `productos` que detecta variaciones en la columna `precio` e inserta automáticamente un registro histórico en la tabla `auditoria_precios` con la fecha y hora exactas (`NOW()`).

### 3. Consultas SQL Requeridas
Se redactaron consultas optimizadas para cubrir métricas clave de negocio:
1. Filtro de productos bajo el stock mínimo.
2. Rango de fechas de pedidos (`BETWEEN`).
3. Agrupación y totalización de productos más vendidos (`JOIN` + `GROUP BY`).
4. Conteo de pedidos por cliente (`LEFT JOIN`).
5. Búsqueda por coincidencia parcial de texto (`LIKE`).
6. Filtrado por lista explícita de categorías (`IN`).
7. Subconsulta para determinar el cliente con mayor volumen de pedidos.
8. Acumulado de ventas e ingresos agrupados por sede.

### 4. Vistas SQL (`CREATE VIEW`)
Se crearon tres vistas reutilizables para simplificar la extracción de informes:
* **`vista_resumen_pedidos_por_sede`**: Consolida la cantidad de pedidos e ingresos por sede.
* **`vista_productos_bajo_stock`**: Muestra los productos en condición de reabastecimiento crítico y calcula las unidades faltantes.
* **`vista_clientes_activos`**: Muestra únicamente los clientes que han realizado al menos un pedido (`INNER JOIN`).