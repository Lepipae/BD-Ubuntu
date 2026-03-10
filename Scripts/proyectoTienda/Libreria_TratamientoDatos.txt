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
  idEmpleado INT NOT NULL,
  nombre VARCHAR(45) NOT NULL,
  apellidos VARCHAR(45) NOT NULL,
  cargo VARCHAR(45) NOT NULL,
  salario INT NOT NULL,
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
  idProveedor INT NOT NULL,
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
  idEditorial INT NOT NULL,
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
  idAutor INT NOT NULL,
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
  idLibreria INT NOT NULL,
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
  idLibro INT NOT NULL,
  isbn INT NOT NULL,
  titulo VARCHAR(45) NOT NULL,
  añoPublicacion DATE NOT NULL,
  precio INT NOT NULL,
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
  idCliente INT NOT NULL,
  nombre VARCHAR(45) NOT NULL,
  email VARCHAR(35) NOT NULL,
  dni VARCHAR(45) NOT NULL,
  idLibro INT NOT NULL,
  PRIMARY KEY (idCliente),
  UNIQUE INDEX dni_UNIQUE (dni ASC),
  CONSTRAINT fk_Cliente_Libro1
    FOREIGN KEY (idLibro) REFERENCES Libro (idLibro)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla Pedido
-- -----------------------------------------------------
DROP TABLE IF EXISTS Pedido;
CREATE TABLE IF NOT EXISTS Pedido (
  idPedido INT NOT NULL,
  fechaPedido DATE NOT NULL,
  total INT NOT NULL,
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
  idFactura INT NOT NULL,
  fechaEmision DATE NOT NULL,
  importeTotal INT NOT NULL,
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
  Valor INT NOT NULL,
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
INSERT INTO Editorial (idEditorial,nombre,direccion,telefono,email) 
VALUES (1,'Casa del Libro','Calle Francos Rodriguez 106',660124657,'libreriaPaloma@gmail.com');

INSERT INTO Empleado(idEmpleado,nombre,apellidos,cargo,salario,fechaContratacion,Supervisa)
VALUES (1,'Edu','Vargas','empleado',1500,'2026-01-10',NULL);

INSERT INTO Proveedor(idProveedor,nombre, telefono,email)
VALUES (1,'Logista Libros', 918887766,'info@LogistaLibros.es');

INSERT INTO Autor(idAutor,nombre,apellidos,nacionalidad,fechaNacimiento)
VALUES (1,'Cristiano Ronaldo','Dos Santos Aveiro','Portuguesh','1985-02-05');

-- Insertamos la librería antes que el libro, ya que ahora el libro depende de ella
INSERT INTO Libreria(idLibreria,localizacion,idEmpleado,idProveedor)
VALUES (1,'Madrid Centro',1, 1);

-- Inserción en tabla Libro con todas sus nuevas claves foráneas directas
INSERT INTO Libro(idLibro,isbn,titulo,añoPublicacion,precio,stock,idEditorial,idAutor,idLibreria,idProveedor)
VALUES (1,987654,'Cien años de soledad','1967-05-30',15,50, 1, 1, 1, 1);

INSERT INTO Cliente (idCliente,nombre,email,dni,idLibro)
VALUES (1,'Andres','andreslopez@gmail.com','12345678A',1);

INSERT INTO Precio(Valor,idLibro)
VALUES (15,1);

INSERT INTO Pedido(idPedido,fechaPedido,total,metodoPago,idCliente)
VALUES (1,'2024-05-20',15,'Tarjeta',1);

INSERT INTO Factura(idFactura,fechaEmision,importeTotal,metodoPago,idPedido)
VALUES (1,'2024-05-20',15,'Tarjeta',1);


-- ==========================================
-- 1.2: INSERT con Subconsulta.
-- ==========================================
INSERT INTO Empleado(idEmpleado,nombre,apellidos,cargo,salario,fechaContratacion,Supervisa)
VALUES (2,'Luka','Modric','Ayudante',1100,'2026-02-01',(
  SELECT idEmpleado 
  FROM (SELECT idEmpleado FROM Empleado WHERE nombre='Edu') AS sub
));

-- Las subconsultas de Autor, Libreria y Proveedor que antes iban a tablas intermedias, ahora van directas aquí.
INSERT INTO Libro(idLibro,isbn,titulo,añoPublicacion,precio, stock, idEditorial, idAutor, idLibreria, idProveedor)
VALUES (2, 987655,'Don Quijote de la Mancha', '1605-01-01',20,100,
  (SELECT idEditorial FROM Editorial WHERE nombre ='Casa del Libro'),
  (SELECT idAutor FROM Autor WHERE nombre = 'Cristiano Ronaldo'),
  1,
  (SELECT idProveedor FROM Proveedor WHERE nombre = 'Logista Libros')
);

INSERT INTO Cliente(idCliente,nombre,email,dni,idLibro)
VALUES (2,'Sergio','sergiorodriguez@educa.madrid.org','315679189X', 
  (SELECT idLibro FROM Libro WHERE titulo= 'Don Quijote de la Mancha')
);

INSERT INTO Precio(Valor,idLibro)
VALUES( 20,(SELECT idLibro FROM Libro WHERE titulo= 'Don Quijote de la Mancha'));

INSERT INTO Pedido(idPedido,fechaPedido,total,metodoPago,idCliente)
VALUES (2,CURDATE(), 20,'Efectivo',
  (SELECT idCliente FROM Cliente WHERE nombre='Sergio')
);

INSERT INTO Factura(idFactura, fechaEmision, importeTotal, metodoPago, idPedido)
VALUES (2, CURDATE(), 20,'Efectivo',
  (SELECT idPedido FROM Pedido WHERE total= 20)
);


-- ==========================================
-- 1.3: INSERT Múltiple. 
-- ==========================================
INSERT INTO Autor(idAutor,nombre,apellidos,nacionalidad,fechaNacimiento) 
VALUES (3,'Miguel de Cervantes', 'Saavedra','Español','1547-9-29'),
       (4,'William', 'Shakespeare', 'Inglaterra', '1616-4-23'),
       (5,'Mary', 'Shelley', 'Reino Unido', '1797-2-7');

INSERT INTO Editorial(idEditorial,nombre,direccion,telefono,email)
VALUES (2, 'Grupo Planeta', 'Calle de Juan Ignacio Luca de Tena 17',934928000,'lopd@planeta.es'), 
       (3, 'Penguin Random House', 'Calle Luchana 23',915358190,'megustaescribir@penguinrandomhouse.com');

-- Añadidos el idAutor correspondiente y seteados a la librería 1 y proveedor 1 por defecto
INSERT INTO Libro (idLibro, isbn, titulo, añoPublicacion, precio, stock, idEditorial, idAutor, idLibreria, idProveedor) VALUES
(3, 111222, 'Novelas Ejemplares', '1943-04-06', 10, 100, 2, 3, 1, 1),
(4, 333444, 'Romeo y Julieta', '1597-06-26', 18, 150, 2, 4, 1, 1),
(5, 555666, 'Frankenstein', '1818-01-08', 12, 80, 3, 5, 1, 1);

INSERT INTO Empleado (idEmpleado, nombre, apellidos, cargo, salario, fechaContratacion, Supervisa) VALUES
(3, 'Karim', 'Benzema', 'Vendedor', 1500, '2026-02-15', 1),
(4, 'Vinicius', 'Jr', 'Almacenero', 1450, '2026-02-20', 1);


-- ==========================================
-- 1.4: INSERT con Valores Calculados
-- ==========================================
INSERT INTO Empleado(idEmpleado,nombre,apellidos,cargo,salario,fechaContratacion,Supervisa)
VALUES( 5,'Marco','Asensio','Encargado',(SELECT ROUND(salario * 1.10) FROM (SELECT salario FROM Empleado WHERE nombre='Edu') AS sub),'2025-01-01',
 ( SELECT idEmpleado FROM (SELECT idEmpleado FROM Empleado WHERE nombre='Edu') AS subconsultaa)) ;


-- ==========================================
-- 1.5: INSERT con Validación.
-- ==========================================
INSERT INTO Libro (idLibro, isbn, titulo, añoPublicacion, precio, stock, idEditorial, idAutor, idLibreria, idProveedor)
SELECT 6, 999888, 'El Principito', '1943-04-06', 12, 80, 1, 1, 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM Libro WHERE isbn = 999888
);


-- ==========================================
-- 1.6: INSERT a partir de un SELECT
-- ==========================================
INSERT INTO Pedido (idPedido, fechaPedido, total, metodoPago, idCliente)
SELECT 
    3,                       
    CURDATE(),              
    l.precio,               
    'Efectivo',             
    c.idCliente            
FROM Cliente c
JOIN Libro l ON c.idLibro = l.idLibro
WHERE c.nombre = 'Sergio'
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

    INSERT INTO Cliente(idCliente,nombre,email,dni,idLibro)
    VALUES (3,'Pedro Neto','pedro@gmail.com','98765432C', 1);

    INSERT INTO Pedido(idPedido, fechaPedido, total, metodoPago, idCliente)
    SELECT 2,CURDATE(), l.precio, 'Efectivo', c.idCliente
    FROM Cliente c
    JOIN Libro l ON c.idLibro = l.idLibro
    WHERE c.idCliente = 3;

    INSERT INTO Factura(idFactura, fechaEmision, importeTotal, metodoPago, idPedido)
    SELECT 2, CURDATE(), p.total, p.metodoPago, p.idPedido
    FROM Pedido p
    WHERE p.idPedido = 2;

    UPDATE Libro
    SET stock = stock - 1
    WHERE idLibro = 1;

COMMIT;