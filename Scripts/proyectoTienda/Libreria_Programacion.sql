USE libreriaASDE;
-- PROCEDIMIENTOS
-- Un procedimiento de inserción con validación de datos
-- Insertar un proveedor comprobando que el email, telefono o nombre no es repetido
DROP PROCEDURE IF EXISTS insertarProveedor;
DELIMITER //
CREATE PROCEDURE insertarProveedor(IN nom VARCHAR(45), IN tel INT, IN mail VARCHAR(45), OUT exito SMALLINT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
		SET exito = 0;
        RESIGNAL;
    END;
	IF EXISTS (
		SELECT 1 FROM Proveedor WHERE mail = email OR telefono = tel OR nombre = nom
    ) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un proveedor con alguno de esos datos ya existe';
    END IF;
    INSERT INTO Proveedor (nombre, telefono, email) VALUES (nom, tel, mail);
    SET exito = 1;
    
END //
DELIMITER ;

-- yo funciono
CALL insertarProveedor('Distribuciones Norte', 600111222, 'norte@distribuciones.es', @exito);
SELECT @exito;
-- yo no
CALL insertarProveedor('Otra Empresa', 600111222, 'otra@empresa.es', @exito);
SELECT @exito; 

-- Un procedimiento de consulta con parámetros de filtrado
-- Listar los libros de una editorial
DROP PROCEDURE IF EXISTS listarLibrosEditorial;
DELIMITER //
CREATE PROCEDURE listarLibrosEditorial(IN nom VARCHAR(45), OUT exito SMALLINT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
		SET exito = 0;
        RESIGNAL;
    END;
    IF NOT EXISTS (
		SELECT 1 FROM Libro l
        JOIN Editorial e ON l.idEditorial = e.idEditorial
        WHERE e.nombre = nom
    ) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La editorial o no existe o no tiene libros';
    END IF;
    SELECT l.idLibro, l.titulo FROM Libro l
    JOIN Editorial e ON l.idEditorial = e.idEditorial
    WHERE e.nombre = nom;
    SET exito = 1;
END //

DELIMITER ;

-- yo funciono
CALL listarLibrosEditorial('Grupo Planeta', @exito);
SELECT @exito;
-- yo no
CALL listarLibrosEditorial('Editorial Inventada 123', @exito);
SELECT @exito;

-- Un procedimiento de actualización o eliminación con control de errores
-- Actualizar el stock de un libro validando que el libro exista y que la cantidad final no quede en negativo
DROP PROCEDURE IF EXISTS actualizarStock;
DELIMITER //
CREATE PROCEDURE actualizarStock(IN id INT, IN nuevoStock INT, OUT exito SMALLINT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    SET exito = 0;
    RESIGNAL;
    END;
	IF NOT EXISTS (
		SELECT 1 FROM Libro WHERE idLibro = id
    ) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ese libro no esta en la lista';
    ELSEIF nuevoStock < 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nuevo stock no puede ser menor a 0';
    END IF;
    UPDATE Libro
    SET stock = nuevoStock
    WHERE idLibro = id;
    SET exito = 1;
END //
DELIMITER ;

-- yo funciono
CALL actualizarStock(1, 15, @exito);
SELECT @exito;
-- yo no
CALL actualizarStock(1, -5, @exito);
SELECT @exito;


-- FUNCIONES
-- Calcular un total, un promedio o un descuento
-- Calcular el total de dinero que se ha gastado un cliente en la compañia
DROP FUNCTION IF EXISTS calcularGasto;
DELIMITER //
CREATE FUNCTION calcularGasto(id INT)
RETURNS DOUBLE
READS SQL DATA
BEGIN
	DECLARE totalComprado DOUBLE;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION	-- No se me ocurria nada para la excepcion :)
    BEGIN
		RESIGNAL;
    END;
    IF NOT EXISTS (
		SELECT 1 FROM Cliente WHERE idCliente = id
    ) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe ningun cliente con el id indicado';
	END IF;
    SELECT sum(total) INTO totalComprado FROM Pedido WHERE idCliente = id;
    IF totalComprado IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no tiene ninguna compra';
    END IF;
    RETURN totalComprado;
END //
DELIMITER ;

-- yo funciono
SELECT calcularGasto(1) AS TotalGastado;
-- yo no
SELECT calcularGasto(9999) AS TotalGastado;


-- Comprobar si un valor cumple una condición de negocio
-- Comprobar si un libro necesita restock (si un libro tiene menos de 4 libros en stock)
DROP FUNCTION IF EXISTS comprobarStock;
DELIMITER //
CREATE FUNCTION comprobarStock(id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
	DECLARE necesita BOOLEAN DEFAULT FALSE;
    DECLARE cantidad INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		RESIGNAL;
    END;
    IF NOT EXISTS (
		SELECT 1 FROM Libro WHERE idLibro = id
    ) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe ningun libro con ese id';
    END IF;
    SELECT stock INTO cantidad FROM Libro WHERE idLibro = id;
    IF cantidad < 4 THEN
		SET necesita = TRUE;
    END IF;
    RETURN necesita;
END //
DELIMITER ;

-- yo funciono
SELECT comprobarStock(1) AS NecesitaRestock;
-- yo no
SELECT comprobarStock(9999) AS NecesitaRestock;

-- TRIGGERS
-- Insertar la tabla de logs
DROP TABLE IF EXISTS Log;
CREATE TABLE IF NOT EXISTS Log (
  idLog INT NOT NULL AUTO_INCREMENT,
  tablaAfectada VARCHAR(45) NOT NULL,
  tipoOperacion VARCHAR(45) NOT NULL,           
  descripcion TEXT NOT NULL,          
  fechaHora DATETIME DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (idLog)
) ENGINE = InnoDB;


-- Un trigger de tipo INSERT para registrar o validar inserciones
-- Cada vez que un cliente realiza un nuevo Pedido, el trigger genera automáticamente la Factura 
DROP TRIGGER IF EXISTS generarFacturas;
DELIMITER //
CREATE TRIGGER generarFacturas AFTER INSERT ON Pedido FOR EACH ROW
BEGIN
	INSERT INTO Factura (fechaEmision, importeTotal, metodoPago, idPedido) VALUES (
		now(),
        NEW.total,
        NEW.metodoPago,
        NEW.idPedido
    );
    INSERT INTO Log (tablaAfectada, tipoOperacion, descripcion) VALUES (
		'Factura', 'Insercion', concat('Insercion de una factura a partir de un pedido registrado. Id del pedido objeto: ', NEW.idPedido)
    );
END //
DELIMITER ;

-- yo funciono
INSERT INTO Pedido (fechaPedido, total, metodoPago, idCliente) 
VALUES (CURDATE(), 45.50, 'Tarjeta', 1);
SELECT * FROM Factura;
SELECT * FROM Log;
-- aqui no hay segunda porque este no tiene ningun trigger pq no se me ocurria



-- Un trigger de tipo UPDATE para controlar modificaciones
-- Al actualizar el salario de un empleado no puede bajar (ojala fuera asi en la vida real en verdad) por lo tanto no hace el cambio
DROP TRIGGER IF EXISTS revisarCambioSalario;
DELIMITER //
CREATE TRIGGER revisarCambioSalario BEFORE UPDATE ON Empleado FOR EACH ROW
BEGIN
	IF NEW.salario < OLD.salario THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nuevo salario no puede ser inferior al viejo';
    END IF;
    INSERT INTO Log (tablaAfectada, tipoOperacion, descripcion) VALUES (
		'Empleado', 'Update', concat('Cambio del salario de un empleado. IdEmpleado: ', OLD.idEmpleado)
    );
END //
DELIMITER ;

-- yo funciono
UPDATE Empleado SET salario = salario + 200 WHERE idEmpleado = 1;
SELECT * FROM Log;
-- yo no
UPDATE Empleado SET salario = salario - 500 WHERE idEmpleado = 1;


-- Un trigger de tipo DELETE para proteger o registrar eliminaciones
-- Si el libro todavia tiene stock no se permite borrarlo
DROP TRIGGER IF EXISTS protegerStock;
DELIMITER //
CREATE TRIGGER protegerStock BEFORE DELETE ON Libro FOR EACH ROW
BEGIN
	IF OLD.stock > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El libro no se puede borrar mientras tengamos stock de el';
    END IF;
    INSERT INTO Log (tablaAfectada, tipoOperacion, descripcion) VALUES (
		'Libro', 'Delete', concat('Se ha borrado el libro: ', OLD.titulo,' idLibro', OLD.idLibro)
    );
END //
DELIMITER ;

-- yo funciono
UPDATE Libro SET stock = 0 WHERE idLibro = 2;
DELETE FROM Libro WHERE idLibro = 2;
SELECT * FROM Log;
-- yo no
DELETE FROM Libro WHERE idLibro = 1;




