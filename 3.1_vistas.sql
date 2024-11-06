USE VendingMS;

-- Vista 1: Información de productos en inventario, mostrando la ubicación y el estado de la máquina
DROP VIEW IF EXISTS vw_productos_inventario;
CREATE VIEW vw_productos_inventario AS
SELECT 
    p.producto_id,
    p.nombre AS producto,
    c.nombre AS categoria,
    m.maquina_id,
    u.nombre AS ubicacion,
    i.cantidad,
    m.estado AS estado_maquina
FROM 
    Inventario i
JOIN Producto p ON i.producto_id = p.producto_id
JOIN CategoriaProducto c ON p.categoria_id = c.categoria_id
JOIN Maquina m ON i.maquina_id = m.maquina_id
JOIN Ubicacion u ON m.ubicacion_id = u.ubicacion_id;

-- Vista 2: Ventas detalladas con información de cliente y productos comprados
DROP VIEW IF EXISTS vw_detalle_ventas;
CREATE VIEW vw_detalle_ventas AS
SELECT 
    v.venta_id,
    c.nombre AS cliente,
    v.fecha,
    mp.nombre AS metodo_pago,
    d.producto_id,
    p.nombre AS producto,
    d.cantidad,
    d.precio_unitario,
    (d.cantidad * d.precio_unitario) AS total_producto
FROM 
    Venta v
JOIN Cliente c ON v.cliente_id = c.cliente_id
JOIN MetodoPago mp ON v.metodo_pago_id = mp.metodo_pago_id
JOIN DetalleVenta d ON v.venta_id = d.venta_id
JOIN Producto p ON d.producto_id = p.producto_id;

-- Vista 3: Historial de precios de productos para monitorear cambios de precios
DROP VIEW IF EXISTS vw_historial_precio;
CREATE VIEW vw_historial_precio AS
SELECT 
    hp.historial_precio_id,
    p.producto_id,
    p.nombre AS producto,
    hp.fecha_inicio,
    hp.fecha_fin,
    hp.precio AS precio_anterior
FROM 
    HistorialPrecioProducto hp
JOIN Producto p ON hp.producto_id = p.producto_id;

-- Vista 4: Estado de máquinas con información de ubicación y último mantenimiento
DROP VIEW IF EXISTS vw_estado_maquinas;
CREATE VIEW vw_estado_maquinas AS
SELECT 
    m.maquina_id,
    u.nombre AS ubicacion,
    m.estado,
    MAX(mt.fecha) AS ultima_fecha_mantenimiento,
    e.nombre AS tecnico
FROM 
    Maquina m
JOIN Ubicacion u ON m.ubicacion_id = u.ubicacion_id
LEFT JOIN Mantenimiento mt ON m.maquina_id = mt.maquina_id
LEFT JOIN Empleado e ON mt.empleado_id = e.empleado_id
GROUP BY 
    m.maquina_id, u.nombre, m.estado, e.nombre;

-- Vista 5: Ventas por cliente, mostrando el total gastado y el número de compras
DROP VIEW IF EXISTS vw_ventas_cliente;
CREATE VIEW vw_ventas_cliente AS
SELECT 
    c.cliente_id,
    c.nombre AS cliente,
    COUNT(v.venta_id) AS numero_compras,
    SUM(v.total) AS total_gastado
FROM 
    Venta v
JOIN Cliente c ON v.cliente_id = c.cliente_id
GROUP BY 
    c.cliente_id, c.nombre;

-- Mensaje de finalización
SELECT 'Vistas de solo lectura creadas exitosamente en la base de datos Vending MS.' AS mensaje;
