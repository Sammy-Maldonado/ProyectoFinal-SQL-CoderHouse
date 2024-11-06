# Proyecto de Vending en Santiago de Chile

Este proyecto implementa un sistema de gestión de máquinas expendedoras en Santiago de Chile. La base de datos, denominada `VendingMS`, almacena información sobre productos, ubicaciones, máquinas, inventarios, ventas, clientes, empleados, promociones y métodos de pago. Además, incluye vistas para facilitar el análisis de datos.

## Estructura de la Base de Datos

La base de datos `VendingMS` está compuesta por las siguientes tablas principales:

- **Ubicacion**: Almacena información sobre las ubicaciones donde se encuentran las máquinas.
- **Maquina**: Registra detalles de las máquinas, incluyendo su ubicación, fecha de instalación y estado.
- **CategoriaProducto**: Clasifica los productos en diferentes categorías.
- **Proveedor**: Detalla la información de los proveedores de los productos.
- **Producto**: Contiene la información básica de cada producto.
- **Inventario**: Registra las existencias de cada producto en cada máquina.
- **Cliente**: Información sobre los clientes registrados.
- **Empleado**: Datos de los empleados que operan o gestionan las máquinas y productos.
- **Promocion**: Registra las promociones disponibles.
- **MetodoPago**: Métodos de pago aceptados.
- **Venta**: Información de cada transacción de venta realizada.
- **DetalleVenta**: Detalles específicos de los productos en cada venta.
- **Mantenimiento**: Información sobre los mantenimientos realizados a las máquinas.
- **Reabastecimiento**: Registro de los reabastecimientos de productos en las máquinas.
- **HistorialPrecioProducto**: Historial de precios de los productos.

## Scripts

### 1. Estructura de la Base de Datos
El script `1_estructura.sql` crea todas las tablas de la base de datos, incluyendo las claves foráneas y los tipos de datos apropiados para cada campo. Al final del script, se genera un mensaje confirmando la creación exitosa.

### 2. Población Inicial de Datos
El script `2_population.sql` inserta datos de prueba en cada tabla para facilitar la evaluación de la base de datos y simular un entorno de producción.

### 3. Vistas
El script `3.1_vistas.sql` crea cuatro vistas que facilitan la obtención de información relevante:

- **vw_productos_inventario**: Muestra los productos en inventario junto con la ubicación y el estado de la máquina.
- **vw_detalle_ventas**: Proporciona detalles de las ventas, incluyendo información de clientes y productos comprados.
- **vw_historial_precio**: Monitorea los cambios en el historial de precios de los productos.
- **vw_estado_maquinas**: Informa sobre el estado de las máquinas, su ubicación y la fecha del último mantenimiento.

### Funciones Principales

1. **Función 1: Calcular Descuento de Promoción para Bebidas de Verano**
   - La función **aplicarDescuentoBebidaVerano** calcula el precio final de un producto. Si el producto es una bebida y hay una promoción activa de verano, se aplica un descuento al precio. Si no es una bebida o no hay descuento activo, el precio se mantiene igual.

   **Caso de uso**
   ```sql
    SELECT 
        producto_id, 
        nombre, 
        precio, 
        aplicarDescuentoBebidaVerano(producto_id) AS precio_con_descuento
    FROM 
    vendingms.producto;
   
2. **Función 2: Calcular el Total Gastado por un Cliente en un Rango de Fechas**
   - La función **calcularTotalGastoCliente** calcula el total de dinero gastado por un cliente dentro de un rango de fechas específico. Se basa en las compras realizadas por el cliente durante el período indicado y devuelve la suma total de los gastos.

   **Caso de uso**
   ```sql
    SELECT calcularTotalGastoCliente(2, '2024-11-01', '2024-11-04') AS total_gasto_cliente;

### Procedimientos Almacenados (SP)

Los procedimientos almacenados (SP) implementados permiten automatizar tareas frecuentes y consultas complejas. A continuación, algunos casos de uso:

- **Limpiar Registros Inactivos**: Elimina productos que no han sido actualizados en los últimos 2 años.
    **Caso de uso**
    ```sql
    CALL limpiarRegistrosInactivos(2);

- **Resumen Ventas Por Categoria**: Obtiene un resumen de las ventas por categoría de producto.
    ```sql
    CALL resumenVentasPorCategoria();

### Triggers en la Base de Datos

1. **Trigger: `logProductoUpdate`**
   - Este trigger se activa **después de cada actualización** en la tabla `Producto`. Su propósito es registrar los cambios en el nombre o el precio de un producto. Si alguno de estos dos valores cambia, se crea una entrada en la tabla `LogProducto`, que almacena el ID del producto, los valores antiguos y nuevos del nombre y precio, y la fecha de la modificación.

   **Caso de uso**
   ```sql
    UPDATE Producto SET precio = 1700 WHERE producto_id = 1;
    SELECT * FROM LogProducto
    ORDER BY fecha_modificacion
    desc;

2. **Trigger: `validarStockAntesDeInsertar`**
   - Este trigger se activa **antes de cada inserción** en la tabla `detalleventa`. Se asegura de que haya suficiente stock disponible en el inventario para cubrir la cantidad solicitada en una venta. Si el stock es insuficiente, se genera un error. Si hay suficiente stock, el trigger actualiza la cantidad en el inventario, reduciéndola en función de la cantidad de la venta.

   **Caso de uso**
   ```sql
    INSERT INTO detalleventa (venta_id, producto_id, cantidad, precio_unitario) 
    VALUES (1, 1, 45, 1200);
    SELECT * FROM inventario;

### Creación de Usuarios y Permisos

1. **Usuario: `ddl_user`**
   - **Propósito**: Este usuario tiene permisos para realizar operaciones básicas de lectura y modificación sobre la base de datos `vendingms`. Se le otorgan permisos de `SELECT`, `INSERT`, y `UPDATE` en todas las tablas de la base de datos.
   
   **Permisos otorgados**:
   - `SELECT`, `INSERT`, `UPDATE` en `vendingms.*`.

2. **Usuario: `consumer_user`**
   - **Propósito**: Este usuario tiene permisos de solo lectura sobre varias vistas de la base de datos. Los permisos se limitan a consultar información específica como ventas, inventario, historial de precios, etc.
   
   **Permisos otorgados**:
   - `SELECT` en las vistas `vw_detalle_ventas`, `vw_estado_maquinas`, `vw_historial_precio`, `vw_productos_inventario`, y `vw_ventas_cliente`.

3. **Usuario: `bk_user`**
   - **Propósito**: Este usuario tiene permisos avanzados para realizar tareas relacionadas con la administración de la base de datos, como respaldos, recargas, y ejecución de procesos. Además, se le da acceso de solo lectura y bloqueo de tablas para ciertas operaciones.
   
   **Permisos otorgados**:
   - `USAGE` en `vendingms.*`.
   - `PROCESS`, `RELOAD` en `*.*`.
   - `SELECT`, `LOCK TABLES`, `SHOW VIEW`, `EVENT`, `TRIGGER` en `vendingms.*`.

## Cómo Utilizar el Proyecto

1. Ejecuta `1_estructura.sql` para crear la base de datos y todas las tablas.
2. Ejecuta `2_population.sql` para insertar los datos iniciales.
3. Ejecuta `3.1_vistas.sql` para crear las vistas y facilitar las consultas.
4. Usa funciones, procedimientos almacenados y triggers para realizar operaciones frecuentes en el sistema.
5. Genera los permisos de usuario siempre que sean necesarios.

## Requisitos Previos

- **MySQL**: Este proyecto está diseñado para ejecutarse en un entorno MySQL.
- **SQL Client**: Puedes usar cualquier cliente SQL compatible con MySQL, como MySQL Workbench, para ejecutar los scripts y realizar consultas.

## Notas Adicionales

Este sistema es una solución integral para la gestión de máquinas expendedoras en Santiago de Chile. Asegura un control detallado de inventarios, ventas, y operaciones de mantenimiento, ofreciendo una experiencia óptima de vending automatizado.