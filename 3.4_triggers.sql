USE VendingMS;

-- Crear tabla LogProducto para almacenar cambios de producto
CREATE TABLE IF NOT EXISTS LogProducto (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    nombre_anterior VARCHAR(100),
    nombre_nuevo VARCHAR(100),
    precio_anterior INT,
    precio_nuevo INT,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
);

DELIMITER //

-- Trigger para registrar cambios en el nombre o precio de un producto
DROP TRIGGER IF EXISTS logProductoUpdate;
CREATE TRIGGER logProductoUpdate
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
    -- Solo registrar cambios si el nombre o el precio fueron modificados
    IF OLD.nombre != NEW.nombre OR OLD.precio != NEW.precio THEN
        INSERT INTO LogProducto (producto_id, nombre_anterior, nombre_nuevo, precio_anterior, precio_nuevo)
        VALUES (NEW.producto_id, OLD.nombre, NEW.nombre, OLD.precio, NEW.precio);
    END IF;
END;
//

-- Trigger para validar stock antes de insertar en detalleventa
DROP TRIGGER IF EXISTS validarStockAntesDeInsertar;
CREATE TRIGGER validarStockAntesDeInsertar
BEFORE INSERT ON detalleventa
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;
    
    -- Obtener el stock actual del producto desde inventario
    SELECT cantidad INTO stock_actual 
    FROM inventario 
    WHERE producto_id = NEW.producto_id;
    
    -- Verificar si hay suficiente stock para cubrir la cantidad solicitada
    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Stock insuficiente para el producto.';
    ELSE
        -- Reducir el stock en la cantidad solicitada en inventario
        UPDATE inventario 
        SET cantidad = cantidad - NEW.cantidad 
        WHERE producto_id = NEW.producto_id;
    END IF;
END;
//

DELIMITER ;

-- Pruebas para los triggers

-- Prueba del trigger logProductoUpdate
UPDATE Producto SET precio = 1700 WHERE producto_id = 1;
SELECT * FROM LogProducto
ORDER BY fecha_modificacion
desc;

-- Prueba del trigger validarStockAntesDeInsertar
INSERT INTO detalleventa (venta_id, producto_id, cantidad, precio_unitario) 
VALUES (1, 1, 45, 1200);  -- Reducirá el stock del producto 1 en inventario si hay suficiente stock.

-- Verificar el estado del inventario después de la inserción
SELECT * FROM inventario;