-- -----------------------------------------------------
-- 2. CREACIÓN DE ROLES Y USUARIOS
-- -----------------------------------------------------
USE `mydb`;

-- A. Crear Roles
-- Rol de Administrador (Total control)
CREATE ROLE IF NOT EXISTS 'rol_admin';
-- Rol de Vendedor (Gestión de ventas y clientes)
CREATE ROLE IF NOT EXISTS 'rol_vendedor';
-- Rol de Auditor (Solo lectura)
CREATE ROLE IF NOT EXISTS 'rol_auditor';

-- B. Asignar Permisos a los Roles

-- Permisos Admin: Todo sobre la base de datos
GRANT ALL PRIVILEGES ON mydb.* TO 'rol_admin';

-- Permisos Vendedor:
-- Puede insertar y actualizar pedidos, clientes y facturas.
-- Solo puede leer (SELECT) libros y stock.
GRANT SELECT, INSERT, UPDATE ON mydb.Pedido TO 'rol_vendedor';
GRANT SELECT, INSERT, UPDATE ON mydb.Cliente TO 'rol_vendedor';
GRANT SELECT, INSERT, UPDATE ON mydb.Factura TO 'rol_vendedor';
GRANT SELECT ON mydb.Libro TO 'rol_vendedor';
GRANT SELECT ON mydb.Empleado TO 'rol_vendedor';

-- Permisos Auditor: Solo lectura de todas las tablas
GRANT SELECT ON mydb.* TO 'rol_auditor';

-- C. Crear Usuarios
-- Usuario Admin
CREATE USER IF NOT EXISTS 'usuario_admin'@'localhost' IDENTIFIED BY 'admin123';
-- Usuario Vendedor
CREATE USER IF NOT EXISTS 'usuario_vendedor'@'localhost' IDENTIFIED BY 'ventas123';
-- Usuario Auditor
CREATE USER IF NOT EXISTS 'usuario_auditor'@'localhost' IDENTIFIED BY 'auditor123';

-- D. Asignar Roles a los Usuarios
GRANT 'rol_admin' TO 'usuario_admin'@'localhost';
GRANT 'rol_vendedor' TO 'usuario_vendedor'@'localhost';
GRANT 'rol_auditor' TO 'usuario_auditor'@'localhost';

-- E. Activar roles por defecto
SET DEFAULT ROLE ALL TO 'usuario_admin'@'localhost';
SET DEFAULT ROLE ALL TO 'usuario_vendedor'@'localhost';
SET DEFAULT ROLE ALL TO 'usuario_auditor'@'localhost';
SELECT User, Host FROM mysql.user;---------------------..------------
FLUSH PRIVILEGES;