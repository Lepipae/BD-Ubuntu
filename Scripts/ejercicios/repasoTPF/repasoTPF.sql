DROP SCHEMA IF EXISTS colegio;
CREATE SCHEMA colegio;
USE colegio;
-- 1. Tabla departamento (No depende de ninguna)
CREATE TABLE departamento (
    id_departamento INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_departamento)
);

-- 2. Tabla ciclo (No depende de ninguna)
CREATE TABLE ciclo (
    id_ciclo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_ciclo)
);

-- 3. Tabla curso_escolar (No depende de ninguna)
CREATE TABLE curso_escolar (
    id_curso_escolar INT UNSIGNED NOT NULL AUTO_INCREMENT,
    anyo_inicio YEAR NOT NULL,
    anyo_fin YEAR NOT NULL,
    PRIMARY KEY (id_curso_escolar)
);

-- 4. Tabla alumno (No depende de ninguna)
CREATE TABLE alumno (
    id_alumno INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nif VARCHAR(9) NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50), -- Sin NN, por lo tanto permite NULL
    fecha_nacimiento DATE NOT NULL,
    PRIMARY KEY (id_alumno)
);

-- 5. Tabla profesor (Depende de departamento)
CREATE TABLE profesor (
    id_profesor INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nif VARCHAR(9) NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    id_departamento INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_profesor),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 6. Tabla modulo (Depende de profesor y ciclo)
CREATE TABLE modulo (
    id_modulo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    horas INT UNSIGNED NOT NULL,
    curso CHAR(2) NOT NULL,
    id_profesor INT UNSIGNED, -- Sin NN para permitir SET NULL
    id_ciclo INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_modulo),
    -- Regla de excepción especificada en la imagen para id_profesor
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (id_ciclo) REFERENCES ciclo(id_ciclo)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 7. Tabla matricula (Depende de alumno, modulo y curso_escolar)
CREATE TABLE matricula (
    id_alumno INT UNSIGNED NOT NULL,
    id_modulo INT UNSIGNED NOT NULL,
    id_curso_escolar INT UNSIGNED NOT NULL,
    -- Clave primaria compuesta por los 3 campos
    PRIMARY KEY (id_alumno, id_modulo, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_modulo) REFERENCES modulo(id_modulo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id_curso_escolar)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
-- Añadimos la columna a la tabla modulo
ALTER TABLE modulo 
ADD COLUMN id_departamento INT UNSIGNED;

-- (Opcional pero muy recomendado) 
-- Como es un ID de un departamento, lo correcto es decirle a MySQL que es una clave foránea:
ALTER TABLE modulo 
ADD FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) 
ON UPDATE CASCADE ON DELETE RESTRICT;

-- 1. Tabla departamento
INSERT INTO departamento (id_departamento, nombre) VALUES 
(1, 'Informática'),
(2, 'Administración');

-- 2. Tabla ciclo
INSERT INTO ciclo (id_ciclo, nombre) VALUES 
(1, 'DAM'),
(2, 'DAW'),
(3, 'ADM'),
(4, 'ASIR');

-- 3. Tabla curso_escolar
INSERT INTO curso_escolar (id_curso_escolar, anyo_inicio, anyo_fin) VALUES 
(1, 2024, 2025),
(2, 2023, 2024);

-- 4. Tabla alumno
INSERT INTO alumno (id_alumno, nif, nombre, apellido1, apellido2, fecha_nacimiento) VALUES 
(1, '11111111R', 'Ana', 'Pérez', NULL, '2000-10-10'),
(2, '22111111R', 'Laura', 'García', 'Martínez', '2005-10-10'),
(3, '33111111R', 'Antonio', 'Martínez', NULL, '2006-10-10'),
(4, '44111111R', 'Carlos', 'González', NULL, '2008-10-10');

-- 5. Tabla profesor
INSERT INTO profesor (id_profesor, nif, nombre, apellido1, apellido2, id_departamento) VALUES 
(1, '22222222R', 'Sandra', 'Pérez', 'González', 1),
(2, '32222222R', 'Pablo', 'Sánchez', 'González', 1),
(3, '42222222R', 'Álvaro', 'García', NULL, 2),
(4, '52222222J', 'Marta', 'García', NULL, 2);

-- 6. Tabla modulo
INSERT INTO modulo (id_modulo, nombre, horas, curso, id_profesor, id_ciclo, id_departamento) VALUES 
(1, 'BD', 150, '1º', 1, 1, 1),
(2, 'BD', 150, '1º', 1, 2, 1),
(3, 'Programación', 200, '1º', 2, 1, 1),
(4, 'Programación', 200, '1º', 2, 2, 1),
(5, 'Aplicaciones Ofimáticas', 100, '2º', 3, 3, 2),
(6, 'Marketing', 50, '2º', 3, 3, 2),
(7, 'Sist. Inf.', 80, '1º', NULL, 1, 1);

-- 7. Tabla matricula
INSERT INTO matricula (id_alumno, id_modulo, id_curso_escolar) VALUES 
(1, 1, 1),
(1, 1, 2),
(2, 2, 2),
(1, 3, 1),
(2, 4, 2),
(3, 5, 1);


-- Implementa una función que calcule el número de alumnos que se han matriculado en un
-- módulo de un curso escolar. Los parámetros de entrada serán los identificadores de
-- módulo y de curso escolar. Si alguno de los parámetro de entrada a la función es “null”,
-- función retornará 0.
DROP FUNCTION IF EXISTS contarAlumnos;
DELIMITER //
CREATE FUNCTION contarAlumnos(modulo INT UNSIGNED, curso INT UNSIGNED) RETURNS INT
READS SQL DATA
BEGIN
	DECLARE total INT UNSIGNED;
    IF modulo IS NULL THEN RETURN 0;
    ELSEIF curso IS NULL THEN RETURN 0;
    END IF;
    SET total = (
		SELECT count(a.nif) FROM alumno a
        JOIN matricula ma ON ma.id_alumno = a.id_alumno
        JOIN modulo mo ON ma.id_modulo = mo.id_modulo
        WHERE mo.id_modulo = modulo 
        AND ma.id_curso_escolar = curso
    );
    
    RETURN total;
END
//
DELIMITER ;
SELECT contarAlumnos(1,1);

-- Implementa un disparador (trigger) que antes de insertar una matrícula compruebe si ya
-- existe una matrícula para ese alumno, en el módulo y curso.
-- Si existe, no se ejecutará el “INSERT” y se creará un mensaje de salida de ejecución
-- indicando que el alumno con el identificador proporcionado ya está matriculado en el
-- módulo proporcionado. El mensaje se puede componer con los identificadores de alumno
-- y módulo.
DROP TRIGGER IF EXISTS comprobarMatricula;
DELIMITER //
CREATE TRIGGER comprobarMatricula
BEFORE INSERT ON matricula FOR EACH ROW
BEGIN
	IF EXISTS (
    SELECT 1 FROM matricula 
    WHERE id_alumno = NEW.id_alumno
    AND id_modulo = NEW.id_modulo
    AND id_curso_escolar = NEW.id_curso_escolar
    ) THEN
		SIGNAL SQLSTATE '67000'
        SET MESSAGE_TEXT = 'El usuario ya existe';
	END IF;
END //
DELIMITER ;

-- Implementa un procedimiento que realice la inserción de un matrícula. Recibirá como
-- parámetros de entrada un identificador de alumno, un identificador de módulo y un
-- identificador curso, y tendrá un parámetro de salida que indicará si ha existido un error o
-- no en la ejecución del procedimiento. La validación de si el alumno está matriculado en el
-- módulo y el curso se realizará implementando esta comprobación en otro procedimiento y
-- llamando a este. Si se realiza correctamente la inserción el parámetro de salida tendrá
-- valor 0. Si no son válidos los parámetros de entrada o si se produce una excepción de
-- SQL el parámetro de salida tendrá valor 1.
DROP PROCEDURE IF EXISTS validacionMatricula;
DELIMITER //
CREATE PROCEDURE validacionMatricula(IN alumno INT UNSIGNED, IN modulo INT UNSIGNED, IN curso INT UNSIGNED)
BEGIN
	IF EXISTS (
    SELECT 1 FROM matricula
    WHERE alumno = id_alumno
    AND modulo = id_modulo
    AND curso = id_curso_escolar
    ) THEN
		SIGNAL SQLSTATE '67000' SET MESSAGE_TEXT = 'El usuario ya existe';
	END IF;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS insercionMatricula;
DELIMITER //
CREATE PROCEDURE insercionMatricula(IN alumno INT UNSIGNED, IN modulo INT UNSIGNED, IN curso INT UNSIGNED, OUT salida INT UNSIGNED)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET salida = 1;
    SET salida = 0;
    CALL validacionMatricula(alumno, modulo, curso);
    INSERT INTO matricula VALUES (alumno, modulo, curso);
END//
DELIMITER ;

-- Implementa un procedimiento que borre toda la información de un alumno a partir del
-- dni. Se deberá validar que el dato de entrada no está vacío y que existe el alumno con el
-- dni proporcionado.

DROP PROCEDURE IF EXISTS eliminarAlumno;
DELIMITER //
CREATE PROCEDURE eliminarAlumno(IN dni VARCHAR(9))
BEGIN
	IF dni IS NOT NULL AND EXISTS (
		SELECT 1 FROM alumno
        WHERE nif = dni
    ) THEN
		DELETE FROM alumno WHERE nif = dni;
	END IF;
END;
DELIMITER ;


-- Implementa una función de devuelva la cadena recibida en mayúsculas y elimine los
-- espacios en blanco al principio y final. Si recibe un valor nulo retornará nulo.
DROP FUNCTION IF EXISTS mayusculas;
DELIMITER //
CREATE FUNCTION mayusculas(texto VARCHAR(100))
	RETURNS VARCHAR(100)
    DETERMINISTIC
BEGIN
    RETURN trim(upper(texto));
END //
DELIMITER ;

-- Implementa un trigger que antes de insertar convierta a mayúsculas los caracteres de
-- nombre, apellido 1 y apellido 2. Utiliza la función del apartado anterior
DROP TRIGGER IF EXISTS convertirMayus;
DELIMITER //
CREATE TRIGGER convertirMayus
BEFORE INSERT ON alumno FOR EACH ROW
BEGIN
	SET NEW.nombre = mayusculas(NEW.nombre);
    SET NEW.apellido1 = mayusculas(NEW.apellido1);
    SET NEW.apellido2 = mayusculas(NEW.apellido2);
END //
DELIMITER ;

-- Utilizando un cursor implementa un procedimiento que muestre el primer apellido, el
-- nombre, el curso (año inicio - año fin), el número total de módulos en los que está
-- matriculado y horas totales de estos. Los parámetros de entrada del procedimiento son el
-- dni y el año de inicio del curso














