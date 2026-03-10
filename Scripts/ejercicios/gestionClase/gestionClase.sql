-- Creación de la base de datos (Opcional, pero recomendado)
CREATE DATABASE IF NOT EXISTS gestion_fp;
USE gestion_fp;

-- ==========================================
-- 1. CREACIÓN DE TABLAS (Ordenadas para evitar errores de Claves Foráneas)
-- ==========================================

-- Tabla: departamento [cite: 31, 32, 33]
CREATE TABLE departamento (
    id_departamento INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_departamento)
);

-- Tabla: ciclo [cite: 28, 29, 30]
CREATE TABLE ciclo (
    id_ciclo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_ciclo)
);

-- Tabla: curso_escolar [cite: 12, 13, 14]
CREATE TABLE curso_escolar (
    id_curso_escolar INT UNSIGNED NOT NULL AUTO_INCREMENT,
    anyo_inicio YEAR NOT NULL,
    anyo_fin YEAR NOT NULL,
    PRIMARY KEY (id_curso_escolar)
);

-- Tabla: alumno [cite: 3, 4, 5, 6, 7]
CREATE TABLE alumno (
    id_alumno INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nif VARCHAR(9) NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    fecha_nacimiento DATE NOT NULL,
    PRIMARY KEY (id_alumno)
);

-- Tabla: profesor [cite: 23, 24, 25, 26, 27]
CREATE TABLE profesor (
    id_profesor INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nif VARCHAR(9) NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    id_departamento INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_profesor),
    CONSTRAINT fk_profesor_departamento 
        FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) 
        ON UPDATE CASCADE ON DELETE RESTRICT -- [cite: 35]
);

-- Tabla: modulo [cite: 15, 16, 17, 18, 19, 20, 21, 22]
CREATE TABLE modulo (
    id_modulo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    horas INT UNSIGNED NOT NULL,
    curso CHAR(2),
    id_profesor INT UNSIGNED,
    id_ciclo INT UNSIGNED NOT NULL,
    id_departamento INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_modulo),
    CONSTRAINT fk_modulo_profesor 
        FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor) 
        ON UPDATE CASCADE ON DELETE SET NULL, -- [cite: 35]
    CONSTRAINT fk_modulo_ciclo 
        FOREIGN KEY (id_ciclo) REFERENCES ciclo(id_ciclo) 
        ON UPDATE CASCADE ON DELETE RESTRICT, -- [cite: 35]
    CONSTRAINT fk_modulo_departamento 
        FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) 
        ON UPDATE CASCADE ON DELETE RESTRICT -- [cite: 35]
);

-- Tabla: matricula [cite: 8, 9, 10]
CREATE TABLE matricula (
    id_alumno INT UNSIGNED NOT NULL,
    id_modulo INT UNSIGNED NOT NULL,
    id_curso_escolar INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_alumno, id_modulo, id_curso_escolar), -- [cite: 34]
    CONSTRAINT fk_matricula_alumno 
        FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno) 
        ON UPDATE CASCADE ON DELETE RESTRICT, -- [cite: 35]
    CONSTRAINT fk_matricula_modulo 
        FOREIGN KEY (id_modulo) REFERENCES modulo(id_modulo) 
        ON UPDATE CASCADE ON DELETE RESTRICT, -- [cite: 35]
    CONSTRAINT fk_matricula_curso 
        FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id_curso_escolar) 
        ON UPDATE CASCADE ON DELETE RESTRICT -- [cite: 35]
);

-- ==========================================
-- 2. INSERCIÓN DE DATOS 
-- ==========================================

-- Datos de departamento [cite: 51, 52]
INSERT INTO departamento (id_departamento, nombre) VALUES
(1, 'Informática'),
(2, 'Administración');

-- Datos de ciclo [cite: 48, 49, 50]
INSERT INTO ciclo (id_ciclo, nombre) VALUES
(1, 'DAM'),
(2, 'DAW'),
(3, 'ADM'),
(4, 'ASIR');

-- Datos de curso_escolar [cite: 47, 49]
INSERT INTO curso_escolar (id_curso_escolar, anyo_inicio, anyo_fin) VALUES
(1, 2024, 2025),
(2, 2023, 2024);

-- Datos de alumno [cite: 45, 46]
INSERT INTO alumno (id_alumno, nif, nombre, apellido1, apellido2, fecha_nacimiento) VALUES
(1, '11111111R', 'Ana', 'Pérez', NULL, '2000-10-10'),
(2, '22111111R', 'Laura', 'García', 'Martínez', '2005-10-10'),
(3, '33111111R', 'Antonio', 'Martínez', NULL, '2006-10-10'),
(4, '44111111R', 'Carlos', 'González', NULL, '2008-10-10');

-- Datos de profesor [cite: 53, 54]
INSERT INTO profesor (id_profesor, nif, nombre, apellido1, apellido2, id_departamento) VALUES
(1, '22222222R', 'Sandra', 'Pérez', 'González', 1),
(2, '32222222R', 'Pablo', 'Sánchez', 'González', 1),
(3, '42222222R', 'Álvaro', 'García', NULL, 2),
(4, '52222222J', 'Marta', 'García', NULL, 2);

-- Datos de modulo [cite: 55, 56]
-- Nota: Se ha ajustado la separación de horas y curso debido al formato del documento original.
INSERT INTO modulo (id_modulo, nombre, horas, curso, id_profesor, id_ciclo, id_departamento) VALUES
(1, 'BD', 150, '1º', 1, 1, 1),
(2, 'BD', 150, '1º', 1, 2, 1),
(3, 'Programación', 200, '1º', 2, 1, 1),
(4, 'Programación', 200, '1º', 2, 2, 1),
(5, 'Aplicaciones Ofimáticas', 100, '2º', 3, 3, 2),
(6, 'Marketing', 50, '2º', 3, 3, 2),
(7, 'Sist. Inf.', 80, '1º', NULL, 1, 1);

-- Datos de matricula [cite: 57, 58]
-- Nota: Se corrigieron aparentes errores tipográficos de la lectura (e.g. "23" dividido lógicamente).
INSERT INTO matricula (id_alumno, id_modulo, id_curso_escolar) VALUES
(1, 1, 1),
(1, 1, 2),
(2, 2, 2),
(1, 3, 1),
(2, 4, 2),
(3, 5, 1);