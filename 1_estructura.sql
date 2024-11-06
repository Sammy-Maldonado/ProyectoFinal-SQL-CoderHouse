-- Dropea la base de datos si existe
DROP DATABASE IF EXISTS VendingMS;

-- Creación de la base de datos
CREATE DATABASE VendingMS;
USE VendingMS;

-- Tabla Ubicación
CREATE TABLE Ubicacion (
    ubicacion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(255)
);

-- Tabla Máquina
CREATE TABLE Maquina (
    maquina_id INT AUTO_INCREMENT PRIMARY KEY,
    ubicacion_id INT,
    fecha_instalacion DATE,
    estado VARCHAR(50),
    FOREIGN KEY (ubicacion_id) REFERENCES Ubicacion(ubicacion_id)
);

-- Tabla CategoriaProducto
CREATE TABLE CategoriaProducto (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(255)
);

-- Tabla Proveedor
CREATE TABLE Proveedor (
    proveedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    contacto VARCHAR(100),
    telefono VARCHAR(15),
    direccion VARCHAR(255)
);

-- Tabla Producto
CREATE TABLE Producto (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    categoria_id INT,
    proveedor_id INT,
    precio INT,
    fecha_ultima_actualizacion DATE,
    FOREIGN KEY (categoria_id) REFERENCES CategoriaProducto(categoria_id),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedor(proveedor_id)
);

-- Tabla Inventario
CREATE TABLE Inventario (
    inventario_id INT AUTO_INCREMENT PRIMARY KEY,
    maquina_id INT,
    producto_id INT,
    cantidad INT,
    FOREIGN KEY (maquina_id) REFERENCES Maquina(maquina_id),
    FOREIGN KEY (producto_id) REFERENCES Producto(producto_id)
);

-- Tabla Cliente
CREATE TABLE Cliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(15)
);

-- Tabla Empleado
CREATE TABLE Empleado (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    cargo VARCHAR(100),
    telefono VARCHAR(15)
);

-- Tabla Promocion
CREATE TABLE Promocion (
    promocion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(255),
    descuento INT,
    fecha_inicio DATE,
    fecha_fin DATE
);

-- Tabla MétodoPago
CREATE TABLE MetodoPago (
    metodo_pago_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(255)
);

-- Tabla Venta
CREATE TABLE Venta (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    empleado_id INT,
    metodo_pago_id INT,
    fecha DATETIME,
    total INT,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleado(empleado_id),
    FOREIGN KEY (metodo_pago_id) REFERENCES MetodoPago(metodo_pago_id)
);

-- Tabla DetalleVenta
CREATE TABLE DetalleVenta (
    detalle_id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT,
    producto_id INT,
    cantidad INT,
    precio_unitario INT,
    FOREIGN KEY (venta_id) REFERENCES Venta(venta_id),
    FOREIGN KEY (producto_id) REFERENCES Producto(producto_id)
);

-- Tabla Mantenimiento
CREATE TABLE Mantenimiento (
    mantenimiento_id INT AUTO_INCREMENT PRIMARY KEY,
    maquina_id INT,
    empleado_id INT,
    fecha DATE,
    descripcion VARCHAR(255),
    FOREIGN KEY (maquina_id) REFERENCES Maquina(maquina_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleado(empleado_id)
);

-- Tabla Reabastecimiento
CREATE TABLE Reabastecimiento (
    reabastecimiento_id INT AUTO_INCREMENT PRIMARY KEY,
    maquina_id INT,
    producto_id INT,
    empleado_id INT,
    fecha DATETIME,
    cantidad INT,
    FOREIGN KEY (maquina_id) REFERENCES Maquina(maquina_id),
    FOREIGN KEY (producto_id) REFERENCES Producto(producto_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleado(empleado_id)
);

-- Tabla HistorialPrecioProducto
CREATE TABLE HistorialPrecioProducto (
    historial_precio_id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    precio INT,
    FOREIGN KEY (producto_id) REFERENCES Producto(producto_id)
);

ALTER TABLE Producto ADD COLUMN activo BOOLEAN DEFAULT TRUE;

-- Mensaje de finalización
SELECT 'Estructura de la base de datos Vending MS creada exitosamente.' AS mensaje;