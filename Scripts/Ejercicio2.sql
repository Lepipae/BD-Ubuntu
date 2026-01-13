DROP DATABASE IF EXISTS concesionario;
CREATE DATABASE concesionario CHARACTER SET utf8mb4;
USE concesionario;

CREATE TABLE datosPersonales (
    dni VARCHAR(9) PRIMARY KEY, 
    nombre VARCHAR(45) NOT NULL,
    apellidos VARCHAR(45) NOT NULL,
    domicilio VARCHAR(45),
    fechaAlta DATE NOT NULL,
    tipo VARCHAR(2)
);

CREATE TABLE director (
    dni VARCHAR(9) PRIMARY KEY,
    fechaCargo DATE NOT NULL,
    FOREIGN KEY (dni) REFERENCES datosPersonales(dni)
);

CREATE TABLE comercial (
    dni VARCHAR(9) PRIMARY KEY,
    comision FLOAT,
    FOREIGN KEY (dni) REFERENCES datosPersonales(dni)
);


CREATE TABLE cliente (
    dni VARCHAR(9) PRIMARY KEY,
    idCliente INT NOT NULL,
    FOREIGN KEY (dni) REFERENCES datosPersonales(dni)
);

CREATE TABLE oficina (
    codOficina VARCHAR(4) PRIMARY KEY,
    direccion VARCHAR(45),
    fechaApertura DATE NOT NULL, 
    dniDirector VARCHAR(9) NOT NULL, 
    FOREIGN KEY (dniDirector) REFERENCES director(dni)
);

CREATE TABLE vendedor (
    dni VARCHAR(9) PRIMARY KEY,
    turno VARCHAR(1),
    idOficina VARCHAR(4), 
    FOREIGN KEY (idOficina) REFERENCES oficina(codOficina),
    FOREIGN KEY (dni) REFERENCES datosPersonales(dni)
);

CREATE TABLE titulo (
    codTitulo VARCHAR(2) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE tituloDirector (
    codTitulo VARCHAR(2) NOT NULL,
    dniDirector VARCHAR(9) NOT NULL,
    PRIMARY KEY (codTitulo, dniDirector),
    FOREIGN KEY (codTitulo) REFERENCES titulo(codTitulo),
    FOREIGN KEY (dniDirector) REFERENCES director(dni)
);