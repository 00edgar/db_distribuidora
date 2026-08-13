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