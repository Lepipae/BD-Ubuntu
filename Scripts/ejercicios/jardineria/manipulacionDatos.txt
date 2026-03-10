USE jardineria;

-- 1 - Inserta una nueva oficina en Almería.
INSERT INTO oficina VALUES ('alm', 'Almería', 'España', 'Andalucía', 28039, 686672652, 'Calle Prepucio morenito nº9', NULL);
SELECT * FROM oficina;

-- 2 - Inserta un empleado para la oficina de Almería que sea representante de ventas
INSERT INTO empleado VALUES(32, 'Mauricio', 'Gomez', 'Gonzalez', 8374, 'mauri@jardineria.es', 'alm', 7, 'Representante Ventas');
SELECT * FROM empleado;

-- 3- Inserta un cliente que tenga como representante de ventas el empleado que hemos creado en el paso anterior.
INSERT INTO cliente VALUES(39, 'Amapolas para burundanga', 'Mohamed', ' Ahberracin', '746403947', '8374628374', 'sisi calle', null, 'Almeria', 'Andalucia', 'Spain', '82301', 32, 10);
SELECT * FROM cliente;

-- 4 - Inserte un pedido para el cliente que acabamos de crear, que contenga al menos dos productos diferentes.
INSERT INTO pedido VALUES();
SELECT * FROM pedido;
SELECT * FROM detalle_pedido;
-- 11 Modifica la tabla detalle_pedido para insertar un campo numérico llamado iva. 
-- Mediante una transacción, establece el valor de ese campo a 18 para aquellos 
-- registros cuyo pedido tenga fecha a partir de Enero de 2009. A continuación 
-- actualiza el resto de pedidos estableciendo el iva al 21
ALTER TABLE detalle_pedido ADD COLUMN iva smallint;
START TRANSACTION;
UPDATE detalle_pedido dp
JOIN pedido p ON dp.codigo_pedido = p.codigo_pedido
SET dp.iva = 18
WHERE p.fecha_pedido >= '2009-01-01';
UPDATE detalle_pedido dp
JOIN pedido p ON dp.codigo_pedido = p.codigo_pedido
SET dp.iva = 21
WHERE p.fecha_pedido < '2009-01-01';
COMMIT;

SELECT * FROM detalle_pedido;