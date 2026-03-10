DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda CHARACTER SET utf8mb4;
USE tienda;
CREATE TABLE fabricante (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);
CREATE TABLE producto (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
precio DOUBLE NOT NULL,
id_fabricante INT UNSIGNED NOT NULL,
FOREIGN KEY (id_fabricante) REFERENCES fabricante(id)
);
INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');
INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);
-- 1.1.4 Consultas multitabla (Composición interna)
-- 1.Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos.
SELECT p.nombre, p.precio, f.nombre FROM producto p 
JOIN fabricante f ON p.id_fabricante = f.id;
-- 2.Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos. Ordene el resultado por el nombre del fabricante, por orden alfabético.
SELECT p.nombre, p.precio, f.nombre FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
ORDER BY f.nombre;
-- 3.Devuelve una lista con el identificador del producto, nombre del producto, identificador del fabricante y nombre del fabricante, de todos los productos de la base de datos.
SELECT p.id, p.nombre, f.id, f.nombre FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id;
-- 4.Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato.
SELECT p.nombre, p.precio, f.nombre FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
ORDER BY p.precio
LIMIT 1;
-- 5.Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más caro.
SELECT p.nombre, p.precio, f.nombre FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
ORDER BY p.precio DESC
LIMIT 1;
-- 6.Devuelve una lista de todos los productos del fabricante Lenovo.
SELECT p.* FROM producto p
WHERE p.id_fabricante = 2;
-- o tambien
SELECT p.* FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre = "Lenovo";
-- 7.Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor que 200€.
SELECT p.* FROM producto p
WHERE p.id_fabricante = 6
AND p.precio > 200;
-- o tambien
SELECT p.* FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre = "Crucial"
AND p.precio > 200;
-- 8.Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-
-- Packardy Seagate. Sin utilizar el operador IN.
SELECT p.* FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre = "Asus" OR f.nombre = "Hewlett-Packard" OR f.nombre = "Seagate";
-- 9.Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-
-- Packardy Seagate. Utilizando el operador IN.
SELECT p.* FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre IN("Asus", "Hewlett-Packard", "Seagate");
-- 10.Devuelve un listado con el nombre y el precio de todos los productos de los
-- fabricantes cuyo nombre termine por la vocal e.
SELECT p.nombre, p.precio FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre LIKE "%e";
-- 11.Devuelve un listado con el nombre y el precio de todos los productos cuyo nombre
-- de fabricante contenga el carácter w en su nombre.
SELECT p.nombre, p.precio FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre LIKE "%w%";
-- 12.Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de
-- todos los productos que tengan un precio mayor o igual a 180€. Ordene el resultado
-- en primer lugar por el precio (en orden descendente) y en segundo lugar por el
-- nombre (en orden ascendente)
SELECT p.nombre, p.precio, f.nombre FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE p.precio >= 180
ORDER BY p.precio DESC, p.nombre ASC;
-- 13.Devuelve un listado con el identificador y el nombre de fabricante, solamente de
-- aquellos fabricantes que tienen productos asociados en la base de datos.
SELECT DISTINCT f.id, f.nombre FROM fabricante f
JOIN producto p ON f.id = p.id_fabricante; 
-- 1.1.5 Consultas multitabla (Composición externa)
-- 1.Devuelve un listado de todos los fabricantes que existen en la base de datos, junto
-- con los productos que tiene cada uno de ellos. El listado deberá mostrar también
-- aquellos fabricantes que no tienen productos asociados.
SELECT f.nombre, p.nombre FROM fabricante f
LEFT JOIN producto p ON f.id = p.id_fabricante;
-- 2.Devuelve un listado donde sólo aparezcan aquellos fabricantes que no tienen ningún
-- producto asociado.
SELECT f.nombre, p.nombre FROM fabricante f
LEFT JOIN producto p ON f.id = p.id_fabricante
WHERE p.nombre IS NULL;
-- 3.¿Pueden existir productos que no estén relacionados con un fabricante? Justifique su
-- respuesta.
-- No porque id_fabricante en la tabla producto no puede ser null





