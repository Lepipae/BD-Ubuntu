DROP DATABASE IF EXISTS empleados;
CREATE DATABASE empleados CHARACTER SET utf8mb4;
USE empleados;
CREATE TABLE departamento (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
presupuesto DOUBLE UNSIGNED NOT NULL,
gastos DOUBLE UNSIGNED NOT NULL
);
CREATE TABLE empleado (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nif VARCHAR(9) NOT NULL UNIQUE,
nombre VARCHAR(100) NOT NULL,
apellido1 VARCHAR(100) NOT NULL,
apellido2 VARCHAR(100),
id_departamento INT UNSIGNED,
FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);
INSERT INTO departamento VALUES(1, 'Desarrollo', 120000, 6000);
INSERT INTO departamento VALUES(2, 'Sistemas', 150000, 21000);
INSERT INTO departamento VALUES(3, 'Recursos Humanos', 280000, 25000);
INSERT INTO departamento VALUES(4, 'Contabilidad', 110000, 3000);
INSERT INTO departamento VALUES(5, 'I+D', 375000, 380000);
INSERT INTO departamento VALUES(6, 'Proyectos', 0, 0);
INSERT INTO departamento VALUES(7, 'Publicidad', 0, 1000);
INSERT INTO empleado VALUES(1, '32481596F', 'Aarón', 'Rivero', 'Gómez', 1);
INSERT INTO empleado VALUES(2, 'Y5575632D', 'Adela', 'Salas', 'Díaz', 2);
INSERT INTO empleado VALUES(3, 'R6970642B', 'Adolfo', 'Rubio', 'Flores', 3);
INSERT INTO empleado VALUES(4, '77705545E', 'Adrián', 'Suárez', NULL, 4);
INSERT INTO empleado VALUES(5, '17087203C', 'Marcos', 'Loyola', 'Méndez', 5);
INSERT INTO empleado VALUES(6, '38382980M', 'María', 'Santana', 'Moreno', 1);
INSERT INTO empleado VALUES(7, '80576669X', 'Pilar', 'Ruiz', NULL, 2);
INSERT INTO empleado VALUES(8, '71651431Z', 'Pepe', 'Ruiz', 'Santana', 3);
INSERT INTO empleado VALUES(9, '56399183D', 'Juan', 'Gómez', 'López', 2);
INSERT INTO empleado VALUES(10, '46384486H', 'Diego','Flores', 'Salas', 5);
INSERT INTO empleado VALUES(11, '67389283A', 'Marta','Herrera', 'Gil', 1);
INSERT INTO empleado VALUES(12, '41234836R', 'Irene','Salas', 'Flores', NULL);
INSERT INTO empleado VALUES(13, '82635162B', 'Juan Antonio','Sáez', 'Guerrero', NULL);
-- 1.2.5 Consultas multitabla (Composición externa)
-- Resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN
-- 1.Devuelve un listado con todos los empleados junto con los datos de los
-- departamentos donde trabajan. Este listado también debe incluir los empleados que no
-- tienen ningún departamento asociado.
SELECT e.*, d.* FROM empleado e
LEFT JOIN departamento d ON e.id_departamento = d.id;
-- 2.Devuelve un listado donde sólo aparezcan aquellos empleados que no tienen ningún
-- departamento asociado.
SELECT e.* FROM empleado e 
LEFT JOIN departamento d ON e.id_departamento = d.id
WHERE d.id IS NULL;
-- 3.Devuelve un listado donde sólo aparezcan aquellos departamentos que no tienen
-- ningún empleado asociado.
SELECT d.* FROM departamento d
LEFT JOIN empleado e ON d.id = e.id_departamento
WHERE e.id_departamento IS NULL;
-- 4.Devuelve un listado con todos los empleados junto con los datos de los
-- departamentos donde trabajan. El listado debe incluir los empleados que no tienen
-- ningún departamento asociado y los departamentos que no tienen ningún empleado
-- asociado. Ordene el listado alfabéticamente por el nombre del departamento.
SELECT e.*, d.id, d.nombre AS depar, d.presupuesto, d.gastos FROM empleado e
LEFT JOIN departamento d ON e.id_departamento = d.id
UNION
SELECT e.*, d.id, d.nombre AS depar, d.presupuesto, d.gastos FROM empleado e
RIGHT JOIN departamento d ON e.id_departamento = d.id
ORDER BY depar;
-- 5.Devuelve un listado con los empleados que no tienen ningún departamento asociado
-- y los departamentos que no tienen ningún empleado asociado. Ordene el listado
-- alfabéticamente por el nombre del departamento.
SELECT e.*, d.id, d.nombre AS depar, d.presupuesto, d.gastos FROM empleado e
LEFT JOIN departamento d ON e.id_departamento = d.id
WHERE d.id IS NULL
UNION
SELECT e.*, d.id AS eid, d.nombre AS depar, d.presupuesto, d.gastos FROM empleado e
RIGHT JOIN departamento d ON e.id_departamento = d.id
WHERE e.id IS NULL
ORDER BY depar;

-- 1.2.6 Consultas resumen
-- 1.Calcula la suma del presupuesto de todos los departamentos.
SELECT sum(presupuesto) FROM departamento;
-- 2.Calcula la media del presupuesto de todos los departamentos.
SELECT avg(presupuesto) FROM departamento;
-- 3.Calcula el valor mínimo del presupuesto de todos los departamentos.
SELECT min(presupuesto) FROM departamento;
-- 4.Calcula el nombre del departamento y el presupuesto que tiene asignado, del
-- departamento con menor presupuesto
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto = (SELECT min(presupuesto) FROM departamento);
-- 5.Calcula el valor máximo del presupuesto de todos los departamentos.
SELECT max(presupuesto) FROM departamento;
-- 6.Calcula el nombre del departamento y el presupuesto que tiene asignado, del
-- departamento con mayor presupuesto.
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto = (SELECT max(presupuesto) FROM departamento);
-- 7.Calcula el número total de empleados que hay en la tabla empleado.
SELECT count(id) FROM empleado;
-- 8.Calcula el número de empleados que no tienen NULL en su segundo apellido.
SELECT count(apellido2) FROM empleado;
-- 9.Calcula el número de empleados que hay en cada departamento. Tienes que devolver
-- dos columnas, una con el nombre del departamento y otra con el número de
-- empleados que tiene asignados.
SELECT count(e.id) AS nºempleados, d.nombre FROM empleado e
JOIN departamento d ON e.id_departamento = d.id
GROUP BY d.nombre;
-- 10.Calcula el nombre de los departamentos que tienen más de 2 empleados. El
-- resultado debe tener dos columnas, una con el nombre del departamento y otra con el
-- número de empleados que tiene asignados.
SELECT count(e.id) AS cantidad, d.nombre FROM empleado e
JOIN departamento d ON e.id_departamento = d.id
GROUP BY d.nombre
HAVING cantidad > 2;
-- 11.Calcula el número de empleados que trabajan en cada uno de los departamentos. El
-- resultado de esta consulta también tiene que incluir aquellos departamentos que no
-- tienen ningún empleado asociado.
SELECT count(e.id) AS nºempleados, d.nombre FROM empleado e
RIGHT JOIN departamento d ON e.id_departamento = d.id
GROUP BY d.nombre;
-- 12.Calcula el número de empleados que trabajan en cada unos de los departamentos
-- que tienen un presupuesto mayor a 200000 euros.
SELECT count(e.id) AS cantidad, d.nombre FROM empleado e
JOIN departamento d ON e.id_departamento = d.id
WHERE d.presupuesto > 200000
GROUP BY d.nombre;

-- 1.2.7 Subconsultas
-- 1.2.7.1 Con operadores básicos de comparación
-- 1.Devuelve un listado con todos los empleados que tiene el departamento de Sistemas.
-- (Sin utilizar INNER JOIN).
SELECT * FROM empleado 
WHERE id_departamento = (
	SELECT id FROM departamento
	WHERE nombre = "Sistemas"
);
-- 2.Devuelve el nombre del departamento con mayor presupuesto y la cantidad que
-- tiene asignada.
SELECT nombre, presupuesto FROM departamento
ORDER BY presupuesto DESC
LIMIT 1;
-- 3.Devuelve el nombre del departamento con menor presupuesto y la cantidad que
-- tiene asignada.
SELECT nombre, presupuesto FROM departamento
ORDER BY presupuesto ASC
LIMIT 1;
-- 1.2.7.2 Subconsultas con ALL y ANY
-- 4.Devuelve el nombre del departamento con mayor presupuesto y la cantidad que
-- tiene asignada. Sin hacer uso de MAX, ORDER BY ni LIMIT.
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto >= ALL (
	SELECT presupuesto FROM departamento
);
-- 5.Devuelve el nombre del departamento con menor presupuesto y la cantidad que
-- tiene asignada. Sin hacer uso de MIN, ORDER BY ni LIMIT.
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto <= ALL (
	SELECT presupuesto FROM departamento
);
-- 6.Devuelve los nombres de los departamentos que tienen empleados asociados.
-- (Utilizando ALL o ANY).
SELECT nombre FROM departamento 
WHERE id = ANY (
	SELECT id_departamento FROM empleado
);
-- 7.Devuelve los nombres de los departamentos que no tienen empleados asociados.
-- (Utilizando ALL o ANY).
SELECT nombre FROM departamento 
WHERE id != ALL (
	SELECT id_departamento FROM empleado
    WHERE id_departamento IS NOT NULL
);
-- 1.2.7.3 Subconsultas con IN y NOT IN
-- 8.Devuelve los nombres de los departamentos que tienen empleados asociados.
-- (Utilizando IN o NOT IN).
SELECT nombre FROM departamento
WHERE id IN (
	SELECT id_departamento FROM empleado
    WHERE id_departamento IS NOT NULL
);
-- 9.Devuelve los nombres de los departamentos que no tienen empleados asociados.
-- (Utilizando IN o NOT IN).
SELECT nombre FROM departamento
WHERE id NOT IN (
	SELECT id_departamento FROM empleado
    WHERE id_departamento IS NOT NULL
);
-- 1.2.7.4 Subconsultas con EXISTS y NOT EXISTS
-- 10.Devuelve los nombres de los departamentos que tienen empleados asociados.
-- (Utilizando EXISTS o NOT EXISTS).
SELECT nombre FROM departamento
WHERE EXISTS (
	SELECT id_departamento FROM empleado
    WHERE id_departamento = departamento.id
);
-- 11.Devuelve los nombres de los departamentos que tienen empleados asociados.
-- (Utilizando EXISTS o NOT EXISTS).
SELECT nombre FROM departamento
WHERE NOT EXISTS (
	SELECT id_departamento FROM empleado
    WHERE id_departamento = departamento.id
);


