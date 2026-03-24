SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Esquema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS mydb;
CREATE SCHEMA IF NOT EXISTS mydb DEFAULT CHARACTER SET utf8;
USE mydb;

-- -----------------------------------------------------
-- Tabla Empleado
-- -----------------------------------------------------
DROP TABLE IF EXISTS Empleado;
CREATE TABLE IF NOT EXISTS Empleado (
  idEmpleado INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  apellidos VARCHAR(45) NOT NULL,
  cargo VARCHAR(45) NOT NULL,
  salario DOUBLE NOT NULL,
  fechaContratacion DATE NOT NULL,
  Supervisa INT NULL, 
  PRIMARY KEY (idEmpleado),
  CONSTRAINT fk_Empleado_Empleado1
    FOREIGN KEY (Supervisa) REFERENCES Empleado (idEmpleado)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Proveedor
-- -----------------------------------------------------
DROP TABLE IF EXISTS Proveedor;
CREATE TABLE IF NOT EXISTS Proveedor (
  idProveedor INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  telefono INT NOT NULL,
  email VARCHAR(45) NOT NULL,
  PRIMARY KEY (idProveedor)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Editorial
-- -----------------------------------------------------
DROP TABLE IF EXISTS Editorial;
CREATE TABLE IF NOT EXISTS Editorial (
  idEditorial INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  direccion VARCHAR(45) NOT NULL,
  telefono INT NOT NULL,
  email VARCHAR(45) NOT NULL,
  PRIMARY KEY (idEditorial)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Autor
-- -----------------------------------------------------
DROP TABLE IF EXISTS Autor;
CREATE TABLE IF NOT EXISTS Autor (
  idAutor INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  apellidos VARCHAR(45) NOT NULL,
  nacionalidad VARCHAR(45) NOT NULL,
  fechaNacimiento DATE NOT NULL,
  PRIMARY KEY (idAutor)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Libreria
-- -----------------------------------------------------
DROP TABLE IF EXISTS Libreria;
CREATE TABLE IF NOT EXISTS Libreria (
  idLibreria INT NOT NULL AUTO_INCREMENT,
  localizacion VARCHAR(45) NOT NULL,
  idEmpleado INT NOT NULL,
  idProveedor INT NOT NULL,
  PRIMARY KEY (idLibreria),
  CONSTRAINT fk_Libreria_Empleado1
    FOREIGN KEY (idEmpleado) REFERENCES Empleado (idEmpleado)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_Libreria_Proveedor
    FOREIGN KEY (idProveedor) REFERENCES Proveedor (idProveedor)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Libro
-- -----------------------------------------------------
DROP TABLE IF EXISTS Libro;
CREATE TABLE IF NOT EXISTS Libro (
  idLibro INT NOT NULL AUTO_INCREMENT,
  isbn INT NOT NULL,
  titulo VARCHAR(45) NOT NULL,
  añoPublicacion DATE NOT NULL,
  stock INT NOT NULL,
  idEditorial INT NOT NULL,
  idAutor INT NOT NULL,
  idLibreria INT NOT NULL,
  idProveedor INT NOT NULL,
  PRIMARY KEY (idLibro),
  UNIQUE INDEX isbn_UNIQUE (isbn ASC),
  CONSTRAINT fk_Libro_Editorial1
    FOREIGN KEY (idEditorial) REFERENCES Editorial (idEditorial)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_Libro_Autor
    FOREIGN KEY (idAutor) REFERENCES Autor (idAutor)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_Libro_Libreria
    FOREIGN KEY (idLibreria) REFERENCES Libreria (idLibreria)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_Libro_Proveedor
    FOREIGN KEY (idProveedor) REFERENCES Proveedor (idProveedor)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Cliente
-- -----------------------------------------------------
DROP TABLE IF EXISTS Cliente;
CREATE TABLE IF NOT EXISTS Cliente (
  idCliente INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  email VARCHAR(35) NOT NULL,
  dni VARCHAR(45) NOT NULL,
  PRIMARY KEY (idCliente),
  UNIQUE INDEX dni_UNIQUE (dni ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Pedido
-- -----------------------------------------------------
DROP TABLE IF EXISTS Pedido;
CREATE TABLE IF NOT EXISTS Pedido (
  idPedido INT NOT NULL AUTO_INCREMENT,
  fechaPedido DATE NOT NULL,
  total DOUBLE NOT NULL,
  metodoPago VARCHAR(45) NOT NULL,
  idCliente INT NOT NULL,
  PRIMARY KEY (idPedido),
  CONSTRAINT fk_Pedido_Cliente
    FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Factura
-- -----------------------------------------------------
DROP TABLE IF EXISTS Factura;
CREATE TABLE IF NOT EXISTS Factura (
  idFactura INT NOT NULL AUTO_INCREMENT,
  fechaEmision DATE NOT NULL,
  importeTotal DOUBLE NOT NULL,
  metodoPago VARCHAR(45) NOT NULL,
  idPedido INT NOT NULL,
  PRIMARY KEY (idFactura),
  CONSTRAINT fk_Factura_Pedido1
    FOREIGN KEY (idPedido) REFERENCES Pedido (idPedido)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Precio
-- -----------------------------------------------------
DROP TABLE IF EXISTS Precio;
CREATE TABLE IF NOT EXISTS Precio (
  Valor DOUBLE NOT NULL,
  idLibro INT NOT NULL,
  PRIMARY KEY (idLibro),
  CONSTRAINT fk_Precio_Libro1
    FOREIGN KEY (idLibro) REFERENCES Libro (idLibro)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Verificación final
SHOW TABLES;


-- ==========================================
-- 1.1 INSERT SIMPLE. Un solo Registro
-- ==========================================
INSERT INTO Editorial (nombre,direccion,telefono,email) 
VALUES ('Casa del Libro','Calle Francos Rodriguez 106',660124657,'libreriaPaloma@gmail.com');

INSERT INTO Empleado(nombre,apellidos,cargo,salario,fechaContratacion,Supervisa)
VALUES ('Edu','Vargas','empleado',1500,'2026-01-10',NULL);

INSERT INTO Proveedor(nombre, telefono,email)
VALUES ('Logista Libros', 918887766,'info@LogistaLibros.es');

INSERT INTO Autor(nombre,apellidos,nacionalidad,fechaNacimiento)
VALUES ('Cristiano Ronaldo','Dos Santos Aveiro','Portuguesh','1985-02-05');

-- Insertamos la librería antes que el libro, ya que ahora el libro depende de ella
INSERT INTO Libreria(localizacion,idEmpleado,idProveedor)
VALUES ('Madrid Centro',1, 1);

-- Inserción en tabla Libro con todas sus nuevas claves foráneas directas
INSERT INTO Libro(isbn,titulo,añoPublicacion,stock,idEditorial,idAutor,idLibreria,idProveedor)
VALUES (987654,'Cien años de soledad','1967-05-30',50, 1, 1, 1, 1);

INSERT INTO Cliente (nombre,email,dni)
VALUES ('Andres','andreslopez@gmail.com','12345678A');

INSERT INTO Precio(Valor, idLibro)
VALUES (15, 1);

INSERT INTO Pedido(fechaPedido,total,metodoPago,idCliente)
VALUES ('2024-05-20',15,'Tarjeta',1);

INSERT INTO Factura(fechaEmision,importeTotal,metodoPago,idPedido)
VALUES ('2024-05-20',15,'Tarjeta',1);


-- ==========================================
-- 1.2: INSERT con Subconsulta.
-- ==========================================
INSERT INTO Empleado(nombre,apellidos,cargo,salario,fechaContratacion,Supervisa)
VALUES ('Luka','Modric','Ayudante',1100,'2026-02-01',(
  SELECT idEmpleado 
  FROM (SELECT idEmpleado FROM Empleado WHERE nombre='Edu') AS sub
));

-- Las subconsultas de Autor, Libreria y Proveedor que antes iban a tablas intermedias, ahora van directas aquí.
INSERT INTO Libro(isbn,titulo,añoPublicacion, stock, idEditorial, idAutor, idLibreria, idProveedor)
VALUES (987655,'Don Quijote de la Mancha', '1605-01-01',100,
  (SELECT idEditorial FROM Editorial WHERE nombre ='Casa del Libro'),
  (SELECT idAutor FROM Autor WHERE nombre = 'Cristiano Ronaldo'),
  1,
  (SELECT idProveedor FROM Proveedor WHERE nombre = 'Logista Libros')
);

INSERT INTO Cliente(nombre,email,dni)
VALUES ('Sergio','sergiorodriguez@educa.madrid.org','315679189X');

INSERT INTO Precio(Valor, idLibro)
VALUES(20, (SELECT idLibro FROM Libro WHERE titulo= 'Don Quijote de la Mancha'));

INSERT INTO Pedido(fechaPedido,total,metodoPago,idCliente)
VALUES (CURDATE(), 20,'Efectivo',
  (SELECT idCliente FROM Cliente WHERE nombre='Sergio')
);

INSERT INTO Factura(fechaEmision, importeTotal, metodoPago, idPedido)
VALUES (CURDATE(), 20,'Efectivo',
  (SELECT idPedido FROM Pedido WHERE total= 20)
);


-- ==========================================
-- 1.3: INSERT Múltiple. 
-- ==========================================
INSERT INTO Autor(nombre,apellidos,nacionalidad,fechaNacimiento) 
VALUES ('Miguel de Cervantes', 'Saavedra','Español','1547-9-29'),
       ('William', 'Shakespeare', 'Inglaterra', '1616-4-23'),
       ('Mary', 'Shelley', 'Reino Unido', '1797-2-7');

INSERT INTO Editorial(nombre,direccion,telefono,email)
VALUES ('Grupo Planeta', 'Calle de Juan Ignacio Luca de Tena 17',934928000,'lopd@planeta.es'), 
       ('Penguin Random House', 'Calle Luchana 23',915358190,'megustaescribir@penguinrandomhouse.com');

-- Añadidos el idAutor correspondiente y seteados a la librería 1 y proveedor 1 por defecto
INSERT INTO Libro (isbn, titulo, añoPublicacion, stock, idEditorial, idAutor, idLibreria, idProveedor) VALUES
(111222, 'Novelas Ejemplares', '1943-04-06', 100, 2, 2, 1, 1),
(333444, 'Romeo y Julieta', '1597-06-26', 150, 2, 3, 1, 1),
(555666, 'Frankenstein', '1818-01-08', 80, 3, 4, 1, 1);

INSERT INTO Empleado (nombre, apellidos, cargo, salario, fechaContratacion, Supervisa) VALUES
('Karim', 'Benzema', 'Vendedor', 1500, '2026-02-15', 1),
('Vinicius', 'Jr', 'Almacenero', 1450, '2026-02-20', 1);


-- ==========================================
-- 1.4: INSERT con Valores Calculados
-- ==========================================
INSERT INTO Empleado(nombre,apellidos,cargo,salario,fechaContratacion,Supervisa)
VALUES('Marco','Asensio','Encargado',(SELECT ROUND(salario * 1.10) FROM (SELECT salario FROM Empleado WHERE nombre='Edu') AS sub),'2025-01-01',
 ( SELECT idEmpleado FROM (SELECT idEmpleado FROM Empleado WHERE nombre='Edu') AS subconsultaa)) ;


-- ==========================================
-- 1.5: INSERT con Validación.
-- ==========================================
INSERT INTO Libro (isbn, titulo, añoPublicacion, stock, idEditorial, idAutor, idLibreria, idProveedor)
SELECT 999888, 'El Principito', '1943-04-06', 80, 1, 1, 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM Libro WHERE isbn = 999888
);


-- ==========================================
-- 1.6: INSERT a partir de un SELECT
-- ==========================================
INSERT INTO Pedido (fechaPedido, total, metodoPago, idCliente)
SELECT 
    CURDATE(),          
    pr.Valor,                
    'Efectivo',             
    c.idCliente            
FROM Cliente c
CROSS JOIN Precio pr
WHERE c.nombre = 'Sergio' AND pr.idLibro = 2
LIMIT 1;


-- ==========================================
-- 2.1: UPDATE Simple. 
-- ==========================================
SET SQL_SAFE_UPDATES = 0; 

SELECT idEmpleado, nombre, cargo FROM Empleado WHERE idEmpleado = 1;

UPDATE Empleado 
SET cargo = 'Gerente'
WHERE idEmpleado = 1;


-- ==========================================
-- 2.2: UPDATE con Cálculo
-- ==========================================
SELECT idEmpleado, nombre, salario
FROM Empleado
WHERE Supervisa = (
    SELECT idEmpleado 
    FROM (SELECT idEmpleado FROM Empleado WHERE nombre='Edu') AS supervisa);

UPDATE Empleado
SET salario = ROUND(salario * 1.10)
WHERE Supervisa = (SELECT idEmpleado 
        FROM (SELECT idEmpleado FROM Empleado WHERE nombre='Edu') AS supervisa);


-- ==========================================
-- 2.3: UPDATE Basado en Subconsulta
-- ==========================================
SELECT idEmpleado, nombre, salario, cargo
FROM Empleado
WHERE salario > (
    SELECT AVG(salario)
    FROM (SELECT salario FROM Empleado) AS t
);

UPDATE Empleado
SET cargo = 'Gerente'
WHERE salario > (
    SELECT AVG(salario)
    FROM (SELECT salario FROM Empleado) AS salario
);


-- ==========================================
-- 2.4: UPDATE con JOIN Múltiple
-- ==========================================
SELECT f.idFactura, f.metodoPago, c.nombre, p.idPedido
FROM Factura f
JOIN Pedido p ON f.idPedido = p.idPedido
JOIN Cliente c ON p.idCliente = c.idCliente
WHERE c.nombre = 'Andres';

UPDATE Factura f
JOIN Pedido p ON f.idPedido = p.idPedido
JOIN Cliente c ON p.idCliente = c.idCliente
SET f.metodoPago = 'Tarjeta'
WHERE c.nombre = 'Andres';


-- ==========================================
-- 3.1: DELETE Simple. 
-- ==========================================
-- Ya no hace falta el ALTER TABLE porque la FK 'idAutor' de Libro ya tiene ON DELETE CASCADE configurado.
SELECT idEmpleado, nombre FROM Empleado WHERE idEmpleado = 5;

DELETE FROM Autor
WHERE idAutor = 5;


-- ==========================================
-- 3.2: DELETE con Subconsulta
-- ==========================================
SELECT *
FROM Cliente c LEFT JOIN Pedido p
ON c.idCliente= p.idCliente
WHERE p.idPedido IS NULL;

DELETE FROM Cliente
WHERE idCliente IN (
    SELECT idCliente
    FROM (
        SELECT c.idCliente
        FROM Cliente c
        LEFT JOIN Pedido p ON c.idCliente = p.idCliente
        WHERE p.idPedido IS NULL
    ) AS subconsulta
);


-- ==========================================
-- 3.3: DELETE con JOIN
-- ==========================================
SELECT *
FROM Pedido p INNER JOIN Cliente c
ON p.idCliente=c.idCliente
WHERE c.nombre='Sergio';

DELETE p
FROM Pedido p
JOIN Cliente c ON p.idCliente = c.idCliente
WHERE c.nombre = 'Sergio';


-- ==========================================
-- 3.4: DELETE Condicional con lógica compleja
-- ==========================================
SELECT e.idEmpleado, e.nombre, e.salario
FROM Empleado e
LEFT JOIN Empleado s ON e.idEmpleado = s.Supervisa
WHERE s.Supervisa IS NULL
  AND e.salario < 1200;

DELETE e
FROM Empleado e
LEFT JOIN Empleado s
    ON e.idEmpleado = s.Supervisa
WHERE s.Supervisa IS NULL   
  AND e.salario < 1200;     


-- ==========================================
-- 3.5: DELETE en Cascada Simulado
-- ==========================================
SELECT f.idFactura, f.idPedido
FROM Factura f
JOIN Pedido p ON f.idPedido = p.idPedido
WHERE p.idCliente = 3;

SELECT * FROM Pedido WHERE idCliente = 3;

DELETE f
FROM Factura f
JOIN Pedido p ON f.idPedido = p.idPedido
WHERE p.idCliente = 3;

DELETE FROM Pedido WHERE idCliente = 3;

DELETE FROM Cliente WHERE idCliente = 3;

SET SQL_SAFE_UPDATES = 1; 


-- ==========================================
-- 4.1: Transacción Completa.
-- ==========================================
START TRANSACTION;

    INSERT INTO Cliente(nombre,email,dni)
    VALUES ('Pedro Neto','pedro@gmail.com','98765432C');

    INSERT INTO Pedido(fechaPedido, total, metodoPago, idCliente)
    SELECT CURDATE(), pr.Valor, 'Efectivo', c.idCliente
    FROM Cliente c
    CROSS JOIN Precio pr
    WHERE c.idCliente = 3 AND pr.idLibro = 1;

    INSERT INTO Factura(fechaEmision, importeTotal, metodoPago, idPedido)
    SELECT CURDATE(), p.total, p.metodoPago, p.idPedido
    FROM Pedido p
    WHERE p.idPedido = 2;

    UPDATE Libro
    SET stock = stock - 1
    WHERE idLibro = 1;

COMMIT;



-- Inserts adicionales para las consultas:
-- ==========================================
-- TABLAS CATÁLOGO (Menor volumen de inserts)
-- ==========================================
INSERT INTO Proveedor (nombre, telefono, email) VALUES
('Distribuciones Alfa', 912345678, 'contacto@alfa.es'),
('Libros Global', 913456789, 'ventas@global.com');

INSERT INTO Editorial (nombre, direccion, telefono, email) VALUES
('Ediciones B', 'Calle Mayor 1', 914567890, 'info@edicionesb.com'),
('Alianza Editorial', 'Calle Arturo Soria 15', 915678901, 'contacto@alianza.es');

INSERT INTO Autor (nombre, apellidos, nacionalidad, fechaNacimiento) VALUES
('Isabel', 'Allende', 'Chilena', '1942-08-02'),
('Jorge Luis', 'Borges', 'Argentino', '1899-08-24'),
('Agatha', 'Christie', 'Británica', '1890-09-15');

INSERT INTO Empleado (nombre, apellidos, cargo, salario, fechaContratacion, Supervisa) VALUES
('Ana', 'García', 'Vendedora', 1300, '2026-03-01', 1),
('Luis', 'Pérez', 'Mozo', 1200, '2026-03-05', 1);

INSERT INTO Libreria (localizacion, idEmpleado, idProveedor) VALUES
('Barcelona Centro', 2, 2);

-- ==========================================
-- TABLAS PRINCIPALES Y TRANSACCIONALES (Mayor volumen)
-- ==========================================
INSERT INTO Cliente (nombre, email, dni) VALUES
('María Gomez', 'maria.gomez@gmail.com', '11111111A'),
('Carlos Ruiz', 'carlos.r@hotmail.com', '22222222B'),
('Laura Torres', 'laura.torres@yahoo.es', '33333333C'),
('David Sanchez', 'david.s@gmail.com', '44444444D'),
('Elena Martin', 'elena.m@outlook.com', '55555555E'),
('Pablo Vargas', 'pablo.v@empresa.com', '66666666F');

INSERT INTO Libro (isbn, titulo, añoPublicacion, stock, idEditorial, idAutor, idLibreria, idProveedor) VALUES
(10001, 'La casa de los espíritus', '1982-01-01', 45, 1, 1, 1, 1),
(10002, 'Ficciones', '1944-01-01', 20, 2, 2, 1, 2),
(10003, 'El Aleph', '1949-01-01', 35, 2, 2, 2, 2),
(10004, 'Asesinato en el Orient Express', '1934-01-01', 60, 1, 3, 2, 1),
(10005, 'Diez negritos', '1939-11-06', 50, 1, 3, 1, 1),
(10006, 'Paula', '1994-01-01', 25, 1, 1, 2, 2);

INSERT INTO Precio (Valor, idLibro)
SELECT 18, idLibro FROM Libro WHERE isbn = 10001 UNION ALL
SELECT 15, idLibro FROM Libro WHERE isbn = 10002 UNION ALL
SELECT 16, idLibro FROM Libro WHERE isbn = 10003 UNION ALL
SELECT 20, idLibro FROM Libro WHERE isbn = 10004 UNION ALL
SELECT 19, idLibro FROM Libro WHERE isbn = 10005 UNION ALL
SELECT 22, idLibro FROM Libro WHERE isbn = 10006;

INSERT INTO Pedido (fechaPedido, total, metodoPago, idCliente)
SELECT '2026-03-10', 18, 'Tarjeta', idCliente FROM Cliente WHERE dni = '11111111A' UNION ALL
SELECT '2026-03-11', 35, 'Efectivo', idCliente FROM Cliente WHERE dni = '22222222B' UNION ALL
SELECT '2026-03-12', 20, 'Tarjeta', idCliente FROM Cliente WHERE dni = '33333333C' UNION ALL
SELECT '2026-03-12', 15, 'Transferencia', idCliente FROM Cliente WHERE dni = '44444444D' UNION ALL
SELECT '2026-03-13', 41, 'Tarjeta', idCliente FROM Cliente WHERE dni = '55555555E' UNION ALL
SELECT '2026-03-14', 19, 'Efectivo', idCliente FROM Cliente WHERE dni = '11111111A' UNION ALL
SELECT '2026-03-15', 22, 'Tarjeta', idCliente FROM Cliente WHERE dni = '66666666F';

INSERT INTO Factura (fechaEmision, importeTotal, metodoPago, idPedido)
SELECT p.fechaPedido, p.total, p.metodoPago, p.idPedido 
FROM Pedido p 
WHERE p.fechaPedido >= '2026-03-10';
-- ==========================================
-- TABLAS CATÁLOGO (Nuevos registros base)
-- ==========================================
INSERT INTO Proveedor (nombre, telefono, email) VALUES
('Planeta Grandes Superficies', 900111222, 'grandes@planeta.es');

INSERT INTO Editorial (nombre, direccion, telefono, email) VALUES
('Tusquets Editores', 'Calle Córcega 25', 931234567, 'contacto@tusquets.es'),
('Anagrama', 'Calle Pedró 58', 934567890, 'info@anagrama.es');

INSERT INTO Autor (nombre, apellidos, nacionalidad, fechaNacimiento) VALUES
('Stephen', 'King', 'Estadounidense', '1947-09-21'),
('J.K.', 'Rowling', 'Británica', '1965-07-31'),
('Haruki', 'Murakami', 'Japonesa', '1949-01-12');

INSERT INTO Empleado (nombre, apellidos, cargo, salario, fechaContratacion, Supervisa) VALUES
('Roberto', 'Sánchez', 'Vendedor', 1350, '2026-03-15', 1),
('Lucía', 'Gómez', 'Cajera', 1250, '2026-03-18', 1);


-- ==========================================
-- TABLAS PRINCIPALES (Clientes y Libros)
-- ==========================================
INSERT INTO Cliente (nombre, email, dni) VALUES
('Sofia Castro', 'sofia.castro@gmail.com', '77777777G'),
('Miguel Angel', 'miguel.angel@hotmail.com', '88888888H'),
('Lucia Navarro', 'lucia.n@yahoo.es', '99999999I'),
('Diego Fernandez', 'diego.fer@empresa.com', '00000000J'),
('Valeria Blanco', 'valeria.b@gmail.com', '12121212K'),
('Hugo Molina', 'hugo.m@outlook.com', '34343434L');

-- Insertamos los libros buscando dinámicamente el ID del autor y la editorial que acabamos de crear.
-- Asumimos que idLibreria 1 y idProveedor 1 ya existen de scripts anteriores.
INSERT INTO Libro (isbn, titulo, añoPublicacion, stock, idEditorial, idAutor, idLibreria, idProveedor)
SELECT 20001, 'El Resplandor', '1977-01-28', 30, 
       (SELECT idEditorial FROM Editorial WHERE nombre = 'Tusquets Editores' LIMIT 1),
       (SELECT idAutor FROM Autor WHERE apellidos = 'King' LIMIT 1),
       1, 1 UNION ALL
SELECT 20002, 'It', '1986-09-15', 40, 
       (SELECT idEditorial FROM Editorial WHERE nombre = 'Tusquets Editores' LIMIT 1),
       (SELECT idAutor FROM Autor WHERE apellidos = 'King' LIMIT 1),
       1, 1 UNION ALL
SELECT 20003, 'Harry Potter y la Piedra Filosofal', '1997-06-26', 100, 
       (SELECT idEditorial FROM Editorial WHERE nombre = 'Anagrama' LIMIT 1),
       (SELECT idAutor FROM Autor WHERE apellidos = 'Rowling' LIMIT 1),
       1, 1 UNION ALL
SELECT 20004, 'Harry Potter y la Cámara Secreta', '1998-07-02', 85, 
       (SELECT idEditorial FROM Editorial WHERE nombre = 'Anagrama' LIMIT 1),
       (SELECT idAutor FROM Autor WHERE apellidos = 'Rowling' LIMIT 1),
       1, 1 UNION ALL
SELECT 20005, 'Tokio Blues', '1987-09-04', 55, 
       (SELECT idEditorial FROM Editorial WHERE nombre = 'Tusquets Editores' LIMIT 1),
       (SELECT idAutor FROM Autor WHERE apellidos = 'Murakami' LIMIT 1),
       1, 1 UNION ALL
SELECT 20006, 'Kafka en la orilla', '2002-09-12', 45, 
       (SELECT idEditorial FROM Editorial WHERE nombre = 'Anagrama' LIMIT 1),
       (SELECT idAutor FROM Autor WHERE apellidos = 'Murakami' LIMIT 1),
       1, 1;


-- ==========================================
-- TABLAS TRANSACCIONALES (Precios, Pedidos y Facturas)
-- ==========================================
-- Vinculamos los precios utilizando los nuevos ISBNs generados.
INSERT INTO Precio (Valor, idLibro)
SELECT 22, idLibro FROM Libro WHERE isbn = 20001 UNION ALL
SELECT 25, idLibro FROM Libro WHERE isbn = 20002 UNION ALL
SELECT 18, idLibro FROM Libro WHERE isbn = 20003 UNION ALL
SELECT 19, idLibro FROM Libro WHERE isbn = 20004 UNION ALL
SELECT 21, idLibro FROM Libro WHERE isbn = 20005 UNION ALL
SELECT 24, idLibro FROM Libro WHERE isbn = 20006;

-- Creamos nuevos pedidos asociados a los DNIs de los nuevos clientes.
INSERT INTO Pedido (fechaPedido, total, metodoPago, idCliente)
SELECT '2026-03-20', 47, 'Tarjeta', idCliente FROM Cliente WHERE dni = '77777777G' UNION ALL
SELECT '2026-03-21', 18, 'Efectivo', idCliente FROM Cliente WHERE dni = '88888888H' UNION ALL
SELECT '2026-03-21', 25, 'Bizum', idCliente FROM Cliente WHERE dni = '99999999I' UNION ALL
SELECT '2026-03-22', 40, 'Transferencia', idCliente FROM Cliente WHERE dni = '00000000J' UNION ALL
SELECT '2026-03-23', 22, 'Tarjeta', idCliente FROM Cliente WHERE dni = '12121212K' UNION ALL
SELECT '2026-03-23', 68, 'Tarjeta', idCliente FROM Cliente WHERE dni = '34343434L' UNION ALL
SELECT '2026-03-24', 24, 'Efectivo', idCliente FROM Cliente WHERE dni = '77777777G';

-- Generamos las facturas en bloque filtrando por las fechas de los pedidos que acabamos de meter.
INSERT INTO Factura (fechaEmision, importeTotal, metodoPago, idPedido)
SELECT p.fechaPedido, p.total, p.metodoPago, p.idPedido 
FROM Pedido p 
WHERE p.fechaPedido >= '2026-03-20';