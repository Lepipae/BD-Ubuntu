USE instituto;
-- Crea la consulta para obtener todos los datos de los alumnos
SELECT * FROM alumno;
-- Muestra los nombres de los alumnos
SELECT nombre FROM alumno;
-- Selecciona nombre apellido1 apellido2 de alumno
SELECT nombre, apellido1, apellido2 FROM alumno;
-- Selecciona el apellido1 apellido2 y el nombre de alumno
SELECT apellido1, apellido2, nombre FROM alumno;
-- 3.1 Selecciona el apellido1, apellido2 y nombre y muéstralos en una única columna que concatene el
-- apellido1, apellido2, incorpore una coma y a continuación concatene el nombre
SELECT CONCAT_WS(",", apellido1, apellido2, nombre) FROM alumno;
-- 3.2 Obtener nombre y apellido1 de los alumnos en una única columna en minúscula
SELECT lower(concat(nombre, apellido1)) FROM alumno;
-- 3.3 Obtener nombre y apellido1 de los alumnos en una única columna en MAYÚSCULA
SELECT upper(concat(nombre, apellido1)) FROM alumno;
-- 4.1 Muestra los primeros apellidos distintos ( no repetidos) de los alumnos
SELECT DISTINCT apellido1 FROM alumno;
-- 4.2 Obten el apellido1, apellido2 y nombre ordenado por el primer apellido
SELECT apellido1, apellido2, nombre FROM alumno ORDER BY apellido1;
-- 4.3 Realiza la consulta anterior ordenada de manera descendente
SELECT apellido1, apellido2, nombre FROM alumno ORDER BY apellido1 DESC;
-- 4.4 Realiza la consulta anterior ordenada de manera ascendente
SELECT apellido1, apellido2, nombre FROM alumno ORDER BY apellido1 ASC;
-- 4.5 Realiza la consulta de apellido1 y nombre ordenada primero por apellido y después por nombre
SELECT apellido1, nombre FROM alumno ORDER BY apellido1, nombre;
-- 4.6 Realiza la consulta de apellido1 y nombre de manera que muestre sólo LOS DOS PRIMEROS
-- registros
SELECT apellido1, nombre FROM alumno LIMIT 2;
-- 4.7 Realiza la consulta de apellido1 y nombre de manera que muestre sólo registros 3,4
SELECT apellido1, nombre FROM alumno LIMIT 2 OFFSET 2;
-- 5.1 Muestra los nombres de todos los alumnos cuyo primer apellido sea ‘García’
SELECT nombre FROM alumno WHERE apellido1="García";
-- 5.2 Muestra los datos del alumno con nif igual a ‘99999999G’
SELECT nombre FROM alumno WHERE nif="99999999G";
-- 5.3 Muestra el nombre y la fecha de nacimiento de todos los alumnos que nacieron después del 2001-01-01
SELECT nombre, fechaNacimiento FROM alumno WHERE fechaNacimiento > "2001-01-01";
-- 5.4 Muestra los datos del alumno con teléfono ‘444444422’
SELECT * FROM alumno WHERE telefono = "444444422";
-- 5.5 Muestra los alumnos que nacieron en el año 2000
SELECT * FROM alumno WHERE fechaNacimiento BETWEEN "2000-01-01" AND "2000-12-31";
-- 5.6 Muestra los alumnos que no nacieron en el año 2000
SELECT * FROM alumno WHERE NOT fechaNacimiento BETWEEN "2000-01-01" AND "2000-12-31";
-- 5.7 Muestra los alumnos que han nacido entre el 1 de enero de 2001 y 31 de diciembre del 2012
SELECT * FROM alumno WHERE fechaNacimiento BETWEEN "2001-01-01" AND "2012-12-31";
-- 5.8 Muestra los alumnos que no hayan nacido entre el 1 de enero de 2001 y 31 de diciembre del 2012
SELECT * FROM alumno WHERE NOT fechaNacimiento BETWEEN "2001-01-01" AND "2012-12-31";
-- 5.9 Muestra los alumnos que tengan como primer apellido ‘García’ o ‘González’
SELECT * FROM alumno WHERE apellido1="García" OR apellido1="González";
-- 5.10 Muestra los alumnos que no tengan como primer apellido ‘García’ o ‘González’
SELECT * FROM alumno WHERE NOT apellido1="García" OR apellido1="González";



