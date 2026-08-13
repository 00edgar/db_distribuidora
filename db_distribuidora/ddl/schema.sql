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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABLA 3: sedes
-- ============================================================
CREATE TABLE IF NOT EXISTS sedes (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sede VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200) NOT NULL,
    capacidad_almacenamiento INT NOT NULL CHECK (capacidad_almacenamiento > 0),
    encargado VARCHAR(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;