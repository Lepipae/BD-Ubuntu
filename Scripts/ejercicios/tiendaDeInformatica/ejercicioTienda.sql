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

-- 1.Lista el nombre de todos los productos que hay en la tabla producto.
SELECT nombre FROM producto;
-- 2.Lista los nombres y los precios de todos los productos de la tabla producto.
SELECT nombre, precio FROM producto;
-- 3.Lista todas las columnas de la tabla producto.
SELECT * FROM producto;
-- 4.Lista el nombre de los productos, el precio en euros y el precio en dólares
-- estadounidenses (USD).
SELECT nombre,
precio AS precio_euros,
precio * 1.1 AS precio_dolares
FROM producto;
-- 5.Lista el nombre de los productos, el precio en euros y el precio en dólares
-- estadounidenses (USD). Utiliza los siguientes alias para las columnas: nombre de
-- producto, euros, dólares.
SELECT nombre AS "nombre de producto",
precio AS euros,
precio * 1.1 AS dolares
FROM producto;
-- 6.Lista los nombres y los precios de todos los productos de la tabla producto,
-- convirtiendo los nombres a mayúscula.
SELECT ucase(nombre), precio
FROM producto;
-- 7.Lista los nombres y los precios de todos los productos de la tabla producto,
-- convirtiendo los nombres a minúscula.
SELECT lcase(nombre), precio FROM producto;
-- 8.Lista el nombre de todos los fabricantes en una columna, y en otra columna obtenga
-- en mayúsculas los dos primeros caracteres del nombre del fabricante.
SELECT nombre, upper(substring(nombre, 1, 2)) FROM fabricante;
-- 9.Lista los nombres y los precios de todos los productos de la tabla producto,
-- redondeando el valor del precio.
SELECT nombre, round(precio) FROM producto;
-- 10.Lista los nombres y los precios de todos los productos de la tabla producto,
-- truncando el valor del precio para mostrarlo sin ninguna cifra decimal.
SELECT nombre, truncate(precio, 0) FROM producto;
-- 11.Lista el identificador de los fabricantes que tienen productos en la tabla producto.
SELECT id_fabricante FROM fabricante JOIN producto ON producto.id_fabricante = fabricante.id;
-- 12.Lista el identificador de los fabricantes que tienen productos en la tabla producto,
-- eliminando los identificadores que aparecen repetidos.
SELECT DISTINCT id_fabricante FROM fabricante JOIN producto ON producto.id_fabricante = fabricante.id;
-- 13.Lista los nombres de los fabricantes ordenados de forma ascendente.
SELECT nombre FROM fabricante ORDER BY nombre ASC;
-- 14.Lista los nombres de los fabricantes ordenados de forma descendente.
SELECT nombre FROM fabricante ORDER BY nombre DESC;
-- 15.Lista los nombres de los productos ordenados en primer lugar por el nombre de
-- forma ascendente y en segundo lugar por el precio de forma descendente.
SELECT nombre FROM producto ORDER BY nombre ASC, precio DESC;
-- 16.Devuelve una lista con las 5 primeras filas de la tabla fabricante
SELECT * FROM fabricante LIMIT 5;
-- 17.Devuelve una lista con 2 filas a partir de la cuarta fila de la tabla fabricante. La cuarta
-- fila también se debe incluir en la respuesta.
SELECT * FROM fabricante LIMIT 3, 2;
-- 18.Lista el nombre y el precio del producto más barato. (Utilice solamente las
-- cláusulas ORDER BY y LIMIT)
SELECT nombre, precio FROM producto ORDER BY precio ASC LIMIT 1;
-- 19.Lista el nombre y el precio del producto más caro. (Utilice solamente las
-- cláusulas ORDER BY y LIMIT)
SELECT nombre, precio FROM producto ORDER BY precio DESC LIMIT 1;
-- 20.Lista el nombre de todos los productos del fabricante cuyo identificador de
-- fabricante es igual a 2.
SELECT producto.nombre FROM producto JOIN fabricante ON producto.id_fabricante = fabricante.id WHERE fabricante.id = 2;
-- 21.Lista el nombre de los productos que tienen un precio menor o igual a 120€.
SELECT nombre FROM producto WHERE precio <= 120;
-- 22.Lista el nombre de los productos que tienen un precio mayor o igual a 400€.
SELECT nombre FROM producto WHERE precio >= 400;
-- 23.Lista el nombre de los productos que no tienen un precio mayor o igual a 400€.
SELECT nombre FROM producto WHERE NOT precio >= 400;
-- 24.Lista todos los productos que tengan un precio entre 80€ y 300€. Sin utilizar el
-- operador BETWEEN.
SELECT nombre FROM producto WHERE precio >= 80
AND precio <= 300;
-- 25.Lista todos los productos que tengan un precio entre 60€ y 200€. Utilizando el
-- operador BETWEEN.
SELECT nombre, precio FROM producto WHERE precio BETWEEN 60 AND 200;
-- 26.Lista todos los productos que tengan un precio mayor que 200€ y que el
-- identificador de fabricante sea igual a 6.
SELECT * FROM producto WHERE id_fabricante = 6 
AND precio >= 200;
-- 27.Lista todos los productos donde el identificador de fabricante sea 1, 3 o 5. Sin
-- utilizar el operador IN.
SELECT * FROM producto WHERE id_fabricante = 1 
OR id_fabricante = 3 
OR id_fabricante = 5;
-- 28.Lista todos los productos donde el identificador de fabricante sea 1, 3 o 5. Utilizando
-- el operador IN.
SELECT * FROM producto WHERE id_fabricante IN (1,3,5);
-- 29.Lista el nombre y el precio de los productos en céntimos (Habrá que multiplicar por
-- 100 el valor del precio). Cree un alias para la columna que contiene el precio que se
-- llame céntimos
SELECT nombre, precio * 100 AS centimos FROM producto;
-- 30.Lista los nombres de los fabricantes cuyo nombre empiece por la letra S.
SELECT nombre FROM fabricante 
WHERE nombre LIKE "S%";
-- 31.Lista los nombres de los fabricantes cuyo nombre termine por la vocal e.
SELECT nombre FROM fabricante
WHERE nombre LIKE "%e";
-- 32.Lista los nombres de los fabricantes cuyo nombre contenga el carácter w.
SELECT nombre FROM fabricante
WHERE nombre LIKE "%w%";
-- 33.Lista los nombres de los fabricantes cuyo nombre sea de 4 caracteres.
SELECT nombre FROM fabricante
WHERE char_length(nombre) = 4;
-- 34.Devuelve una lista con el nombre de todos los productos que contienen la
-- cadena Portátil en el nombre.
SELECT nombre FROM producto
WHERE nombre LIKE "%portátil%";
-- 35.Devuelve una lista con el nombre de todos los productos que contienen la
-- cadena Monitor en el nombre y tienen un precio inferior a 215 €.
SELECT nombre FROM producto
WHERE nombre LIKE "%monitor%" 
AND precio < 215;
-- 36.Lista el nombre y el precio de todos los productos que tengan un precio mayor o
-- igual a 180€. Ordene el resultado en primer lugar por el precio (en orden descendente)
-- y en segundo lugar por el nombre (en orden ascendente).
SELECT nombre, precio FROM producto
WHERE precio >= 180
ORDER BY precio DESC, nombre ASC;

ALTER TABLE producto CHANGE column precio precioCoste DOUBLE NOT NULL;
ALTER TABLE producto ADD precioVenta DOUBLE NOT NULL;
ALTER TABLE producto ADD iva DOUBLE NOT NULL;
UPDATE producto SET precioVenta = precioCoste * 2 where id between 1 and 5;
UPDATE producto SET precioVenta = precioCoste * 1.5 where id between 6 and 9;
UPDATE producto SET iva = 10.00 where id between 1 and 5;
UPDATE producto SET iva = 21.00 where id between 6 and 9;
SELECT * FROM producto;

-- a. Mostrar cuántos productos hay cuyo precio de coste sea menor o igual que la mitad del precio de venta.
SELECT COUNT(*) FROM producto 
WHERE precioCoste <= (precioVenta/2);
-- b. Mostrar el precio más caro de los productos con IVA del 10%
SELECT precioVenta FROM producto
WHERE iva = 10
ORDER BY precioVenta
LIMIT 1;
-- c. Mostrar el precio más barato de los productos
SELECT precioVenta, nombre FROM producto
ORDER BY precioVenta ASC LIMIT 1;
-- d. Contar cuantos productos son del fabricante con id valor 6 tienen un precio de coste menor o igual a la mitad del precio de venta
SELECT COUNT(nombre) FROM producto
WHERE id_fabricante = 6
AND precioCoste <= (precioVenta/2);
-- e. Mostrar la media del precio de coste de los productos del fabricante con id valor 6
SELECT avg(precioCoste) FROM producto
WHERE id_fabricante = 6;
-- f. Mostrar la media de la ganancia de los productos del fabricante con id valor 6
SELECT avg((precioVenta-precioCoste)) FROM producto
WHERE id_fabricante = 6;





