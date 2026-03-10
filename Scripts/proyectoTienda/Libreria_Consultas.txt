USE mydb;

-- 1: Selección Simple con riltros
SELECT titulo, precio FROM Libro
WHERE precio > 15;
-- 2: Búsqueda con LIKE
SELECT nombre FROM Empleado
WHERE nombre LIKE "l%";
-- 3: Operadores Lógicos
SELECT (precio * 1.21) AS precio_iva FROM Libro;
-- 4: Agregación Básica
SELECT max(salario) FROM Empleado;
-- 5: GROUP BY Simple
SELECT añoPublicacion, count(*) AS libros_por_año FROM Libro
GROUP BY añoPublicacion;
-- 6: HAVING
SELECT idEditorial, count(*) FROM Libro
GROUP BY idEditorial
HAVING idEditorial = 1;
-- 7: DISTINCT
SELECT DISTINCT nombre FROM Empleado;
-- 8: Gestión de NULL
SELECT * FROM Pedido
WHERE metodoPago IS NOT NULL;
-- 9: Subconsulta Simple con IN
SELECT * FROM Editorial
WHERE idEditorial IN (
	SELECT idEditorial FROM Libro
);
-- 10: BETWEEN
SELECT * FROM Empleado
WHERE salario BETWEEN 1000 AND 1500;
-- 11: INNER JOIN Básico (dos tablas)
SELECT l.isbn, l.titulo, e.nombre FROM Libro l
JOIN Editorial e ON l.idEditorial = e.idEditorial;
-- 12: INNER JOIN Múltiple (tres tablas)
SELECT l.isbn, l.titulo, a.nombre, p.nombre FROM Libro l
JOIN Autor a ON a.idAutor = l.idAutor
JOIN Proveedor p ON p.idProveedor = l.idProveedor;
-- 13: LEFT JOIN
SELECT e.idEditorial, e.nombre, l.titulo FROM Editorial e
LEFT JOIN Libro l ON e.idEditorial = l.idEditorial;
-- 14: RIGHT JOIN
SELECT l.titulo, e.nombre FROM Libro l
RIGHT JOIN Editorial e ON l.idEditorial = e.idEditorial;
-- 15: SELF JOIN (tabla consigo misma)
SELECT DISTINCT e1.nombre FROM Empleado e1
JOIN Empleado e2 ON e1.idEmpleado = e2.supervisa;
-- 16: JOIN con Agregación
SELECT e.nombre, count(l.titulo) FROM Editorial e
JOIN Libro l ON l.idEditorial = e.idEditorial
GROUP BY e.nombre;
-- 17: JOIN con Condiciones Complejas
SELECT l.titulo, l.precio FROM Libro l
JOIN Editorial e ON e.idEditorial = l.idEditorial
WHERE e.nombre = 'Casa del Libro' 
AND l.precio BETWEEN 15 AND 20;
-- 18: JOIN con Subconsultas
SELECT c.nombre AS NombreCliente, c.email, compras.TotalGastado
FROM Cliente c
JOIN (
    SELECT idCliente, SUM(total) AS TotalGastado
    FROM Pedido
    GROUP BY idCliente
) AS compras ON c.idCliente = compras.idCliente;
-- 19: JOIN con Múltiples Condiciones
SELECT l.titulo AS Libro, a.nombre AS NombreAutor, a.apellidos AS ApellidoAutor, lib.localizacion AS Ubicacion
FROM Libro l
JOIN Autor a ON l.idAutor = a.idAutor
JOIN Libreria lib ON l.idLibreria = lib.idLibreria
WHERE l.stock > 10 
  AND lib.localizacion = 'Madrid Centro';
-- 20: Unión de Resultados (UNION)
SELECT nombre AS Nombre_Entidad, email AS Correo_Contacto, 'Cliente' AS Tipo
FROM Cliente
UNION
SELECT nombre, email, 'Editorial' AS Tipo
FROM Editorial
UNION
SELECT nombre, email, 'Proveedor' AS Tipo
FROM Proveedor;
-- 21: LEFT JOIN con Filtro Complejo
SELECT c.nombre AS Cliente, c.email, p.idPedido, p.total AS TotalPedido, p.fechaPedido
FROM Cliente c
LEFT JOIN Pedido p ON c.idCliente = p.idCliente AND p.total > 15
WHERE c.email LIKE '%@gmail.com%';
-- 22: Subconsulta en WHERE
SELECT titulo, precio, stock
FROM Libro
WHERE precio > (
    SELECT AVG(precio) 
    FROM Libro
);
-- 23: Subconsulta con IN
SELECT nombre, apellidos, nacionalidad
FROM Autor
WHERE idAutor IN (
    SELECT idAutor 
    FROM Libro 
    WHERE stock < 100
);
-- 24: Subconsulta con NOT IN
SELECT nombre, email, dni
FROM Cliente
WHERE idCliente NOT IN (
    SELECT idCliente 
    FROM Pedido
);
-- 25: Subconsulta con EXISTS
SELECT nombre, apellidos
FROM Autor a
WHERE EXISTS (
    SELECT 1
    FROM Libro l
    WHERE l.idAutor = a.idAutor
);
-- 26: Subconsulta con NOT EXISTS
SELECT idEmpleado, nombre, apellidos, cargo
FROM Empleado e
WHERE NOT EXISTS (
    SELECT 1
    FROM Libreria lib
    WHERE lib.idEmpleado = e.idEmpleado
);
-- 27: Subconsulta en FROM (Tabla Derivada)
SELECT c.nombre AS Cliente, metricas.PromedioGasto
FROM Cliente c
JOIN (
    SELECT idCliente, AVG(total) AS PromedioGasto
    FROM Pedido
    GROUP BY idCliente
) AS metricas ON c.idCliente = metricas.idCliente
WHERE metricas.PromedioGasto > 5;
-- 28: Subconsulta con ALL
SELECT nombre, apellidos, salario, fechaContratacion
FROM Empleado
WHERE salario > ALL (
    SELECT salario
    FROM Empleado
    WHERE fechaContratacion > '2026-02-01'
);
-- 29: Subconsulta con ANY/SOME
SELECT titulo, precio
FROM Libro
WHERE precio < ANY (
    SELECT l.precio
    FROM Libro l
    JOIN Autor a ON l.idAutor = a.idAutor
    WHERE a.nombre = 'William' AND a.apellidos = 'Shakespeare'
);
-- 30: Subconsultas Anidadas
SELECT nombre, apellidos
FROM Autor
WHERE idAutor IN (
    SELECT idAutor
    FROM Libro
    WHERE idLibro IN (
        SELECT idLibro
        FROM Cliente
        WHERE idCliente IN (
            SELECT idCliente
            FROM Pedido
            WHERE idPedido IN (
                SELECT idPedido 
                FROM Factura
            )
        )
    )
);

