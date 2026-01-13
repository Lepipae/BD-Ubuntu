DROP SCHEMA IF EXISTS inmobiliaria;
CREATE SCHEMA inmobiliaria DEFAULT CHAR SET utf8mb4;
USE inmobiliaria;
CREATE TABLE propietario (
id BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(20) NOT NULL,
telefono CHAR(9) NOT NULL,
apellido1 VARCHAR(30) NOT NULL,
apellido2 VARCHAR(30),
nacion VARCHAR(45) NOT NULL
);

CREATE TABLE empleado (
id BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(45) NOT NULL,
email VARCHAR(45) NOT NULL UNIQUE,
fechaIni VARCHAR(45)
);

CREATE TABLE inmueble (
id BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
direccion TEXT NOT NULL,
codPostal CHAR(5) NOT NULL,
detalle TEXT,
idPropietario BIGINT,
idEmpleado BIGINT,
FOREIGN KEY (idPropietario) REFERENCES propietario(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (idEmpleado) REFERENCES empleado(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE dormitorio (
idInmueble BIGINT UNIQUE,
numero INT CHECK(numero > 0),
capacidad SMALLINT CHECK(capacidad > 0),
precio DECIMAL(5,2) CHECK(precio > 0),
calidad VARCHAR(9) CHECK(calidad IN ('mala', 'regular', 'buena', 'muy buena')),
FOREIGN KEY (idInmueble) REFERENCES inmueble(id) ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY (idInmueble, numero)
);

ALTER TABLE propietario ADD email VARCHAR(320) UNIQUE NOT NULL;
ALTER TABLE empleado ADD fechaFin DATE;
ALTER TABLE empleado ALTER COLUMN fechaFin SET DEFAULT '9999-12-31';
ALTER TABLE propietario ADD direccion VARCHAR(45) AFTER apellido2;
ALTER TABLE dormitorio ADD idDormitorio BIGINT FIRST;
ALTER TABLE empleado MODIFY fechaFin DATETIME;
ALTER TABLE empleado MODIFY email VARCHAR(320);
ALTER TABLE propietario CHANGE nacion pais VARCHAR(45);
ALTER TABLE empleado DROP COLUMN fechaFin;
RENAME TABLE dormitorio TO habitaciones;
ALTER TABLE inmueble DROP FOREIGN KEY inmueble_ibfk_1; 
ALTER TABLE inmueble ADD CONSTRAINT fk_inmueble_empleado FOREIGN KEY (idEmpleado) REFERENCES empleado(id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE habitaciones DROP PRIMARY KEY;
ALTER TABLE habitaciones ADD PRIMARY KEY (idInmueble, numero);

DROP TABLE habitaciones;
CREATE TABLE habitacion (
idInmueble BIGINT UNSIGNED,
numero INT UNSIGNED,
capacidad SMALLINT UNSIGNED,
precio DECIMAL(5,2),
calidad VARCHAR(9)
);

CREATE INDEX pk_habitacion ON habitacion (idInmueble, numero);
DROP INDEX pk_habitacion ON habitacion;
ALTER TABLE habitacion ADD PRIMARY KEY (idInmueble, numero);
ALTER TABLE habitacion MODIFY COLUMN idInmueble BIGINT;
ALTER TABLE habitacion ADD CONSTRAINT fk_habitacion_inmueble FOREIGN KEY (idInmueble) REFERENCES inmueble(id) ON DELETE CASCADE ON UPDATE CASCADE;
DROP INDEX email ON propietario;
CREATE UNIQUE INDEX idx_email ON propietario (email);

SHOW TABLES;