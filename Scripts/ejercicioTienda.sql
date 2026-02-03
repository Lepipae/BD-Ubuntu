-- Ejercicio 1
SELECT p.nombre, p.precio, f.nombre 
FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id;
-- Ejercicio 2
SELECT p.nombre, p.precio, f.nombre 
FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
ORDER BY f.nombre ASC;
-- Ejercicio 3
SELECT p.id, p.nombre, f.id, f.nombre 
FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id;
-- Ejercicio 4
SELECT p.nombre, p.precio, f.nombre 
FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
ORDER BY p.precio ASC
LIMIT 1;
-- Ejercicio 5
SELECT p.nombre, p.precio, f.nombre 
FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
ORDER BY p.precio DESC
LIMIT 1;
-- Ejercicio 6
SELECT p.* FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre = 'Lenovo';
-- Ejercicio 7
SELECT p.* FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre = 'Crucial' AND p.precio > 200;
-- Ejercicio 8
SELECT p.* FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre = 'Asus' OR f.nombre = 'Hewlett-Packard' OR f.nombre = 'Seagate';
-- Ejercicio 9
SELECT p.* FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre IN ('Asus', 'Hewlett-Packard', 'Seagate');
-- Ejercicio 10
SELECT p.nombre, p.precio 
FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre LIKE '%e';
-- Ejercicio 11
SELECT p.nombre, p.precio 
FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
WHERE f.nombre LIKE '%w%';
-- Ejercicio 12
SELECT p.nombre, p.precio, f.nombre 
FROM producto p 
INNER JOIN fabricante f ON p.id_fabricante = f.id
WHERE p.precio >= 180
ORDER BY p.precio DESC, p.nombre ASC;
-- Ejercicio 13
SELECT DISTINCT f.id, f.nombre 
FROM fabricante f 
INNER JOIN producto p ON f.id = p.id_fabricante;


SELECT f.nombre
FROM 