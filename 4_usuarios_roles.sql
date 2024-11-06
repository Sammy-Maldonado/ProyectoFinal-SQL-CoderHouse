USE VendingMS;

-- users
CREATE USER 'ddl_user' @'%' IDENTIFIED BY '123456';

CREATE USER 'consumer_user' @'%' IDENTIFIED BY '123456';

CREATE USER 'bk_user' @'%' IDENTIFIED BY '123456';


-- GRANT

-- ddl_user
GRANT SELECT, INSERT , UPDATE ON vendingms.* TO 'ddl_user' @'%';

SHOW GRANTS FOR 'ddl_user' @'%';

-- consumer_user
GRANT
SELECT ON vendingms.vw_detalle_ventas TO 'consumer_user' @'%';

GRANT
SELECT ON vendingms.vw_estado_maquinas TO 'consumer_user' @'%';

GRANT
SELECT ON vendingms.vw_historial_precio TO 'consumer_user' @'%';

GRANT
SELECT ON vendingms.vw_productos_inventario TO 'consumer_user' @'%';

GRANT
SELECT ON vendingms.vw_ventas_cliente TO 'consumer_user' @'%';

SHOW GRANTS FOR 'consumer_user' @'%';

-- bk_user
GRANT USAGE ON vendingms.* TO 'bk_user' @'%';

GRANT PROCESS, RELOAD
  ON *.* TO 'bk_user' @'%';

GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER
  ON vendingms.* TO 'bk_user' @'%';

SHOW GRANTS FOR 'bk_user' @'%';