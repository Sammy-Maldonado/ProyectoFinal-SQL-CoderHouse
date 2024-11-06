-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: vendingms
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categoriaproducto`
--

DROP TABLE IF EXISTS `categoriaproducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoriaproducto` (
  `categoria_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`categoria_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoriaproducto`
--

LOCK TABLES `categoriaproducto` WRITE;
/*!40000 ALTER TABLE `categoriaproducto` DISABLE KEYS */;
INSERT INTO `categoriaproducto` VALUES (1,'Snack','Productos de snack como papas fritas y galletas'),(2,'Bebida','Bebidas embotelladas o enlatadas');
/*!40000 ALTER TABLE `categoriaproducto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `cliente_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`cliente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Carlos Gonz+璱ez','carlos.g@example.com','998877665'),(2,'Ana Rojas','ana.r@example.com','887766554'),(3,'Javier Araya','javier.a@example.com','776655443');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalleventa`
--

DROP TABLE IF EXISTS `detalleventa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalleventa` (
  `detalle_id` int NOT NULL AUTO_INCREMENT,
  `venta_id` int DEFAULT NULL,
  `producto_id` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `precio_unitario` int DEFAULT NULL,
  PRIMARY KEY (`detalle_id`),
  KEY `venta_id` (`venta_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `detalleventa_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `venta` (`venta_id`),
  CONSTRAINT `detalleventa_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `producto` (`producto_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalleventa`
--

LOCK TABLES `detalleventa` WRITE;
/*!40000 ALTER TABLE `detalleventa` DISABLE KEYS */;
INSERT INTO `detalleventa` VALUES (1,1,1,1,1200),(2,1,2,1,1200),(3,2,3,1,1500),(4,2,4,1,1000),(5,3,1,2,1200),(6,1,1,5,1200),(7,1,1,2,1200);
/*!40000 ALTER TABLE `detalleventa` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validarStockAntesDeInsertar` BEFORE INSERT ON `detalleventa` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `empleado`
--

DROP TABLE IF EXISTS `empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleado` (
  `empleado_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `cargo` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`empleado_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleado`
--

LOCK TABLES `empleado` WRITE;
/*!40000 ALTER TABLE `empleado` DISABLE KEYS */;
INSERT INTO `empleado` VALUES (1,'Luc+｛ S+璯chez','T+宮nico de Mantenimiento','668899002'),(2,'Mario D+｛z','Encargado de Reabastecimiento','778899001');
/*!40000 ALTER TABLE `empleado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historialprecioproducto`
--

DROP TABLE IF EXISTS `historialprecioproducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historialprecioproducto` (
  `historial_precio_id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `precio` int DEFAULT NULL,
  PRIMARY KEY (`historial_precio_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `historialprecioproducto_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `producto` (`producto_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historialprecioproducto`
--

LOCK TABLES `historialprecioproducto` WRITE;
/*!40000 ALTER TABLE `historialprecioproducto` DISABLE KEYS */;
INSERT INTO `historialprecioproducto` VALUES (1,1,'2023-01-01','2023-06-30',1000),(2,1,'2023-07-01','2024-01-01',1200),(3,2,'2023-01-01','2024-01-01',800),(4,3,'2023-01-01','2024-01-01',1500),(5,4,'2023-01-01','2024-01-01',1000);
/*!40000 ALTER TABLE `historialprecioproducto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `inventario_id` int NOT NULL AUTO_INCREMENT,
  `maquina_id` int DEFAULT NULL,
  `producto_id` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  PRIMARY KEY (`inventario_id`),
  KEY `maquina_id` (`maquina_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `inventario_ibfk_1` FOREIGN KEY (`maquina_id`) REFERENCES `maquina` (`maquina_id`),
  CONSTRAINT `inventario_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `producto` (`producto_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (1,1,1,43),(2,1,2,30),(3,2,3,20),(4,3,4,40);
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logproducto`
--

DROP TABLE IF EXISTS `logproducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logproducto` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int DEFAULT NULL,
  `nombre_anterior` varchar(100) DEFAULT NULL,
  `nombre_nuevo` varchar(100) DEFAULT NULL,
  `precio_anterior` int DEFAULT NULL,
  `precio_nuevo` int DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `logproducto_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `producto` (`producto_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logproducto`
--

LOCK TABLES `logproducto` WRITE;
/*!40000 ALTER TABLE `logproducto` DISABLE KEYS */;
INSERT INTO `logproducto` VALUES (1,1,'Papas Fritas','Papas Fritas',1500,1600,'2024-11-05 23:16:46'),(2,1,'Papas Fritas','Papas Fritas',1600,1700,'2024-11-05 23:17:14');
/*!40000 ALTER TABLE `logproducto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mantenimiento`
--

DROP TABLE IF EXISTS `mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mantenimiento` (
  `mantenimiento_id` int NOT NULL AUTO_INCREMENT,
  `maquina_id` int DEFAULT NULL,
  `empleado_id` int DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mantenimiento_id`),
  KEY `maquina_id` (`maquina_id`),
  KEY `empleado_id` (`empleado_id`),
  CONSTRAINT `mantenimiento_ibfk_1` FOREIGN KEY (`maquina_id`) REFERENCES `maquina` (`maquina_id`),
  CONSTRAINT `mantenimiento_ibfk_2` FOREIGN KEY (`empleado_id`) REFERENCES `empleado` (`empleado_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mantenimiento`
--

LOCK TABLES `mantenimiento` WRITE;
/*!40000 ALTER TABLE `mantenimiento` DISABLE KEYS */;
INSERT INTO `mantenimiento` VALUES (1,2,1,'2024-01-20','Reparaci+好 de sistema de refrigeraci+好'),(2,3,1,'2024-01-22','Revisi+好 general');
/*!40000 ALTER TABLE `mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maquina`
--

DROP TABLE IF EXISTS `maquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquina` (
  `maquina_id` int NOT NULL AUTO_INCREMENT,
  `ubicacion_id` int DEFAULT NULL,
  `fecha_instalacion` date DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`maquina_id`),
  KEY `ubicacion_id` (`ubicacion_id`),
  CONSTRAINT `maquina_ibfk_1` FOREIGN KEY (`ubicacion_id`) REFERENCES `ubicacion` (`ubicacion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maquina`
--

LOCK TABLES `maquina` WRITE;
/*!40000 ALTER TABLE `maquina` DISABLE KEYS */;
INSERT INTO `maquina` VALUES (1,1,'2023-01-15','Operativa'),(2,2,'2023-05-22','Mantenimiento'),(3,3,'2023-07-10','Operativa');
/*!40000 ALTER TABLE `maquina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodopago`
--

DROP TABLE IF EXISTS `metodopago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodopago` (
  `metodo_pago_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`metodo_pago_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodopago`
--

LOCK TABLES `metodopago` WRITE;
/*!40000 ALTER TABLE `metodopago` DISABLE KEYS */;
INSERT INTO `metodopago` VALUES (1,'Efectivo','Pago en efectivo'),(2,'Tarjeta de Cr+宵ito','Pago con tarjeta de cr+宵ito'),(3,'Tarjeta de D+宴ito','Pago con tarjeta de d+宴ito');
/*!40000 ALTER TABLE `metodopago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto` (
  `producto_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `categoria_id` int DEFAULT NULL,
  `proveedor_id` int DEFAULT NULL,
  `precio` int DEFAULT NULL,
  `fecha_ultima_actualizacion` date DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`producto_id`),
  KEY `categoria_id` (`categoria_id`),
  KEY `proveedor_id` (`proveedor_id`),
  CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categoriaproducto` (`categoria_id`),
  CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedor` (`proveedor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
INSERT INTO `producto` VALUES (1,'Papas Fritas',1,1,1700,'2021-11-03',1),(2,'Galletas',1,1,800,'2022-11-03',1),(3,'Bebida Cola',2,2,1000,'2023-11-03',1),(4,'Agua Mineral',2,2,1200,'2024-11-03',1);
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `logProductoUpdate` AFTER UPDATE ON `producto` FOR EACH ROW BEGIN
    -- Solo registrar cambios si el nombre o el precio fueron modificados
    IF OLD.nombre != NEW.nombre OR OLD.precio != NEW.precio THEN
        INSERT INTO LogProducto (producto_id, nombre_anterior, nombre_nuevo, precio_anterior, precio_nuevo)
        VALUES (NEW.producto_id, OLD.nombre, NEW.nombre, OLD.precio, NEW.precio);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `promocion`
--

DROP TABLE IF EXISTS `promocion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promocion` (
  `promocion_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `descuento` int DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  PRIMARY KEY (`promocion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promocion`
--

LOCK TABLES `promocion` WRITE;
/*!40000 ALTER TABLE `promocion` DISABLE KEYS */;
INSERT INTO `promocion` VALUES (1,'Promo Verano','Descuento en bebidas para el verano',100,'2024-11-01','2025-11-01'),(2,'Pack Snacks','Descuento en la compra de dos snacks',200,'2024-01-15','2024-03-15');
/*!40000 ALTER TABLE `promocion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedor`
--

DROP TABLE IF EXISTS `proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedor` (
  `proveedor_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `contacto` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`proveedor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedor`
--

LOCK TABLES `proveedor` WRITE;
/*!40000 ALTER TABLE `proveedor` DISABLE KEYS */;
INSERT INTO `proveedor` VALUES (1,'Distribuidora ABC','Juan P+崁ez','123456789','Av. Las Condes 1234, Santiago'),(2,'Proveedor XYZ','Mar+｛ L+如ez','987654321','Calle 5 Oriente 678, Vi+地 del Mar');
/*!40000 ALTER TABLE `proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reabastecimiento`
--

DROP TABLE IF EXISTS `reabastecimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reabastecimiento` (
  `reabastecimiento_id` int NOT NULL AUTO_INCREMENT,
  `maquina_id` int DEFAULT NULL,
  `producto_id` int DEFAULT NULL,
  `empleado_id` int DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  PRIMARY KEY (`reabastecimiento_id`),
  KEY `maquina_id` (`maquina_id`),
  KEY `producto_id` (`producto_id`),
  KEY `empleado_id` (`empleado_id`),
  CONSTRAINT `reabastecimiento_ibfk_1` FOREIGN KEY (`maquina_id`) REFERENCES `maquina` (`maquina_id`),
  CONSTRAINT `reabastecimiento_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `producto` (`producto_id`),
  CONSTRAINT `reabastecimiento_ibfk_3` FOREIGN KEY (`empleado_id`) REFERENCES `empleado` (`empleado_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reabastecimiento`
--

LOCK TABLES `reabastecimiento` WRITE;
/*!40000 ALTER TABLE `reabastecimiento` DISABLE KEYS */;
INSERT INTO `reabastecimiento` VALUES (1,1,1,2,'2024-01-05 09:00:00',50),(2,2,3,2,'2024-01-10 11:30:00',40),(3,3,4,2,'2024-01-12 14:00:00',20);
/*!40000 ALTER TABLE `reabastecimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ubicacion`
--

DROP TABLE IF EXISTS `ubicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubicacion` (
  `ubicacion_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ubicacion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ubicacion`
--

LOCK TABLES `ubicacion` WRITE;
/*!40000 ALTER TABLE `ubicacion` DISABLE KEYS */;
INSERT INTO `ubicacion` VALUES (1,'Oficina Central','Oficina principal en Santiago'),(2,'Sucursal 1','Sucursal en Vi+地 del Mar'),(3,'Sucursal 2','Sucursal en Concepci+好');
/*!40000 ALTER TABLE `ubicacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venta`
--

DROP TABLE IF EXISTS `venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venta` (
  `venta_id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int DEFAULT NULL,
  `empleado_id` int DEFAULT NULL,
  `metodo_pago_id` int DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `total` int DEFAULT NULL,
  PRIMARY KEY (`venta_id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `empleado_id` (`empleado_id`),
  KEY `metodo_pago_id` (`metodo_pago_id`),
  CONSTRAINT `venta_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`cliente_id`),
  CONSTRAINT `venta_ibfk_2` FOREIGN KEY (`empleado_id`) REFERENCES `empleado` (`empleado_id`),
  CONSTRAINT `venta_ibfk_3` FOREIGN KEY (`metodo_pago_id`) REFERENCES `metodopago` (`metodo_pago_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venta`
--

LOCK TABLES `venta` WRITE;
/*!40000 ALTER TABLE `venta` DISABLE KEYS */;
INSERT INTO `venta` VALUES (1,1,1,1,'2024-11-01 14:35:00',2400),(2,2,1,2,'2024-01-12 16:10:00',1800),(3,3,2,3,'2024-11-03 13:50:00',3000);
/*!40000 ALTER TABLE `venta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_detalle_ventas`
--

DROP TABLE IF EXISTS `vw_detalle_ventas`;
/*!50001 DROP VIEW IF EXISTS `vw_detalle_ventas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_detalle_ventas` AS SELECT 
 1 AS `venta_id`,
 1 AS `cliente`,
 1 AS `fecha`,
 1 AS `metodo_pago`,
 1 AS `producto_id`,
 1 AS `producto`,
 1 AS `cantidad`,
 1 AS `precio_unitario`,
 1 AS `total_producto`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_estado_maquinas`
--

DROP TABLE IF EXISTS `vw_estado_maquinas`;
/*!50001 DROP VIEW IF EXISTS `vw_estado_maquinas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_estado_maquinas` AS SELECT 
 1 AS `maquina_id`,
 1 AS `ubicacion`,
 1 AS `estado`,
 1 AS `ultima_fecha_mantenimiento`,
 1 AS `tecnico`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_historial_precio`
--

DROP TABLE IF EXISTS `vw_historial_precio`;
/*!50001 DROP VIEW IF EXISTS `vw_historial_precio`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_historial_precio` AS SELECT 
 1 AS `historial_precio_id`,
 1 AS `producto_id`,
 1 AS `producto`,
 1 AS `fecha_inicio`,
 1 AS `fecha_fin`,
 1 AS `precio_anterior`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_productos_inventario`
--

DROP TABLE IF EXISTS `vw_productos_inventario`;
/*!50001 DROP VIEW IF EXISTS `vw_productos_inventario`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_productos_inventario` AS SELECT 
 1 AS `producto_id`,
 1 AS `producto`,
 1 AS `categoria`,
 1 AS `maquina_id`,
 1 AS `ubicacion`,
 1 AS `cantidad`,
 1 AS `estado_maquina`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_ventas_cliente`
--

DROP TABLE IF EXISTS `vw_ventas_cliente`;
/*!50001 DROP VIEW IF EXISTS `vw_ventas_cliente`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_ventas_cliente` AS SELECT 
 1 AS `cliente_id`,
 1 AS `cliente`,
 1 AS `numero_compras`,
 1 AS `total_gastado`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_detalle_ventas`
--

/*!50001 DROP VIEW IF EXISTS `vw_detalle_ventas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_detalle_ventas` AS select `v`.`venta_id` AS `venta_id`,`c`.`nombre` AS `cliente`,`v`.`fecha` AS `fecha`,`mp`.`nombre` AS `metodo_pago`,`d`.`producto_id` AS `producto_id`,`p`.`nombre` AS `producto`,`d`.`cantidad` AS `cantidad`,`d`.`precio_unitario` AS `precio_unitario`,(`d`.`cantidad` * `d`.`precio_unitario`) AS `total_producto` from ((((`venta` `v` join `cliente` `c` on((`v`.`cliente_id` = `c`.`cliente_id`))) join `metodopago` `mp` on((`v`.`metodo_pago_id` = `mp`.`metodo_pago_id`))) join `detalleventa` `d` on((`v`.`venta_id` = `d`.`venta_id`))) join `producto` `p` on((`d`.`producto_id` = `p`.`producto_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_estado_maquinas`
--

/*!50001 DROP VIEW IF EXISTS `vw_estado_maquinas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_estado_maquinas` AS select `m`.`maquina_id` AS `maquina_id`,`u`.`nombre` AS `ubicacion`,`m`.`estado` AS `estado`,max(`mt`.`fecha`) AS `ultima_fecha_mantenimiento`,`e`.`nombre` AS `tecnico` from (((`maquina` `m` join `ubicacion` `u` on((`m`.`ubicacion_id` = `u`.`ubicacion_id`))) left join `mantenimiento` `mt` on((`m`.`maquina_id` = `mt`.`maquina_id`))) left join `empleado` `e` on((`mt`.`empleado_id` = `e`.`empleado_id`))) group by `m`.`maquina_id`,`u`.`nombre`,`m`.`estado`,`e`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_historial_precio`
--

/*!50001 DROP VIEW IF EXISTS `vw_historial_precio`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_historial_precio` AS select `hp`.`historial_precio_id` AS `historial_precio_id`,`p`.`producto_id` AS `producto_id`,`p`.`nombre` AS `producto`,`hp`.`fecha_inicio` AS `fecha_inicio`,`hp`.`fecha_fin` AS `fecha_fin`,`hp`.`precio` AS `precio_anterior` from (`historialprecioproducto` `hp` join `producto` `p` on((`hp`.`producto_id` = `p`.`producto_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_productos_inventario`
--

/*!50001 DROP VIEW IF EXISTS `vw_productos_inventario`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_productos_inventario` AS select `p`.`producto_id` AS `producto_id`,`p`.`nombre` AS `producto`,`c`.`nombre` AS `categoria`,`m`.`maquina_id` AS `maquina_id`,`u`.`nombre` AS `ubicacion`,`i`.`cantidad` AS `cantidad`,`m`.`estado` AS `estado_maquina` from ((((`inventario` `i` join `producto` `p` on((`i`.`producto_id` = `p`.`producto_id`))) join `categoriaproducto` `c` on((`p`.`categoria_id` = `c`.`categoria_id`))) join `maquina` `m` on((`i`.`maquina_id` = `m`.`maquina_id`))) join `ubicacion` `u` on((`m`.`ubicacion_id` = `u`.`ubicacion_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ventas_cliente`
--

/*!50001 DROP VIEW IF EXISTS `vw_ventas_cliente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ventas_cliente` AS select `c`.`cliente_id` AS `cliente_id`,`c`.`nombre` AS `cliente`,count(`v`.`venta_id`) AS `numero_compras`,sum(`v`.`total`) AS `total_gastado` from (`venta` `v` join `cliente` `c` on((`v`.`cliente_id` = `c`.`cliente_id`))) group by `c`.`cliente_id`,`c`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-05 22:06:55
