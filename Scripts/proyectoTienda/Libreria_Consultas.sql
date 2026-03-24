USE mydb;

-- 1: Selección Simple con filtros
-- Muestra el título y el precio de aquellos libros que cuestan más de 15 Euros.
SELECT l.titulo, pr.Valor AS precio 
FROM Libro l
JOIN Precio pr ON l.idLibro = pr.idLibro
WHERE pr.Valor > 15;

-- 2: Búsqueda con LIKE
-- Busca el nombre de los empleados que empiezan por la letra 'l'.
SELECT nombre FROM Empleado
WHERE nombre LIKE 'l%';

-- 3: Operadores Lógicos
-- Calcula y muestra el precio con el IVA (21%) aplicado para todos los libros.
SELECT l.titulo, (pr.Valor * 1.21) AS precio_iva 
FROM Libro l
JOIN Precio pr ON l.idLibro = pr.idLibro;

-- 4: Agregación Básica
-- Devuelve el salario más alto de todos los empleados.
SELECT max(salario) FROM Empleado;

-- 5: GROUP BY Simple
-- Agrupa los libros por su año de publicación y los cuenta.
SELECT añoPublicacion, count(*) AS libros_por_año FROM Libro
GROUP BY añoPublicacion;

-- 6: HAVING
-- Cuenta el número de libros asociados a la editorial que tiene el ID 1.
SELECT idEditorial, count(*) FROM Libro
GROUP BY idEditorial
HAVING idEditorial = 1;

-- 7: DISTINCT
-- Lista los nombres de los empleados eliminando los valores duplicados.
SELECT DISTINCT nombre FROM Empleado;

-- 8: Gestión de NULL
-- Extrae los empleados que tienen un jefe asignado
SELECT * FROM Empleado
WHERE Supervisa IS NOT NULL;

-- 9: Subconsulta Simple con IN
-- Selecciona todas las editoriales que tienen asociado al menos un libro.
SELECT * FROM Editorial
WHERE idEditorial IN (
	SELECT idEditorial FROM Libro
);

-- 10: BETWEEN
-- Busca a los empleados cuyo salario se encuentra en el rango de 1000 a 1500.
SELECT * FROM Empleado
WHERE salario BETWEEN 1000 AND 1500;

-- 11: INNER JOIN Básico (dos tablas)
-- Muestra el ISBN y título del libro junto al nombre de la editorial a la que pertenece.
SELECT l.isbn, l.titulo, e.nombre FROM Libro l
JOIN Editorial e ON l.idEditorial = e.idEditorial;

-- 12: INNER JOIN Múltiple (tres tablas)
-- Combina tablas para mostrar el ISBN, el título del libro, el nombre de su autor y el del proveedor.
SELECT l.isbn, l.titulo, a.nombre, p.nombre FROM Libro l
JOIN Autor a ON a.idAutor = l.idAutor
JOIN Proveedor p ON p.idProveedor = l.idProveedor;

-- 13: LEFT JOIN
-- Muestra todas las editoriales y los títulos de los libros que publican; si no tienen libros, el título aparecerá como nulo.
SELECT e.idEditorial, e.nombre, l.titulo FROM Editorial e
LEFT JOIN Libro l ON e.idEditorial = l.idEditorial;

-- 14: RIGHT JOIN
-- Muestra los títulos de los libros y el nombre de su editorial, y hace que aparezcan todas las editoriales aunque no tengan libros registrados.
SELECT l.titulo, e.nombre FROM Libro l
RIGHT JOIN Editorial e ON l.idEditorial = e.idEditorial;

-- 15: SELF JOIN (tabla consigo misma)
-- Relaciona la tabla Empleado consigo misma para obtener los nombres de los empleados que supervisan a otros compañeros.
SELECT DISTINCT e1.nombre FROM Empleado e1
JOIN Empleado e2 ON e1.idEmpleado = e2.supervisa;

-- 16: JOIN con Agregación
-- Lista los nombres de las editoriales y la cantidad de libros que tienen cada una.
SELECT e.nombre, count(l.titulo) FROM Editorial e
JOIN Libro l ON l.idEditorial = e.idEditorial
GROUP BY e.nombre;

-- 17: JOIN con Condiciones Complejas
-- Busca los libros (título, precio, nombre del proveedor y tienda) publicados por la 'Casa del Libro' que cuesten entre 15 y 20 y en el que el proveedor es Logista Libros.
SELECT l.titulo, pr.Valor AS precio, p.nombre AS proveedor, lib.localizacion 
FROM Libro l
JOIN Editorial e ON e.idEditorial = l.idEditorial
JOIN Proveedor p ON l.idProveedor = p.idProveedor
JOIN Libreria lib ON lib.idLibreria = l.idLibreria
JOIN Precio pr ON l.idLibro = pr.idLibro
WHERE e.nombre = 'Casa del Libro' 
  AND pr.Valor BETWEEN 15 AND 20
  AND p.nombre = 'Logista Libros';

-- 18: JOIN con Subconsultas
-- Muestra la información del cliente y la suma del total de todos los pedidos que ha hecho con una subtabla.
SELECT c.nombre AS NombreCliente, c.email, compras.TotalGastado
FROM Cliente c
JOIN (
    SELECT idCliente, SUM(total) AS TotalGastado
    FROM Pedido
    GROUP BY idCliente
) AS compras ON c.idCliente = compras.idCliente;

-- 19: JOIN con Múltiples Condiciones
-- Lista los libros, los nombres y apellidos de sus autores, y la ubicación, siempre que haya más de 10 en Stock en la libreria Madrid Centro.
SELECT l.titulo AS Libro, a.nombre AS NombreAutor, a.apellidos AS ApellidoAutor, lib.localizacion AS Ubicacion
FROM Libro l
JOIN Autor a ON l.idAutor = a.idAutor
JOIN Libreria lib ON l.idLibreria = lib.idLibreria
WHERE l.stock > 10 
  AND lib.localizacion = 'Madrid Centro';

-- 20: Unión de Resultados (UNION)
-- Combina los nombres y correos de clientes, editoriales y proveedores en un único resultado, añadiendo una columna que indica a qué 'Tipo' pertenece cada registro.
SELECT nombre AS Nombre_Entidad, email AS Correo_Contacto, 'Cliente' AS Tipo
FROM Cliente
UNION
SELECT nombre, email, 'Editorial' AS Tipo
FROM Editorial
UNION
SELECT nombre, email, 'Proveedor' AS Tipo
FROM Proveedor;

-- 21: LEFT JOIN con Filtro Complejo
-- Extrae los datos de los clientes cuyo correo sea de 'gmail.com', incluyendo detalles de pedidos solo si el total es superior a 15.
SELECT c.nombre AS Cliente, c.email, p.idPedido, p.total AS TotalPedido, p.fechaPedido
FROM Cliente c
LEFT JOIN Pedido p ON c.idCliente = p.idCliente AND p.total > 15
WHERE c.email LIKE '%@gmail.com%';


-- 22: Subconsulta en WHERE
-- Extrae los títulos, precios y stock de aquellos libros cuyo coste supera la media del precio de todos los libros.
SELECT l.titulo, pr.Valor AS precio, l.stock
FROM Libro l
JOIN Precio pr ON l.idLibro = pr.idLibro
WHERE pr.Valor > (
    SELECT AVG(Valor) 
    FROM Precio
);

-- 23: Subconsulta con IN
-- Muestra información de los autores cuyos libros tienen un stock menor a las 100 unidades.
SELECT nombre, apellidos, nacionalidad
FROM Autor
WHERE idAutor IN (
    SELECT idAutor 
    FROM Libro 
    WHERE stock < 100
);

-- 24: Subconsulta con NOT IN
-- Encuentra y muestra a los clientes todavia no han hecho ningún pedido.
SELECT nombre, email, dni
FROM Cliente
WHERE idCliente NOT IN (
    SELECT idCliente 
    FROM Pedido
);

-- 25: Subconsulta con EXISTS
-- Muestra el nombre y apellidos de los autores que tienen al menos un libro.
SELECT nombre, apellidos
FROM Autor a
WHERE EXISTS (
    SELECT 1
    FROM Libro l
    WHERE l.idAutor = a.idAutor
);

-- 26: Subconsulta con NOT EXISTS
-- Selecciona los datos de los empleados que no trabajan en ninguna libreria.
SELECT idEmpleado, nombre, apellidos, cargo
FROM Empleado e
WHERE NOT EXISTS (
    SELECT 1
    FROM Libreria lib
    WHERE lib.idEmpleado = e.idEmpleado
);

-- 27: Subconsulta en FROM (Tabla Derivada)
-- Lista a los clientes junto a su media de gasto, mostrando únicamente a los que tienen una media de gasto superior a 5.
SELECT c.nombre AS Cliente, metricas.PromedioGasto
FROM Cliente c
JOIN (
    SELECT idCliente, AVG(total) AS PromedioGasto
    FROM Pedido
    GROUP BY idCliente
) AS metricas ON c.idCliente = metricas.idCliente
WHERE metricas.PromedioGasto > 5;

-- 28: Subconsulta con ALL
-- Selecciona a los empleados con un salario superior al de *todos* los empleados que fueron contratados después del 1 de febrero de 2026.
SELECT nombre, apellidos, salario, fechaContratacion
FROM Empleado
WHERE salario > ALL (
    SELECT salario
    FROM Empleado
    WHERE fechaContratacion > '2026-02-01'
);

-- 29: Subconsulta con ANY/SOME
-- Obtiene los títulos y precios de los libros cuyo precio es más barato que al menos uno de los libros de William Shakespeare.
SELECT l.titulo, pr.Valor AS precio
FROM Libro l
JOIN Precio pr ON l.idLibro = pr.idLibro
WHERE pr.Valor < ANY (
    SELECT pr2.Valor
    FROM Libro l2
    JOIN Autor a ON l2.idAutor = a.idAutor
    JOIN Precio pr2 ON l2.idLibro = pr2.idLibro
    WHERE a.nombre = 'William' AND a.apellidos = 'Shakespeare'
);

-- 30: Subconsultas Anidadas
-- Extrae los nombres de los autores cuyos libros han sido comprados por un cliente y cuenta con un pedido que tiene una factura.
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