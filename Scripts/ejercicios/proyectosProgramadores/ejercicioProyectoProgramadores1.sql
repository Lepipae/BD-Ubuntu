DROP SCHEMA IF EXISTS `proyectosprogramadores` ;
CREATE SCHEMA IF NOT EXISTS `proyectosprogramadores` DEFAULT CHARACTER SET utf8 ;
USE `proyectosprogramadores` ;

DROP TABLE IF EXISTS `sede` ;
CREATE TABLE IF NOT EXISTS `sede` (
`codSede` CHAR(5) NOT NULL,
`nombre` VARCHAR(45) NOT NULL,
`direccion` VARCHAR(45) NOT NULL,
`telefono` VARCHAR(13) NOT NULL,
`email` VARCHAR(145) NOT NULL,
PRIMARY KEY (`codSede`),
UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE);

DROP TABLE IF EXISTS `departamento` ;
CREATE TABLE IF NOT EXISTS `departamento` (
`codDepartamento` CHAR(5) NOT NULL,
`codSede` CHAR(5) NOT NULL,
`nombre` VARCHAR(45) NULL,
`ubicacion` VARCHAR(45) NULL,
PRIMARY KEY (`codDepartamento`, `codSede`),
INDEX `fk_Departamento_Sede_idx` (`codSede` ASC) VISIBLE,
CONSTRAINT `fk_Departamento_Sede`
FOREIGN KEY (`codSede`)
REFERENCES `sede` (`codSede`)
ON DELETE NO ACTION
ON UPDATE NO ACTION);

DROP TABLE IF EXISTS `programador` ;
CREATE TABLE IF NOT EXISTS `programador` (
`codSede` CHAR(5) NOT NULL,
`codDepartamento` CHAR(5) NOT NULL,
`codProgramador` CHAR(5) NOT NULL,
`nombre` VARCHAR(45) NOT NULL,
`apellido1` VARCHAR(45) NOT NULL,
`apellido2` VARCHAR(45) NULL,
`email` VARCHAR(45) NOT NULL,
`tipo` VARCHAR(45) NOT NULL,
`codSedeMentor` CHAR(5) NULL,
`codDepartamentoMentor` CHAR(5) NULL,
`codProgramadorMentor` CHAR(5) NULL,
PRIMARY KEY (`codSede`, `codDepartamento`, `codProgramador`),
UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
INDEX `fk_Programador_Departamento1_idx` (`codDepartamento` ASC, `codSede` ASC) VISIBLE,
INDEX `fk_Programador_Programador1_idx` (`codProgramadorMentor` ASC, `codDepartamentoMentor` ASC, `codSedeMentor` ASC) VISIBLE,
CONSTRAINT `fk_Programador_Departamento1`
FOREIGN KEY (`codDepartamento` , `codSede`)
REFERENCES `departamento` (`codDepartamento` , `codSede`)
ON DELETE NO ACTION
ON UPDATE NO ACTION,
CONSTRAINT `fk_Programador_Programador1`
FOREIGN KEY (`codSedeMentor`, `codDepartamentoMentor`, `codProgramadorMentor`)
REFERENCES `programador` (`codSede`, `codDepartamento`, `codProgramador`)
ON DELETE NO ACTION
ON UPDATE NO ACTION);

DROP TABLE IF EXISTS `equipo` ;
CREATE TABLE IF NOT EXISTS `equipo` (
`codEquipo` CHAR(5) NOT NULL,
`Descripcion` VARCHAR(45) NULL,
`codSedeJefe` CHAR(5) NOT NULL,
`codDepartamentoJefe` CHAR(5) NOT NULL,
`codProgramadorJefe` CHAR(5) NOT NULL,
PRIMARY KEY (`codEquipo`),
INDEX `fk_Equipo_Programador1_idx` (`codSedeJefe` ASC, `codDepartamentoJefe` ASC, `codProgramadorJefe` ASC) VISIBLE,
CONSTRAINT `fk_Equipo_Programador1`
FOREIGN KEY (`codSedeJefe` , `codDepartamentoJefe` , `codProgramadorJefe`)
REFERENCES `programador` (`codSede` , `codDepartamento` , `codProgramador`)
ON DELETE NO ACTION
ON UPDATE NO ACTION);

DROP TABLE IF EXISTS `proyecto` ;
CREATE TABLE IF NOT EXISTS `proyecto` (
`idProyecto` INT NOT NULL AUTO_INCREMENT,
`fechaInicio` DATE NOT NULL,
`fechaFin` DATE NULL,
`descripcion` VARCHAR(45) NOT NULL,
`idProyectoPrincipal` INT NULL,
`codEquipo` CHAR(5) NOT NULL,
PRIMARY KEY (`idProyecto`),
INDEX `fk_Proyecto_Proyecto1_idx` (`idProyectoPrincipal` ASC) VISIBLE,
INDEX `fk_Proyecto_Equipo1_idx` (`codEquipo` ASC) VISIBLE,
CONSTRAINT `fk_Proyecto_Proyecto1`
FOREIGN KEY (`idProyectoPrincipal`)
REFERENCES `proyecto` (`idProyecto`)
ON DELETE NO ACTION
ON UPDATE NO ACTION,
CONSTRAINT `fk_Proyecto_Equipo1`
FOREIGN KEY (`codEquipo`)
REFERENCES `equipo` (`codEquipo`)
ON DELETE NO ACTION
ON UPDATE NO ACTION);

DROP TABLE IF EXISTS `equipoProgramador` ;
CREATE TABLE IF NOT EXISTS `equipoProgramador` (
`codSede` CHAR(5) NOT NULL,
`codDepartamento` CHAR(5) NOT NULL,
`codProgramador` CHAR(5) NOT NULL,
`codEquipo` CHAR(5) NOT NULL,
PRIMARY KEY (`codSede`, `codDepartamento`, `codProgramador`, `codEquipo`),
INDEX `fk_Programador_has_Equipo_Equipo1_idx` (`codEquipo` ASC) VISIBLE,
INDEX `fk_Programador_has_Equipo_Programador1_idx` (`codSede` ASC, `codDepartamento` ASC, `codProgramador` ASC) VISIBLE,
CONSTRAINT `fk_Programador_has_Equipo_Programador1`
FOREIGN KEY (`codSede` , `codDepartamento` , `codProgramador`)
REFERENCES `programador` (`codSede` , `codDepartamento` , `codProgramador`)
ON DELETE NO ACTION
ON UPDATE NO ACTION,
CONSTRAINT `fk_Programador_has_Equipo_Equipo1`
FOREIGN KEY (`codEquipo`)
REFERENCES `equipo` (`codEquipo`)
ON DELETE NO ACTION
ON UPDATE NO ACTION);

INSERT INTO sede (codSede, nombre, direccion, telefono, email) VALUES
('S001', 'Sede Central', 'Calle Mayor 1', '900111222', 'central@empresa.local'),
('S002', 'Sede Norte', 'Avenida Norte 45', '900333444', 'norte@empresa.local'),
('S003', 'Sede Este', 'Calle Levante 12', '+3400555666', 'este@empresa.local'),
('S004', 'Sede Sur', 'Avenida Sur 88', '+34600777888', 'sur@empresa.local');

INSERT INTO departamento (codDepartamento, codSede, nombre, ubicacion) VALUES
('D001', 'S001', 'Desarrollo', 'Planta 1'),
('D002', 'S001', 'Testing', 'Planta 2'),
('D003', 'S001', 'DevOps', 'Planta 3'),
('D001', 'S002', 'Desarrollo', 'Planta Baja'),
('D002', 'S002', 'Testing', 'Planta 1'),
('D003', 'S003', 'DevOps', 'Planta Técnica'),
('D001', 'S003', 'Desarrollo', 'Planta 1'),
('D001', 'S004', 'Desarrollo', 'Planta Principal');

INSERT INTO programador (codSede, codDepartamento, codProgramador, nombre, apellido1, apellido2, email, tipo, codSedeMentor,
codDepartamentoMentor, codProgramadorMentor) VALUES
('S001', 'D001', 'P001', 'Ana', 'García', 'López', 'ana.garcia@empresa.local', 'Senior', NULL, NULL, NULL),
('S001', 'D002', 'P002', 'Luis', 'Martínez', 'Ruiz', 'luis.martinez@empresa.local', 'Senior', NULL, NULL, NULL),
('S002', 'D001', 'P003', 'Marta', 'Sánchez', 'Pérez', 'marta.sanchez@empresa.local', 'Senior', NULL, NULL, NULL),
('S001', 'D003', 'P006', 'Javier', 'Moreno', 'Gil', 'javier.moreno@empresa.local', 'Senior', NULL, NULL, NULL),
('S003', 'D001', 'P007', 'Lucía', 'Navarro', 'Santos', 'lucia.navarro@empresa.local', 'Senior', NULL, NULL, NULL),
('S004', 'D001', 'P008', 'Pedro', 'Romero', 'Vega', 'pedro.romero@empresa.local', 'Senior', NULL, NULL, NULL);

INSERT INTO programador (codSede, codDepartamento, codProgramador, nombre, apellido1, apellido2, email, tipo, codSedeMentor,
codDepartamentoMentor, codProgramadorMentor) VALUES
('S004', 'D001', 'P001', 'Luisa', 'Romero', 'Rodríguez', 'luisa.romero@empresa.local', 'Senior', NULL, NULL, NULL);

INSERT INTO programador (codSede, codDepartamento, codProgramador, nombre, apellido1, apellido2, email, tipo, codSedeMentor,
codDepartamentoMentor, codProgramadorMentor) VALUES
('S001', 'D001', 'P004', 'Carlos', 'López', 'Gómez', 'carlos.lopez@empresa.local', 'Junior', 'S001', 'D001', 'P001'),
('S002', 'D001', 'P005', 'Elena', 'Torres', 'Díaz', 'elena.torres@empresa.local', 'Junior', 'S002', 'D001', 'P003'),
('S001', 'D003', 'P009', 'Raúl', 'Cano', 'López', 'raul.cano@empresa.local', 'Junior', 'S001', 'D003', 'P006'),
('S003', 'D001', 'P010', 'Sara', 'Méndez', 'Ortega', 'sara.mendez@empresa.local', 'Junior', 'S003', 'D001', 'P007'),
('S004', 'D001', 'P011', 'Diego', 'Iglesias', 'Ramos', 'diego.iglesias@empresa.local', 'Junior', 'S004', 'D001', 'P008');

INSERT INTO equipo (codEquipo, descripcion, codSedeJefe, codDepartamentoJefe, codProgramadorJefe) VALUES
('E001', 'Equipo Backend', 'S001', 'D001', 'P001'),
('E002', 'Equipo QA', 'S001', 'D002', 'P002'),
('E003', 'Equipo FullStack', 'S002', 'D001', 'P003'),
('E004', 'Equipo DevOps', 'S001', 'D003', 'P006'),
('E005', 'Equipo Mobile', 'S003', 'D001', 'P007'),
('E006', 'Equipo Backend Sur', 'S004', 'D001', 'P008');

INSERT INTO equipo (codEquipo, descripcion, codSedeJefe, codDepartamentoJefe, codProgramadorJefe) VALUES
('E007', 'Equipo Frontend', 'S001', 'D001', 'P001');

INSERT INTO proyecto (fechaInicio, fechaFin, descripcion, idProyectoPrincipal, codEquipo) VALUES
('2024-01-01', '2025-01-01', 'Sistema de Gestión', NULL, 'E001'),
('2024-02-01', '2025-01-01', 'Módulo Autenticación', 1, 'E001'),
('2024-03-01', '2024-06-01', 'Pruebas Automatizadas', 1, 'E002'),
('2024-02-15', NULL, 'Aplicación Web', NULL, 'E003'),
('2024-04-01', NULL, 'Infraestructura Cloud', NULL, 'E004'),
('2024-04-15', NULL, 'Pipeline CI/CD', 5, 'E004'),
('2024-05-01', NULL, 'App Móvil iOS', NULL, 'E005'),
('2024-05-10', NULL, 'App Móvil Android', 7, 'E005'),
('2024-06-01', NULL, 'Sistema Facturación', NULL, 'E006');

INSERT INTO equipoProgramador (codSede, codDepartamento, codProgramador, codEquipo) VALUES
('S001', 'D001', 'P001', 'E001'),
('S001', 'D001', 'P004', 'E001'),
('S001', 'D002', 'P002', 'E002'),
('S002', 'D001', 'P003', 'E003'),
('S002', 'D001', 'P005', 'E003'),
('S001', 'D003', 'P006', 'E004'),
('S001', 'D003', 'P009', 'E004'),
('S003', 'D001', 'P007', 'E005'),
('S003', 'D001', 'P010', 'E005'),
('S004', 'D001', 'P008', 'E006'),
('S004', 'D001', 'P011', 'E006');

SELECT * FROM departamento;
SELECT * FROM equipo;
SELECT * FROM equipoProgramador;
SELECT * FROM programador;
SELECT * FROM proyecto;
SELECT * FROM sede;

-- 1.Mostrar los subproyectos del proyecto 'Sistema de Gestión'. Un proyecto principal tiene el campo
-- idProyectoPrincipal con valor nulo. Y sólo se almacena un nivel de subproyectos.
SELECT * FROM proyecto
WHERE idProyectoPrincipal = (
	SELECT idProyecto FROM proyecto 
    WHERE descripcion = "Sistema de Gestión"
);
-- 2. Mostrar los proyectos que no se han finalizado
SELECT * FROM proyecto
WHERE fechaFin IS NULL;
-- 3. Mostrar los proyectos del equipo de desarrollo 'Equipo DevOps'cuya fecha es anterior al 2024-04-10
SELECT p.* FROM proyecto p 
JOIN equipo e ON p.codEquipo = e.codEquipo
WHERE e.descripcion = "Equipo DevOps"
AND p.fechaInicio < "2024-04-10";
-- 4. Mostrar los proyectos del equipo de desarrollo 'Equipo DevOps'cuya fecha es anterior al 2024-04-10
-- y el nombre y los apellidos del jefe de dicho equipo. El nombre y los apellidos en una única columna
-- con el separador " "
SELECT p.*, concat_ws(" ", pr.nombre, pr.apellido1, pr.apellido2) FROM proyecto p 
JOIN equipo e ON p.codEquipo = e.codEquipo
JOIN programador pr ON e.codProgramadorJefe = pr.codProgramador
	AND e.codSedeJefe = pr.codSede
    AND e.codDepartamentoJefe = pr.codDepartamento
WHERE e.descripcion = "Equipo DevOps"
AND p.fechaInicio < "2024-04-10";
-- 5. Mostrar los proyectos que no son subproyectos, que comenzaron en el año 2024
SELECT * FROM proyecto
WHERE idProyectoPrincipal IS NULL
AND year(fechaInicio) = 2024;
-- 6. Mostrar los nombres y los apellidos de los programadores de los departamentos 'Desarrollo' y el
-- nombre de la sede en la que trabajan. Ordena el resultado por apellido1, apellido2, nombre
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2, s.nombre FROM programador p
JOIN departamento d ON p.codDepartamento = d.codDepartamento
	AND p.codSede = d.codSede
JOIN sede s ON s.codSede = p.codSede
WHERE d.nombre = "Desarrollo"
ORDER BY p.apellido1, p.apellido2, p.nombre;
-- 7. Mostrar todos los programadores mentores que trabajan en la sede 'Sede Central'
SELECT DISTINCT p.* FROM programador p
JOIN sede s ON p.codSede = s.codSede
WHERE EXISTS (
	SELECT 1 FROM programador pj
	WHERE pj.codProgramadorMentor = p.codProgramador
    AND pj.codSedeMentor = p.codSede
    AND pj.codDepartamentoMentor = p.codDepartamento
)
AND s.nombre = "Sede Central";
-- 8. Mostrar los programadores jefe de cada equipo
SELECT p.nombre FROM programador p
JOIN equipoProgramador ep ON p.codProgramador = ep.codProgramador
JOIN equipo e ON ep.codEquipo = e.codEquipo
WHERE e.codProgramadorJefe = p.codProgramador;
-- 9. Mostrar los programadores de tipo Senior que trabajan en el equipo de los proyecto de proyecto
-- 'Sistema de Gestión', 'Aplicación Web' y 'App Móvil Android'
SELECT DISTINCT p.* FROM programador p
JOIN equipoProgramador ep ON p.codSede = ep.codSede
	AND p.codDepartamento = ep.codDepartamento
    AND p.codProgramador = ep.codProgramador
JOIN proyecto pr ON ep.codEquipo = pr.codEquipo
WHERE p.tipo = 'Senior'
AND pr.descripcion IN ('Sistema de Gestión', 'Aplicación Web', 'App Móvil Android');

-- 10. Muestra todos los programadores y el equipo a los que pertenecen. También se deben mostrar
-- aquellos programadores que no pertenecen a equipos. Los datos deben mostrarse ordenados por
-- apellido1, apellido2 y nombre
SELECT DISTINCT p.*, e.descripcion FROM programador p 
LEFT JOIN equipoProgramador ep ON p.codSede = ep.codSede
	AND p.codDepartamento = ep.codDepartamento
    AND p.codProgramador = ep.codProgramador
LEFT JOIN equipo e ON ep.codEquipo = e.codEquipo
ORDER BY p.apellido1, p.apellido2, p.nombre;
-- 11. Muestra todos los programadores sin equipo
SELECT DISTINCT p.* FROM programador p 
LEFT JOIN equipoProgramador ep ON p.codSede = ep.codSede
	AND p.codDepartamento = ep.codDepartamento
    AND p.codProgramador = ep.codProgramador
WHERE ep.codEquipo IS NULL;
-- 12. Muestra los equipos sin programadores
SELECT DISTINCT e.* FROM equipo e 
LEFT JOIN equipoProgramador ep ON e.codEquipo = ep.codEquipo
WHERE codProgramador IS NULL;
-- 13. Mostrar todos los programadores junto al equipo al que pertenecen. La consulta debe mostrar
-- también los programadores que no están asignados a un equipo y los equipos que no tienen
-- programadores
SELECT DISTINCT p.nombre, p.apellido1, e.descripcion FROM programador p
LEFT JOIN equipoProgramador eq ON p.codSede = eq.codSede
	AND p.codDepartamento = eq.codDepartamento
    AND p.codProgramador = eq.codProgramador
LEFT JOIN equipo e ON eq.codEquipo = e.codEquipo
UNION
SELECT NULL, NULL, e2.descripcion FROM equipo e2
LEFT JOIN equipoProgramador eq2 ON e2.codEquipo = eq2.codEquipo
WHERE eq2.codProgramador IS NULL;



