-- ============================================================
-- BASE DE DATOS: db_distribuidora
-- ============================================================
CREATE DATABASE IF NOT EXISTS db_distribuidora;
USE db_distribuidora;

-- ============================================================
-- TABLA 1: productos
-- ============================================================
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    volumen_ml INT NOT NULL CHECK (volumen_ml > 0),
    stock_actual INT NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo INT NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 2: clientes
-- ============================================================
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ============================================================
-- TABLA 3: sedes
-- ============================================================
CREATE TABLE IF NOT EXISTS sedes (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sede VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200) NOT NULL,
    capacidad_almacenamiento INT NOT NULL CHECK (capacidad_almacenamiento > 0),
    encargado VARCHAR(150) NOT NULL
) ENGINE=InnoDB;



-- ============================================================
-- TABLA 4: pedidos
-- ============================================================
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT NOT NULL,
    id_sede INT NOT NULL,
    total_sin_iva DECIMAL(12,2) NOT NULL DEFAULT 0.00 CHECK (total_sin_iva >= 0),
    total_con_iva DECIMAL(12,2) NOT NULL DEFAULT 0.00 CHECK (total_con_iva >= 0),
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedidos_sede FOREIGN KEY (id_sede) REFERENCES sedes(id_sede) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ============================================================
-- TABLA 5: detalle_pedido
-- ============================================================
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    PRIMARY KEY (id_pedido, id_producto),
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ============================================================
-- TABLA 6: auditoria_precios
-- ============================================================
CREATE TABLE IF NOT EXISTS auditoria_precios (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ============================================================
-- TABLA: encargados
-- ============================================================
CREATE TABLE IF NOT EXISTS encargados (
    id_encargado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: inventario (según imagen provista)
-- ============================================================
CREATE TABLE IF NOT EXISTS inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_sucursal INT NOT NULL,
    inventario_actual INT NOT NULL DEFAULT 0 CHECK (inventario_actual >= 0),
    nivel_inventario_minimo INT NOT NULL DEFAULT 0 CHECK (nivel_inventario_minimo >= 0),
    CONSTRAINT fk_inventario_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_inventario_sucursal FOREIGN KEY (id_sucursal) REFERENCES sedes(id_sede) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: encargados
-- ============================================================
CREATE TABLE IF NOT EXISTS encargados (
    id_encargado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;


-- ejecutar esta parte antes inseertar los datos


-- 1. Agregar la columna clave foránea
ALTER TABLE productos 
ADD COLUMN id_categoria INT NULL AFTER id_producto;

-- 2. Migrar la relación existente desde la columna antigua
UPDATE productos p
JOIN categorias c ON p.categoria = c.nombre_categoria
SET p.id_categoria = c.id_categoria;

-- 3. Definir la columna como NOT NULL, crear la FK y eliminar la columna antigua
ALTER TABLE productos 
MODIFY COLUMN id_categoria INT NOT NULL,
ADD CONSTRAINT fk_productos_categoria 
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) 
    ON DELETE RESTRICT ON UPDATE CASCADE,
DROP COLUMN categoria;