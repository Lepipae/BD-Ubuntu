USE tienda;
-- 1 - Inserta un nuevo fabricante indicando su código y su nombre.
INSERT INTO fabricante VALUES(10, "Motorola"); 
SELECT * FROM fabricante;
-- 2 - Inserta un nuevo fabricante indicando solamente su nombre.
INSERT INTO fabricante (nombre) VALUES("ROG");
SELECT * FROM fabricante;
-- 3 - Inserta un nuevo producto asociado a uno de los nuevos fabricantes. 
-- La sentencia de inserción debe incluir: código, nombre, precio y código_fabricante.
INSERT INTO producto VALUES(12, "Telefono Carpintero", 67.80, 10);
SELECT * FROM producto;
-- 4 - Inserta un nuevo producto asociado a uno de los nuevos fabricantes. 
-- La sentencia de inserción debe incluir: nombre, precio y código_fabricante.
INSERT INTO producto (nombre, precio, id_fabricante) 
VALUES("Telefono no carpintero", 69.67, 11);
SELECT * FROM producto;
-- 5 - Crea una nueva tabla con el nombre fabricante_productos que tenga las siguientes 
-- columnas: nombre_fabricante, nombre_producto y precio. Una vez creada la tabla inserta 
-- todos los registros de la base de datos tienda en esta tabla haciendo uso de única operación de inserción.
CREATE TABLE fabricante_productos (
nombreFabricante VARCHAR(100) NOT NULL,
nombreProducto VARCHAR(100) NOT NULL,
precio DOUBLE NOT NULL
);
INSERT INTO fabricante_productos (nombreFabricante, nombreProducto, precio)
SELECT f.nombre, p.nombre, p.precio FROM fabricante f
JOIN producto p ON p.id_fabricante = f.id;
SELECT * FROM fabricante_productos;
-- 6 - Crea una vista con el nombre vista_fabricante_productos que tenga las siguientes columnas: nombre_fabricante, nombre_producto y precio.
CREATE VIEW vista_fabricante_productos AS
SELECT f.nombre AS nombreFabricante, p.nombre AS nombreProducto, p.precio AS precio FROM producto p
JOIN fabricante f ON f.id = p.id_fabricante;
SELECT * FROM vista_fabricante_productos;
-- 7 - Elimina el fabricante Asus. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE FROM producto
WHERE id_fabricante = (
SELECT id FROM fabricante WHERE nombre = 'Asus'
);
DELETE FROM fabricante 
WHERE nombre = 'Asus';
SELECT * FROM fabricante;
-- 8 - Elimina el fabricante Xiaomi. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE FROM producto 
WHERE id_fabricante = (
	SELECT id FROM fabricante
    WHERE nombre = 'Xiaomi'
);
DELETE FROM fabricante
WHERE nombre = 'Xiaomi';
SELECT * FROM fabricante;
-- 9 - Actualiza el código del fabricante Lenovo y asígnale el valor 20. 
-- ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo?
UPDATE fabricante 
SET id = 20
WHERE nombre = 'Lenovo';
SELECT * FROM fabricante;
-- 10 - Actualiza el código del fabricante Huawei y asígnale el valor 30. 
-- ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo?
UPDATE fabricante
SET id = 30
WHERE nombre = 'Huawei';
-- 11 - Actualiza el precio de todos los productos sumándole 5 € al precio actual.
UPDATE producto
SET precio = precio + 5;
SELECT * FROM producto;
-- 12 - Elimina todas las impresoras que tienen un precio menor de 200 €.
DELETE FROM producto 
WHERE nombre LIKE 'Impresora%'
AND precio < 200;
SELECT * FROM producto;


