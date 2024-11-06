USE VendingMS;

-- Inserción de datos para la tabla Ubicación
INSERT INTO Ubicacion (nombre, descripcion) VALUES
('Oficina Central', 'Oficina principal en Santiago'),
('Sucursal 1', 'Sucursal en Viña del Mar'),
('Sucursal 2', 'Sucursal en Concepción');

-- Inserción de datos para la tabla Máquina
INSERT INTO Maquina (ubicacion_id, fecha_instalacion, estado) VALUES
(1, '2023-01-15', 'Operativa'),
(2, '2023-05-22', 'Mantenimiento'),
(3, '2023-07-10', 'Operativa');

-- Inserción de datos para la tabla CategoriaProducto
INSERT INTO CategoriaProducto (nombre, descripcion) VALUES
('Snack', 'Productos de snack como papas fritas y galletas'),
('Bebida', 'Bebidas embotelladas o enlatadas');

-- Inserción de datos para la tabla Proveedor
INSERT INTO Proveedor (nombre, contacto, telefono, direccion) VALUES
('Distribuidora ABC', 'Juan Pérez', '123456789', 'Av. Las Condes 1234, Santiago'),
('Proveedor XYZ', 'María López', '987654321', 'Calle 5 Oriente 678, Viña del Mar');

-- Inserción de datos para la tabla Producto
INSERT INTO Producto (nombre, categoria_id, proveedor_id, precio, fecha_ultima_actualizacion) VALUES
('Papas Fritas', 1, 1, 1500, '2021-11-03'),
('Galletas', 1, 1, 800, '2022-11-03'),
('Bebida Cola', 2, 2, 1000, '2023-11-03'),
('Agua Mineral', 2, 2, 1200, '2024-11-03');

-- Inserción de datos para la tabla Inventario
INSERT INTO Inventario (maquina_id, producto_id, cantidad) VALUES
(1, 1, 50),
(1, 2, 30),
(2, 3, 20),
(3, 4, 40);

-- Inserción de datos para la tabla Cliente
INSERT INTO Cliente (nombre, email, telefono) VALUES
('Carlos González', 'carlos.g@example.com', '998877665'),
('Ana Rojas', 'ana.r@example.com', '887766554'),
('Javier Araya', 'javier.a@example.com', '776655443');

-- Inserción de datos para la tabla Empleado
INSERT INTO Empleado (nombre, cargo, telefono) VALUES
('Lucía Sánchez', 'Técnico de Mantenimiento', '668899002'),
('Mario Díaz', 'Encargado de Reabastecimiento', '778899001');

-- Inserción de datos para la tabla Promoción
INSERT INTO Promocion (nombre, descripcion, descuento, fecha_inicio, fecha_fin) VALUES
('Promo Verano', 'Descuento en bebidas para el verano', 100, '2024-11-01', '2025-11-01'),
('Pack Snacks', 'Descuento en la compra de dos snacks', 200, '2024-01-15', '2024-03-15');

-- Inserción de datos para la tabla MétodoPago
INSERT INTO MetodoPago (nombre, descripcion) VALUES
('Efectivo', 'Pago en efectivo'),
('Tarjeta de Crédito', 'Pago con tarjeta de crédito'),
('Tarjeta de Débito', 'Pago con tarjeta de débito');

-- Inserción de datos para la tabla Venta
INSERT INTO Venta (cliente_id, empleado_id, metodo_pago_id, fecha, total) VALUES
(1, 1, 1, '2024-11-01 14:35:00', 2400),
(2, 1, 2, '2024-01-12 16:10:00', 1800),
(3, 2, 3, '2024-11-03 13:50:00', 3000);

-- Inserción de datos para la tabla DetalleVenta
INSERT INTO DetalleVenta (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 1200),
(1, 2, 1, 1200),
(2, 3, 1, 1500),
(2, 4, 1, 1000),
(3, 1, 2, 1200);

-- Inserción de datos para la tabla Mantenimiento
INSERT INTO Mantenimiento (maquina_id, empleado_id, fecha, descripcion) VALUES
(2, 1, '2024-01-20', 'Reparación de sistema de refrigeración'),
(3, 1, '2024-01-22', 'Revisión general');

-- Inserción de datos para la tabla Reabastecimiento
INSERT INTO Reabastecimiento (maquina_id, producto_id, empleado_id, fecha, cantidad) VALUES
(1, 1, 2, '2024-01-05 09:00:00', 50),
(2, 3, 2, '2024-01-10 11:30:00', 40),
(3, 4, 2, '2024-01-12 14:00:00', 20);

-- Inserción de datos para la tabla HistorialPrecioProducto
INSERT INTO HistorialPrecioProducto (producto_id, fecha_inicio, fecha_fin, precio) VALUES
(1, '2023-01-01', '2023-06-30', 1000),
(1, '2023-07-01', '2024-01-01', 1200),
(2, '2023-01-01', '2024-01-01', 800),
(3, '2023-01-01', '2024-01-01', 1500),
(4, '2023-01-01', '2024-01-01', 1000);

-- Mensaje de finalización
SELECT 'Datos iniciales insertados en la base de datos Vending MS exitosamente.' AS mensaje;