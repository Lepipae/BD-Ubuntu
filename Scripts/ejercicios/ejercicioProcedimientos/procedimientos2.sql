CREATE SCHEMA IF NOT EXISTS `procedimientos2` DEFAULT CHARACTER SET utf8 ;
USE `procedimientos2` ;
DROP TABLE IF EXISTS empleados;
CREATE TABLE empleados (
id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50),
edad INT
);

-- 10. Crea un procedimiento que reciba nombre y edad e inserte un nuevo usuario en la tabla usuarios
DROP PROCEDURE IF EXISTS crearEmpleado;
DELIMITER //
CREATE PROCEDURE crearEmpleado(IN nom VARCHAR(50), ed INT)
BEGIN
INSERT INTO empleados (nombre, edad) VALUES
(nom, ed);
END //
DELIMITER ;
CALL crearEmpleado('Paco Paquez', 50);
SELECT * FROM empleados;
-- 11. Crea un procedimiento que muestre todos los usuarios
DROP PROCEDURE IF EXISTS mostrar;
DELIMITER //
CREATE PROCEDURE mostrar()
BEGIN
SELECT * FROM empleados;
END //
DELIMITER ;
CALL mostrar();

