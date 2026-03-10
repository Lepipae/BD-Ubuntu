-- 1 - Inserta un nuevo departamento indicando su código, nombre y presupuesto.
select * from departamento;
INSERT INTO departamento (id, nombre, presupuesto, gastos) VALUES(8, 'Relaciones Publicas', 6769.41, 0);
-- 2 - Inserta un nuevo departamento indicando su nombre y presupuesto.
INSERT INTO departamento (nombre, presupuesto, gastos) VALUES('Legal', 9000, 0); 
-- 3 - Inserta un nuevo departamento indicando su código, nombre, presupuesto y gastos.
INSERT INTO departamento VALUES(10, 'yokse', 88329, 9129);
-- 4 - Inserta un nuevo empleado asociado a uno de los nuevos departamentos. 
-- La sentencia de inserción debe incluir: código, nif, nombre, apellido1, apellido2 y codigo_departamento.
INSERT INTO empleado (id, nif, nombre, apellido1, apellido2, id_departamento)
VALUES (14, '34567879K', 'Paquito', 'Gomez', 'Gonzalez', 10);
SELECT * FROM empleado;
-- 5 - Inserta un nuevo empleado asociado a uno de los nuevos departamentos. La sentencia de inserción debe incluir: nif, nombre, apellido1, apellido2 y codigo_departamento.
INSERT INTO empleado (nif, nombre, apellido1, apellido2, id_departamento) 
VALUES ('7838320J', 'Manolo', 'Lopez', 'Cañamos', 8);
-- 6 - Crea una nueva tabla con el nombre departamento_backup que tenga las mismas columnas que la tabla departamento. 
-- Una vez creada copia todos las filas de tabla departamento en departamento_backup.
CREATE TABLE departamento_backup (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
presupuesto DOUBLE UNSIGNED NOT NULL,
gastos DOUBLE UNSIGNED NOT NULL
);
INSERT INTO departamento_backup
SELECT * FROM departamento;
SELECT * FROM departamento_backup;
-- 7 - Elimina el departamento Proyectos. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE FROM empleado 
WHERE id_departamento = (
	SELECT id FROM departamento WHERE nombre = 'Proyectos'
);
DELETE FROM departamento WHERE nombre = 'Proyectos';
-- 8 - Elimina el departamento Desarrollo. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE FROM empleado 
WHERE id_departamento = (
	SELECT id FROM departamento WHERE nombre = 'Desarrollo'
);
DELETE FROM departamento WHERE nombre = 'Desarrollo';
-- 9 - Actualiza el código del departamento Recursos Humanos y asígnale el valor 30. ¿Es posible actualizarlo? Si no fuese posible, 
-- ¿qué cambios debería realizar para que fuese actualizarlo?
SELECT * FROM departamento;
INSERT INTO departamento (id, nombre, presupuesto, gastos)
SELECT 30, nombre, presupuesto, gastos FROM departamento WHERE nombre = 'Recursos Humanos';
UPDATE empleado
SET id_departamento = 30
WHERE id_departamento = 3;
DELETE FROM departamento WHERE id = 3;
-- 10 - Actualiza el código del departamento Publicidad y asígnale el valor 40. ¿Es posible actualizarlo? Si no fuese posible, 
-- ¿qué cambios debería realizar para que fuese actualizarlo?
UPDATE departamento
SET id = 40
WHERE nombre = 'Publicidad';
-- 11 - Actualiza el presupuesto de los departamentos sumándole 50000 € al valor del presupuesto actual, 
-- solamente a aquellos departamentos que tienen un presupuesto menor que 20000 €.
UPDATE departamento
SET presupuesto = presupuesto + 50000
WHERE presupuesto < 20000;
SELECT * FROM departamento;
-- 12 - Realiza una transacción que elimine todas los empleados que no tienen un departamento asociado.
START TRANSACTION;
DELETE FROM empleado WHERE id_departamento IS NULL;
COMMIT;




