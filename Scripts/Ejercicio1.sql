DROP DATABASE IF EXISTS inmobiliaria;
CREATE DATABASE inmobiliaria CHARACTER SET utf8mb4;
USE inmobiliaria;
CREATE TABLE propietario (
	id bigint unique not null auto_increment primary key,
    nombre varchar (20) not null,
    telefono char (9) not null,
    apellido1 varchar (30) not null,
    apellido2 varchar (30) not null,
    nacion varchar (45) not null
);
CREATE TABLE empleado (
	id bigint unique not null auto_increment primary key,
	nombre varchar(45) not null,
	email varchar(45) not null unique,
	fechaini varchar(45) not null
);
CREATE TABLE inmueble (
	id bigint unique not null auto_increment primary key,
    direccion text not null,
    codpostal char (5) not null,
    detalle text not null,
    idPropietario bigint not null,
    foreign key (idPropietario) references propietario(id),
    idEmpleado bigint not null,
    foreign key (idEmpleado) references empleado(id)
);
CREATE TABLE dormitorio (
	idInmueble bigint not null,
    foreign key (idInmueble) references inmueble(id),
    numero int not null,
    primary key (idInmueble, numero),
    capacidad smallint not null,
    precio decimal(5,2) not null,
    calidad ENUM('Mala','Regular','Buena','Muy buena') NOT NULL,
    CONSTRAINT chk_numero_positivo CHECK (numero > 0),
    CONSTRAINT chk_capacidad_positiva CHECK (capacidad > 0),
    CONSTRAINT chk_precio_positivo CHECK (precio > 0)	
);
