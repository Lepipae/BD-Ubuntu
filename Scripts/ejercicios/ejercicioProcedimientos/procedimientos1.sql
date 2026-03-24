CREATE SCHEMA IF NOT EXISTS `procedimientos1` DEFAULT CHARACTER SET utf8 ;
USE `procedimientos1` ;
DROP TABLE IF EXISTS empleados;
CREATE TABLE empleados (
id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50),
salario DECIMAL(10,2),
departamento VARCHAR(50)
);
INSERT INTO empleados (nombre, salario, departamento) VALUES
('Ana', 2000, 'Ventas'),
('Luis', 2500, 'IT'),
('Marta', 2200, 'Ventas'),
('Pedro', 3000, 'IT');


-- 1. Crear un procedimiento con nombre ver_empleados() que muestre todos los empleados y ejecuta
-- dicho procedimiento.
DROP PROCEDURE IF EXISTS ver_empleados;
DELIMITER //
CREATE PROCEDURE ver_empleados()
BEGIN
SELECT * FROM empleados;
END //
DELIMITER ;
CALL ver_empleados();
-- 2. Crear un procedimiento con nombre empleados_por_departamento() que recibe como argumento el
-- departamento y muestre los empleados de ese departamenteo. Ejecuta el procedimiento.
DROP PROCEDURE IF EXISTS empleados_por_departamento;
DELIMITER //
CREATE PROCEDURE empleados_por_departamento(iN nombreDepartamento VARCHAR(50))
BEGIN
SELECT * FROM empleados
WHERE departamento = nombreDepartamento;
END //
DELIMITER ;
CALL empleados_por_departamento('Ventas');
-- 3. Crear el procedimiento con nombre total_empleados() que retorna el número de empleados y ejecuta
-- el procedimiento anterior.
DROP PROCEDURE IF EXISTS total_empleados;

-- 4. Crear un procedimiento que muestre solo los nombres de empleados.

-- 5. Crear un procedimiento que reciba un departamento y devuelva cuántos empleados hay en ese
-- departamento.
DROP PROCEDURE IF EXISTS contarEmpleados;
DELIMITER //
CREATE PROCEDURE contarEmpleados(IN dep VARCHAR(50))
BEGIN
SELECT COUNT(id) FROM empleados
WHERE departamento = dep;
END //
DELIMITER ;
CALL contarEmpleados('Ventas');
-- 6. Crear un procedimiento que aumente el salario de todos los empleados un 5%.
DROP PROCEDURE IF EXISTS aumentarSalario;
DELIMITER //
CREATE PROCEDURE aumentarSalario()
BEGIN
UPDATE empleados
SET salario = salario * 1.05;
END //
DELIMITER ;
CALL aumentarSalario();
SELECT * FROM empleados;
-- 7. Crear un procedimiento que reciba un id de empleado y devuelva su salario.
DROP PROCEDURE IF EXISTS salarioEmpleado;
DELIMITER //
CREATE PROCEDURE salarioEmpleado(IN idEmpleado INT, OUT salarioEmpleado DECIMAL (10,2))
BEGIN
SELECT salario INTO salarioEmpleado FROM empleados
WHERE id = idEmpleado;
END //
DELIMITER ;
SET @resultado = 0;
CALL salarioEmpleado(1, @resultado);
SELECT @resultado;
-- 8. Crear un procedimiento que inserte un nuevo empleado.
DROP PROCEDURE IF EXISTS crearEmpleado;
DELIMITER //
CREATE PROCEDURE crearEmpleado(IN nom VARCHAR(50), sal DECIMAL(10,2), dep VARCHAR(50))
BEGIN
INSERT INTO empleados (nombre, salario, departamento) VALUES (nom, sal, dep);
END //
DELIMITER ;
CALL crearEmpleado('lucas', 6000, 'Ventas');
SELECT * FROM empleados;












