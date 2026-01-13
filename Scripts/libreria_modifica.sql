-- -----------------------------------------------------
-- 3. MODIFICACIÓN DEL MODELO 
-- -----------------------------------------------------
USE `mydb`;

-- Desactivar chequeo de claves foráneas para evitar errores al tocar PKs y FKs
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Añadir una columna
-- Agregar el campo 'email' a la tabla Cliente para contacto digital.
ALTER TABLE `mydb`.`Cliente` 
ADD COLUMN `email` VARCHAR(100) NULL AFTER `nombre`;

-- 2. Modificar el tipo de dato y valor por defecto
-- Cambiar 'stock' en Libro a BIGINT 
ALTER TABLE `mydb`.`Libro` 
MODIFY COLUMN `stock` BIGINT NOT NULL DEFAULT 0;

-- 3. Renombrar una tabla
-- Renombrar 'Libreria' a 'Sucursal'.
RENAME TABLE `mydb`.`Libreria` TO `mydb`.`Sucursal`;

-- 4. Renombrar una columna
-- Cambiar 'salario' por 'sueldo_mensual' en la tabla Empleado.
ALTER TABLE `mydb`.`Empleado` 
RENAME COLUMN `salario` TO `sueldo_mensual`;

-- 5. Eliminar una clave foránea y volver a crearla
-- Tabla: Libro, FK hacia Editorial.
ALTER TABLE `mydb`.`Libro` 
DROP FOREIGN KEY `fk_Libro_Editorial1`;

ALTER TABLE `mydb`.`Libro` 
ADD CONSTRAINT `fk_Libro_Editorial_Nueva`
  FOREIGN KEY (`Editorial_idEditorial`)
  REFERENCES `mydb`.`Editorial` (`idEditorial`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

-- 6. Eliminar una clave primaria y volver a crearla
-- Tabla: Proveedor.
ALTER TABLE `mydb`.`Proveedor` 
DROP PRIMARY KEY;

ALTER TABLE `mydb`.`Proveedor` 
ADD PRIMARY KEY (`idProveedor`);

-- 7. Crear dos índices para optimizar consultas
-- Índice 1: Búsqueda rápida de libros por Título.
CREATE INDEX `idx_libro_titulo` ON `mydb`.`Libro` (`titulo`);

-- Índice 2: Búsqueda rápida de clientes por DNI.
CREATE INDEX `idx_cliente_dni` ON `mydb`.`Cliente` (`dni`);

-- 8. Eliminar uno de los índices
DROP INDEX `idx_cliente_dni` ON `mydb`.`Cliente`;

-- Reactivar el chequeo de claves foráneas 
SET FOREIGN_KEY_CHECKS = 1;

-- Verificación final
SHOW COLUMNS FROM `mydb`.`Cliente`;
SHOW INDEX FROM `mydb`.`Libro`;