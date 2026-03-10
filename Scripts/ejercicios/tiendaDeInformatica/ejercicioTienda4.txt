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

-- 1.1.7 Subconsultas (En la cláusula WHERE)
-- 1.1.7.1 Con operadores básicos de comparación
-- 1.Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT * FROM producto
WHERE id_fabricante = (
	SELECT id FROM fabricante
    WHERE nombre = "Lenovo"
);
-- 2.Devuelve todos los datos de los productos que tienen el mismo precio que el
-- producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT p.* FROM producto p 
WHERE p.precio = (
	SELECT max(p2.precio) FROM producto p2
    WHERE id_fabricante = (
		SELECT id FROM fabricante f
        WHERE f.nombre = "Lenovo"
    )
);
-- 3.Lista el nombre del producto más caro del fabricante Lenovo.
SELECT p.nombre FROM producto p 
WHERE p.precio = (
	SELECT max(p2.precio) FROM producto p2
    WHERE id_fabricante = (
		SELECT id FROM fabricante f
        WHERE f.nombre = "Lenovo"
    )
)
AND p.id_fabricante = (
	SELECT id FROM fabricante
    WHERE nombre = "Lenovo"
);

-- 4.Lista el nombre del producto más barato del fabricante Hewlett-Packard.
SELECT p.nombre FROM producto p 
WHERE p.precio = (
	SELECT min(p2.precio) FROM producto p2
    WHERE id_fabricante = (
		SELECT id FROM fabricante f
        WHERE f.nombre = "Hewlett-Packard"
    )
)
AND p.id_fabricante = (
	SELECT id FROM fabricante
    WHERE nombre = "Hewlett-Packard"
);
-- 5.Devuelve todos los productos de la base de datos que tienen un precio mayor o igual
-- al producto más caro del fabricante Lenovo.
SELECT p.* FROM producto p
WHERE p.precio >= (
	SELECT max(p2.precio) FROM producto p2
    WHERE id_fabricante = (
		SELECT id FROM fabricante f 
        where f.nombre = "Lenovo"
    )
);
-- 6.Lista todos los productos del fabricante Asus que tienen un precio superior al precio
-- medio de todos sus productos.
SELECT p.* FROM producto p
WHERE p.id_fabricante = (
	SELECT f.id FROM fabricante f 
    WHERE f.nombre = "Asus"
) AND
p.precio > (
	SELECT avg(p2.precio) FROM producto p2
    WHERE p2.id_fabricante = (
		SELECT f2.id FROM fabricante f2
        WHERE f2.nombre = "Asus"
    )
);
-- 1.1.7.2 Subconsultas con ALL y ANY
-- 7.Devuelve el producto más caro que existe en la tabla producto sin hacer uso
-- de MAX, ORDER BY ni LIMIT.
SELECT * FROM producto
WHERE precio >= ALL(
	SELECT precio FROM producto
);
-- 8.Devuelve el producto más barato que existe en la tabla producto sin hacer uso
-- de MIN, ORDER BY ni LIMIT.
SELECT * FROM producto
WHERE precio <= ALL(
	SELECT precio FROM producto
);
-- 9.Devuelve los nombres de los fabricantes que tienen productos asociados.
-- (Utilizando ALL o ANY).
SELECT f.nombre FROM fabricante f
WHERE f.id = ANY(
	SELECT id_fabricante FROM producto
    WHERE id_fabricante IS NOT NULL
);
-- 10.Devuelve los nombres de los fabricantes que no tienen productos asociados.
-- (Utilizando ALL o ANY).
SELECT f.nombre FROM fabricante f
WHERE id != ALL(
	SELECT id_fabricante FROM producto
    WHERE id_fabricante IS NOT NULL
);
-- 1.1.7.3 Subconsultas con IN y NOT IN
-- 11.Devuelve los nombres de los fabricantes que tienen productos asociados.
-- (Utilizando IN o NOT IN).
SELECT f.nombre FROM fabricante f
WHERE f.id IN (
	SELECT p.id_fabricante FROM producto p
);
-- 12.Devuelve los nombres de los fabricantes que no tienen productos asociados.
-- (Utilizando IN o NOT IN).
SELECT f.nombre FROM fabricante f
WHERE f.id NOT IN (
	SELECT p.id_fabricante FROM producto p
);
-- 1.1.7.4 Subconsultas con EXISTS y NOT EXISTS
-- 13.Devuelve los nombres de los fabricantes que tienen productos asociados.
-- (Utilizando EXISTS o NOT EXISTS).
SELECT f.nombre FROM fabricante f
WHERE EXISTS (
	SELECT p.* FROM producto p
    WHERE p.id_fabricante = f.id
);
-- 14.Devuelve los nombres de los fabricantes que no tienen productos asociados.
-- (Utilizando EXISTS o NOT EXISTS).
SELECT f.nombre FROM fabricante f
WHERE NOT EXISTS (
	SELECT p.* FROM producto p
    WHERE p.id_fabricante = f.id
);
-- 1.1.7.5 Subconsultas correlacionadas
-- 15.Lista el nombre de cada fabricante con el nombre y el precio de su producto más
-- caro.
SELECT f.nombre, max(p.precio) FROM fabricante f
JOIN producto p ON f.id = p.id_fabricante
GROUP BY f.nombre;
-- 16.Devuelve un listado de todos los productos que tienen un precio mayor o igual a la
-- media de todos los productos de su mismo fabricante.
SELECT p.* FROM producto p
WHERE p.precio >= (
	SELECT avg(p2.precio) FROM producto p2
    WHERE p2.id_fabricante = p.id_fabricante
);
-- 17.Lista el nombre del producto más caro del fabricante Lenovo
SELECT p.nombre FROM producto p
WHERE p.precio = (
	SELECT max(p2.precio) FROM producto p2
	JOIN fabricante f ON p2.id_fabricante = f.id
    WHERE f.nombre = "Lenovo"
)
AND p.id_fabricante = (
	SELECT id FROM fabricante
    WHERE nombre = "Lenovo"
);








