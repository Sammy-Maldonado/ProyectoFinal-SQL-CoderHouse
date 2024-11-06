USE VendingMS;

DELIMITER //
-- Función 1: Calcular Descuento de Promoción
-- Dropea la función si ya existe
DROP FUNCTION IF EXISTS aplicarDescuentoBebidaVerano;

CREATE FUNCTION aplicarDescuentoBebidaVerano(producto_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE precio INT;
    DECLARE precio_final INT;
    DECLARE descuento INT DEFAULT 0;  -- Inicializa el descuento en 0
    DECLARE categoria_id INT;
    DECLARE fecha_actual DATE;

    SET fecha_actual = CURDATE();

    -- Obtener el precio del producto y su categoría
    SELECT p.precio, p.categoria_id INTO precio, categoria_id
    FROM vendingms.producto p
    WHERE p.producto_id = producto_id;

    -- Verificar si el producto es una bebida
    IF categoria_id = 2 THEN
        -- Comprobar si hay un descuento vigente para la promoción de verano
        SELECT p.descuento INTO descuento
        FROM vendingms.promocion p
        WHERE p.promocion_id = 1  -- Promo Verano
          AND p.fecha_inicio <= fecha_actual
          AND p.fecha_fin >= fecha_actual;

        -- Si hay un descuento, aplicar el descuento
        IF descuento IS NOT NULL THEN
            SET precio_final = precio - descuento;
        ELSE
            SET precio_final = precio;  -- No hay descuento
        END IF;
    ELSE
        SET precio_final = precio;  -- No es una bebida, precio final es el original
    END IF;

    RETURN precio_final;
END;
//

-- Función 2: Calcular el Total Gastado por Cliente en un Rango de Fechas
-- Dropea la función si ya existe
DROP FUNCTION IF EXISTS calcularTotalGastoCliente;

-- Creación de la función para calcular el total de gasto de un cliente en un rango de fechas
CREATE FUNCTION calcularTotalGastoCliente(cliente_id INT, fecha_inicio DATE, fecha_fin DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_gasto INT;

    -- Calcula el total de gasto en el rango de fechas para el cliente dado
    SELECT COALESCE(SUM(total), 0) INTO total_gasto
    FROM Venta
    WHERE cliente_id = cliente_id
      AND fecha BETWEEN fecha_inicio AND fecha_fin;

    RETURN total_gasto;
END;
//

DELIMITER ;

-- Ejemplos de uso de las funciones
-- Función 1
SELECT 
    producto_id, 
    nombre, 
    precio, 
    aplicarDescuentoBebidaVerano(producto_id) AS precio_con_descuento
FROM 
    vendingms.producto;

-- Función 2
SELECT calcularTotalGastoCliente(2, '2024-11-01', '2024-11-04') AS total_gasto_cliente;