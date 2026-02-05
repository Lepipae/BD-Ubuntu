DROP DATABASE IF EXISTS instituto;
CREATE DATABASE instituto CHARACTER SET utf8mb4;
USE instituto;
CREATE TABLE alumno (
idAlumno INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nif VARCHAR(9) UNIQUE NOT NULL,
nombre VARCHAR(25) NOT NULL,
apellido1 VARCHAR(50) NOT NULL,
apellido2 VARCHAR(50),
direccion VARCHAR(50) NOT NULL,
codPostal VARCHAR(5) NOT NULL,
telefono VARCHAR(9) NOT NULL,
email VARCHAR(320) NOT NULL,
fechaNacimiento DATE NOT NULL,
sexo CHAR(1) NOT NULL,
idAlumnoMentor INT UNSIGNED,
fechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_Alumno FOREIGN KEY (idAlumnoMentor) REFERENCES alumno(idAlumno) on delete
set null on update cascade,
CONSTRAINT chk_sexoalum CHECK ( sexo in ( 'H', 'M', 'N' ))
);
INSERT INTO alumno (nif, nombre,apellido1, direccion, codPostal,telefono, email, fechaNacimiento, sexo)
VALUES ('99999999G', 'Antonio', 'García', 'Avd. Portugal', '28199', '4444444', 'xx1@xx.xx', '2000-01-01','H');
INSERT INTO alumno (nif, nombre,apellido1, direccion, codPostal,telefono, email, fechaNacimiento, sexo)
VALUES ('99999998G', 'Marta', 'García', 'Avd. Madrid', '28109', '444444433', 'xx2@xx.xx', '2000-02-01','H');
INSERT INTO alumno (nif, nombre,apellido1, direccion, codPostal,telefono, email, fechaNacimiento, sexo)
VALUES ('99999997G', 'Lucas', 'Pérez', 'Avd. Lisboa', '28190', '444444422', 'xx3@xx.xx', '2002-01-01','M');
INSERT INTO alumno (nif, nombre,apellido1, direccion, codPostal,telefono, email, fechaNacimiento, sexo)
VALUES ('99999996G', 'Laura', 'González', 'Avd. Cáceres', '28189', '444444422', 'xx4@xx.xx', '2000-01-11','N');
INSERT INTO alumno (nif, nombre,apellido1, direccion, codPostal,telefono, email, fechaNacimiento, sexo)
VALUES ('99999995G', 'Carmen', 'Pérex', 'Avd. Badajoz', '28179', '444444422', 'xx5@xx.xx', '2010-10-15','M');
INSERT INTO alumno (nif, nombre,apellido1, direccion, codPostal,telefono, email, fechaNacimiento, sexo)
VALUES ('99999996G', 'Manuel', 'Iglesias', 'Avd. Valladolid', '28104', '444444411', 'xx6@xx.xx', '2010-10-15','M');