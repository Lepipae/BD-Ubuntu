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




