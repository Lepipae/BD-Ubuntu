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

-- 1.1.6 Consultas resumen
-- 1.Calcula el número total de productos que hay en la tabla productos.
SELECT count(id) FROM producto;
-- 2.Calcula el número total de fabricantes que hay en la tabla fabricante.
SELECT count(id) FROM fabricante;
-- 3.Calcula el número de valores distintos de identificador de fabricante aparecen en la
-- tabla productos.
SELECT count(DISTINCT p.id_fabricante) FROM producto p;
-- 4.Calcula la media del precio de todos los productos.
SELECT avg(precio) FROM producto;
-- 5.Calcula el precio más barato de todos los productos.
SELECT min(precio) FROM producto;
-- 6.Calcula el precio más caro de todos los productos.
SELECT max(precio) FROM producto;
-- 7.Lista el nombre y el precio del producto más barato.
SELECT nombre, precio FROM producto
WHERE precio = (
	SELECT min(precio) FROM producto
);
-- 8.Lista el nombre y el precio del producto más caro.
SELECT nombre, precio FROM producto
WHERE precio = (
	SELECT max(precio) FROM producto
);
-- 9.Calcula la suma de los precios de todos los productos.
SELECT sum(precio) FROM producto;
-- 10.Calcula el número de productos que tiene el fabricante Asus.
SELECT count(p.id) FROM producto p 
JOIN fabricante f ON p.id_fabricante = f.id
GROUP BY f.nombre
HAVING f.nombre = "Asus";
-- 11.Calcula la media del precio de todos los productos del fabricante Asus.
SELECT avg(precio) FROM producto p 
JOIN fabricante f ON p.id_fabricante = f.id
GROUP BY f.nombre
HAVING f.nombre = "Asus";
-- 12.Calcula el precio más barato de todos los productos del fabricante Asus.
SELECT min(precio) FROM producto p 
JOIN fabricante f ON p.id_fabricante = f.id
GROUP BY f.nombre
HAVING f.nombre = "Asus";
-- 13.Calcula el precio más caro de todos los productos del fabricante Asus.
SELECT max(precio) FROM producto p 
JOIN fabricante f ON p.id_fabricante = f.id
GROUP BY f.nombre
HAVING f.nombre = "Asus";
-- 14.Calcula la suma de todos los productos del fabricante Asus.
SELECT sum(precio) FROM producto p 
JOIN fabricante f ON p.id_fabricante = f.id
GROUP BY f.nombre
HAVING f.nombre = "Asus";
-- 15.Muestra el precio máximo, precio mínimo, precio medio y el número total de
-- productos que tiene el fabricante Crucial.
SELECT max(precio), min(precio), avg(precio), count(p.id) FROM producto p 
JOIN fabricante f ON p.id_fabricante = f.id
GROUP BY f.nombre
HAVING f.nombre = "Crucial";
-- 16.Muestra el número total de productos que tiene cada uno de los fabricantes. El
-- listado también debe incluir los fabricantes que no tienen ningún producto. El
-- resultado mostrará dos columnas, una con el nombre del fabricante y otra con el
-- número de productos que tiene. Ordene el resultado descendentemente por el número
-- de productos.
SELECT f.nombre, count(p.id) AS numProducto FROM fabricante f 
LEFT JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.nombre
ORDER BY numProducto DESC;
-- 17.Muestra el precio máximo, precio mínimo y precio medio de los productos de cada
-- uno de los fabricantes. El resultado mostrará el nombre del fabricante junto con los
-- datos que se solicitan.
SELECT f.nombre, max(p.precio), min(p.precio), avg(p.precio) FROM fabricante f 
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.nombre;
-- 18.Muestra el precio máximo, precio mínimo, precio medio y el número total de
-- productos de los fabricantes que tienen un precio medio superior a 200€. No es
-- necesario mostrar el nombre del fabricante, con el identificador del fabricante es
-- suficiente.
SELECT f.id, max(p.precio), min(p.precio), avg(p.precio) AS media FROM fabricante f 
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.id
HAVING media > 200;
-- 19.Muestra el nombre de cada fabricante, junto con el precio máximo, precio mínimo,
-- precio medio y el número total de productos de los fabricantes que tienen un precio
-- medio superior a 200€. Es necesario mostrar el nombre del fabricante.
SELECT f.nombre, max(p.precio), min(p.precio), avg(p.precio) AS media, count(p.id) FROM fabricante f 
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.nombre
HAVING media > 200;
-- 20.Calcula el número de productos que tienen un precio mayor o igual a 180€.
SELECT count(id) FROM producto
WHERE precio >= 180;
-- 21.Calcula el número de productos que tiene cada fabricante con un precio mayor o
-- igual a 180€.
SELECT f.nombre, count(p.id) FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE p.precio >= 180
GROUP BY f.nombre;
-- 22.Lista el precio medio los productos de cada fabricante, mostrando solamente el
-- identificador del fabricante.
SELECT f.id, avg(p.precio) FROM fabricante f
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.id;
-- 23.Lista el precio medio los productos de cada fabricante, mostrando solamente el
-- nombre del fabricante.
SELECT f.nombre, avg(p.precio) FROM fabricante f
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.nombre;
-- 24.Lista los nombres de los fabricantes cuyos productos tienen un precio medio mayor
-- o igual a 150€.
SELECT f.nombre FROM fabricante f 
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.nombre
HAVING avg(precio) >= 150;
-- 25.Devuelve un listado con los nombres de los fabricantes que tienen 2 o más
-- productos.
SELECT f.nombre FROM fabricante f 
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.nombre
HAVING count(p.id) >= 2;
-- 26.Devuelve un listado con los nombres de los fabricantes y el número de productos
-- que tiene cada uno con un precio superior o igual a 220 €. No es necesario mostrar el
-- nombre de los fabricantes que no tienen productos que cumplan la condición.
SELECT f.nombre, count(p.id) FROM fabricante f 
JOIN producto p ON f.id = p.id_fabricante
WHERE p.precio >= 220
GROUP BY f.nombre;
-- 27.Devuelve un listado con los nombres de los fabricantes y el número de productos
-- que tiene cada uno con un precio superior o igual a 220 €. El listado debe mostrar el
-- nombre de todos los fabricantes, es decir, si hay algún fabricante que no tiene
-- productos con un precio superior o igual a 220€ deberá aparecer en el listado con un
-- valor igual a 0 en el número de productos.
SELECT f.nombre, count(p.id) FROM fabricante f 
LEFT JOIN producto p ON f.id = p.id_fabricante AND p.precio >= 220
GROUP BY f.nombre;
-- 28.Devuelve un listado con los nombres de los fabricantes donde la suma del precio de
-- todos sus productos es superior a 1000 €.
SELECT f.nombre FROM fabricante f
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.nombre
HAVING sum(p.precio) > 1000;
-- 29.Devuelve un listado con el nombre del producto más caro que tiene cada fabricante.
-- El resultado debe tener tres columnas: nombre del producto, precio y nombre del
-- fabricante. El resultado tiene que estar ordenado alfabéticamente de menor a mayor
-- por el nombre del fabricante.
SELECT p.nombre, p.precio, f.nombre FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id
WHERE p.precio = (
	SELECT max(precio) FROM producto p2
    WHERE p2.id_fabricante = f.id
)
ORDER BY f.nombre;












