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

-- Ejercicio 1: Vista simple
-- Crea una vista llamada vista_productoss que muestre:
-- • id producto
-- • nombre
-- • precio
DROP VIEW IF EXISTS vistaSimple;
CREATE VIEW vistaSimple AS
	SELECT id, nombre, precio FROM producto;
-- Ejercicio 2: Vista con filtro
-- Crea una vista llamada productos_mas_150 que muestre solo los productos con precio mayor
-- a 150€
DROP VIEW IF EXISTS  vistaFiltro;
CREATE VIEW vistaFiltro AS
	SELECT * FROM producto
    WHERE precio > 150;
-- Ejercicio 3: Vista con columnas renombradas
-- Crea una vista llamada productos_resumen donde:
-- • nombre se muestre como nombre_producto
-- • precio se muestre como precio_eur
DROP VIEW  IF EXISTS vistaRenombre;
CREATE VIEW vistaRenombre AS
	SELECT nombre AS nombre_producto, precio AS precio_eur FROM producto;
-- Ejercicio 4: Vista con JOIN
-- Crea una vista llamada vista_productos_lenovo que muestre:
-- • nombre del producto
-- • precio del producto
-- para los productos del fabricante “Lenovo”
DROP VIEW  IF EXISTS vistaJoin;
CREATE VIEW vistaJoin AS
	SELECT p.nombre, p.precio FROM producto p 
    JOIN fabricante f ON p.id_fabricante = f.id
    WHERE f.nombre = "Lenovo";
-- Ejercicio 5: Vista con cálculos
-- Crea una vista llamada productos_con_iva que muestre:
-- • id del producto
-- • precio
-- • precio con IVA (21%)
DROP VIEW  IF EXISTS vistaCalculo;
CREATE VIEW vistaCalculo AS
	SELECT id, precio, precio * 1.21 AS precio_iva FROM producto;
-- Ejercicio 6: Vista con agregación
-- Crea una vista llamada total_productos_por_fabricante que muestre:
-- • nombre del fabricante
-- • cuantos productos hay de ese fabricante
DROP VIEW  IF EXISTS vistaAgrega;
CREATE VIEW vistaAgrega AS
	SELECT count(p.id), f.nombre FROM producto p
    JOIN fabricante f ON p.id_fabricante = f.id
    GROUP BY f.nombre;
-- Ejercicio 7: Vista con HAVING
-- Usando la vista anterior o directamente las tablas, crea una vista que muestre solo los fabricante
-- con más de un producto
DROP VIEW  IF EXISTS vistaHaving;
CREATE VIEW vistaHaving AS
	SELECT f.nombre, count(p.id) FROM producto p 
    JOIN fabricante f ON p.id_fabricante = f.id
    GROUP BY f.nombre
    HAVING count(p.id) > 1;

SELECT * FROM vistaSimple;
SELECT * FROM vistaFiltro;
SELECT * FROM vistaRenombre;
SELECT * FROM vistaJoin;
SELECT * FROM vistaCalculo;
SELECT * FROM vistaAgrega;
SELECT * FROM vistaHaving;


