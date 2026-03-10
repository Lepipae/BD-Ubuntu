
-- 1 Inserta una nueva oficina en Almería.
SELECT * FROM oficina;
INSERT INTO oficina VALUES('ALM-ES', 'Almeria', 'España', 'Andalucia', '92830', '+34 657637746', 'Calle Calla, 67', NULL);
-- 2 Inserta un empleado para la oficina de Almería que sea representante de ventas.
SELECT * FROM empleado;
INSERT INTO empleado VALUES(32, 'Carlos', 'Carlingos', NULL, '8475', 'carlosCarlis@jardineria.es', 'ALM-ES', 3, 'Representante Ventas');
-- 3 Inserta un cliente que tenga como representante de ventas el empleado que hemos creado en el paso anterior.
SELECT * FROM cliente;
INSERT INTO cliente VALUES(39, 'Vegetales Felices', 'Miguel', 'Felices', '847758857', '758473836', 'c/ Bolivia ay ay', 'sissisisii', 'Almeria', 'Andalucia', 'Spain', '65748', 32, 67);
-- 4 Inserte un pedido para el cliente que acabamos de crear, que contenga al menos dos productos diferentes.
SELECT * FROM pedido;
INSERT INTO pedido VALUES(129, '2026-01-28', '2026-02-10', '2026-02-05', 'Entregado', NULL, 39);
SELECT * FROM detalle_pedido;
INSERT INTO detalle_pedido VALUES(129, 'FR-67', 2, 20, 2);
INSERT INTO detalle_pedido VALUES(129, 'OR-127', 6, 67, 4);
-- 5 Actualiza el código del cliente que hemos creado en el paso anterior y averigua si hubo cambios en las tablas relacionadas.
-- SELECT * FROM cliente;
-- UPDATE cliente
-- SET codigo_cliente = 40
-- WHERE codigo_cliente = 39;
-- Seria asi si tuviese un ON UPDATE CASCADE al no tener un ON UPDATE CASCADE tendremos que crear la entrada nosotros
INSERT INTO cliente 
VALUES(40, 'Vegetales Felices', 'Miguel', 'Felices', '847758857', '758473836', 'c/ Bolivia ay ay', 'sissisisii', 'Almeria', 'Andalucia', 'Spain', '65748', 32, 67);
UPDATE pedido
SET codigo_cliente = 40
WHERE codigo_cliente = 39;
DELETE FROM cliente
WHERE codigo_cliente = 39;
-- 6 Borra el cliente y averigua si hubo cambios en las tablas relacionadas.
-- DELETE FROM cliente
-- WHERE codigo_cliente = 40;
-- Seria asi si tuviera un ON DELETE CASCADE o un ON DELETE SET NULL al no tenerlo hay que borrar las entradas asociadas
DELETE FROM detalle_pedido WHERE codigo_pedido = 129;
DELETE FROM pedido WHERE codigo_cliente = 40;
DELETE FROM cliente WHERE codigo_cliente = 40;
-- 7 Elimina los clientes que no hayan realizado ningún pedido.
DELETE FROM cliente
WHERE codigo_cliente NOT IN (
	SELECT codigo_cliente FROM pedido
);
-- 8 Incrementa en un 20% el precio de los productos que no tengan pedidos.
SELECT * FROM detalle_pedido;
SELECT * FROM producto;
UPDATE producto
SET precio_venta = precio_venta * 1.2
WHERE codigo_producto NOT IN (
	SELECT codigo_producto FROM detalle_pedido
);
-- 9 Borra los pagos del cliente con menor límite de crédito.
SELECT * FROM pago;
SELECT * FROM cliente;
DELETE FROM pago
WHERE codigo_cliente IN (
	SELECT codigo_cliente FROM cliente
    WHERE limite_credito = (
		SELECT min(limite_credito) FROM cliente
    )
);
-- 10 Establece a 0 el límite de crédito del cliente que menos unidades pedidas tenga del producto 11679.
SELECT * FROM producto;
SELECT * FROM detalle_pedido;
SELECT * FROM pedido;
UPDATE cliente
SET limite_credito = 0
WHERE codigo_cliente IN (
    SELECT p.codigo_cliente
    FROM pedido p
    JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
    WHERE dp.codigo_producto = '11679'
    GROUP BY p.codigo_cliente
    HAVING SUM(dp.cantidad) <= ALL (
        SELECT SUM(dp2.cantidad)
        FROM pedido p2
        JOIN detalle_pedido dp2 ON p2.codigo_pedido = dp2.codigo_pedido
        WHERE dp2.codigo_producto = '11679'
        GROUP BY p2.codigo_cliente
    )
);
-- 11 Modifica la tabla detalle_pedido para insertar un campo numérico llamado iva. Mediante una transacción, 
-- establece el valor de ese campo a 18 para aquellos registros cuyo pedido tenga fecha a partir de Enero de 2009. 
-- A continuación actualiza el resto de pedidos estableciendo el iva al 21.
ALTER TABLE detalle_pedido
ADD COLUMN iva INT;
START TRANSACTION;
UPDATE detalle_pedido
SET iva = 18;
UPDATE detalle_pedido
JOIN pedido p ON p.codigo_pedido = detalle_pedido.codigo_pedido
SET iva = 21
WHERE fecha_pedido >= '2009-01-01';
COMMIT;
-- 12 Modifica la tabla detalle_pedido para incorporar un campo numérico llamado total_linea y actualiza todos sus registros para calcular su valor con la fórmula:
-- total_linea = precio_unidad*cantidad * (1 + (iva/100));
SELECT * FROM detalle_pedido;
ALTER TABLE detalle_pedido
ADD COLUMN total_linea DOUBLE;
UPDATE detalle_pedido 
SET total_linea = precio_unidad * cantidad * (1+(iva/100));
-- 13 Borra el cliente que menor límite de crédito tenga. ¿Es posible borrarlo solo con una consulta? ¿Por qué?
DELETE FROM cliente
ORDER BY limite_credito ASC
LIMIT 1;
-- 14 Inserta una oficina con sede en Granada y tres empleados que sean representantes de ventas.
SELECT * FROM oficina;
SELECT * FROM empleado;
INSERT INTO oficina VALUES('GRA-ES', 'Granada', 'España', 'Andalucia', '65839', '+34 737746958', 'Callecita Bonitaa', NULL);
INSERT INTO empleado VALUES(33, 'Carlos', 'Manuel', NULL, '8726', 'carlosManue@jardineria.es', 'GRA-ES', 3, 'Representante Ventas');
INSERT INTO empleado VALUES(34, 'Paco', 'Paquez', NULL, '8846', 'pacoPaquez@jardineria.es', 'GRA-ES', 3, 'Representante Ventas');
INSERT INTO empleado VALUES(35, 'Mauricio', 'Maurin', NULL, '9182', 'mauricioMaurin@jardineria.es', 'GRA-ES', 3, 'Representante Ventas');
-- 15 Inserta tres clientes que tengan como representantes de ventas los empleados que hemos creado en el paso anterior.
SELECT * FROM cliente;
INSERT INTO cliente 
VALUES(50, 'no me sale un nombre', 'Alex', 'El capo', '847758857', '928394859', 'avenida sisi', 'nononono', 'Granada', 'Andalucia', 'Spain', '83647', 33, 67000);
INSERT INTO cliente 
VALUES(51, 'sigue sin salirme', 'Tonacho', 'Preston', '847594736', '826392719', 'callecitaaaa', 'tal vez', 'Granada', 'Andalucia', 'Spain', '93048', 34, 67888);
INSERT INTO cliente 
VALUES(52, 'todavia no', 'Chincheto', 'Chinchetez', '928364856', '635374828', 'glorieta glorias', 'no pues no', 'Granada', 'Andalucia', 'Spain', '93847', 35, 67555);
-- 16 Realiza una transacción que inserte un pedido para cada uno de los clientes. Cada pedido debe incluir dos productos.
select * from pedido;
START TRANSACTION;
INSERT INTO pedido VALUES(140, '2026-01-28', '2026-02-10', '2026-02-05', 'Entregado', NULL, 50);
SELECT * FROM detalle_pedido;
INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)VALUES(140, 'FR-67', 2, 20, 2);
INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)VALUES(140, 'OR-127', 6, 67, 4);
INSERT INTO pedido VALUES(141, '2026-01-28', '2026-02-10', '2026-02-05', 'Entregado', NULL, 51);
SELECT * FROM detalle_pedido;
INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)VALUES(141, 'FR-67', 2, 20, 2);
INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)VALUES(141, 'OR-127', 6, 67, 4);
INSERT INTO pedido VALUES(142, '2026-01-28', '2026-02-10', '2026-02-05', 'Entregado', NULL, 52);
SELECT * FROM detalle_pedido;
INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)VALUES(142, 'FR-67', 2, 20, 2);
INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)VALUES(142, 'OR-127', 6, 67, 4);
COMMIT;
-- 17 Borra uno de los clientes y comprueba si hubo cambios en las tablas relacionadas. Si no hubo cambios, modifica 
-- las tablas necesarias estableciendo la clave foránea con la cláusula ON DELETE CASCADE.
DELETE FROM cliente 
WHERE codigo_cliente = 52;
-- 18 Realiza una transacción que realice los pagos de los pedidos que han realizado los clientes del ejercicio anterior.
SELECT * FROM pago;
INSERT INTO pago VALU





