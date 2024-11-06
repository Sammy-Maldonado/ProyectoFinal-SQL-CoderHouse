USE VendingMS;

DELIMITER //
SET SQL_SAFE_UPDATES = 0;
DROP PROCEDURE IF EXISTS limpiarRegistrosInactivos;
DROP PROCEDURE IF EXISTS resumenVentasPorCategoria;

-- Procedimiento Almacenado: Limpieza de Registros Inactivos
CREATE PROCEDURE limpiarRegistrosInactivos(IN periodo INT)
BEGIN
    UPDATE Producto
    SET activo = FALSE
    WHERE fecha_ultima_actualizacion < DATE_SUB(CURDATE(), INTERVAL periodo YEAR)
    AND producto_id IS NOT NULL;  -- Asegura que se use una clave
END;
//

-- Procedimiento Almacenado: Manejo de Datos Agrupados
CREATE PROCEDURE resumenVentasPorCategoria()
BEGIN
    SELECT 
        p.categoria_id,
        SUM(dv.cantidad * dv.precio_unitario) AS total_ventas
    FROM 
        Venta v
    JOIN 
        detalleventa dv 
		ON v.venta_id = dv.venta_id
    JOIN 
        Producto p 
        ON dv.producto_id = p.producto_id
    GROUP BY 
        p.categoria_id
    ORDER BY 
        total_ventas DESC;
END;
//

DELIMITER ;

-- Casos de uso de los procedimientos almacenados

-- Limpieza de Registros Inactivos
CALL limpiarRegistrosInactivos(2);  -- Elimina productos que no han sido actualizados en los últimos 2 años.

-- Manejo de Datos Agrupados
CALL resumenVentasPorCategoria();  -- Obtiene un resumen de las ventas por categoría de producto.