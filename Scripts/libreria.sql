-- -----------------------------------------------------
-- 1. CREACIÓN DE LA TABLA
-- -----------------------------------------------------
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Empleado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Empleado` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Empleado` (
  `idEmpleado` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `cargo` VARCHAR(45) NOT NULL,
  `salario` INT NOT NULL,
  `fechaContratacion` DATE NOT NULL,
  `Supervisa` INT NULL, 
  PRIMARY KEY (`idEmpleado`),
  UNIQUE INDEX `idEmpleado_UNIQUE` (`idEmpleado` ASC) VISIBLE,
  INDEX `fk_Empleado_Empleado1_idx` (`Supervisa` ASC) VISIBLE,
  CONSTRAINT `fk_Empleado_Empleado1`
    FOREIGN KEY (`Supervisa`)
    REFERENCES `mydb`.`Empleado` (`idEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Proveedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Proveedor` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Proveedor` (
  `idProveedor` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `telefono` INT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProveedor`),
  UNIQUE INDEX `idProveedor_UNIQUE` (`idProveedor` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Editorial`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Editorial` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Editorial` (
  `idEditorial` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `telefono` INT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEditorial`),
  UNIQUE INDEX `idEditorial_UNIQUE` (`idEditorial` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Libro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Libro` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Libro` (
  `idLibro` INT NOT NULL,
  `isbn` INT NOT NULL,
  `titulo` VARCHAR(45) NOT NULL,
  `añoPublicacion` DATE NOT NULL,
  `precio` INT NOT NULL,
  `stock` INT NOT NULL,
  `Editorial_idEditorial` INT NOT NULL,
  PRIMARY KEY (`idLibro`),
  UNIQUE INDEX `idLibro_UNIQUE` (`idLibro` ASC) VISIBLE,
  UNIQUE INDEX `isbn_UNIQUE` (`isbn` ASC) VISIBLE,
  INDEX `fk_Libro_Editorial1_idx` (`Editorial_idEditorial` ASC) VISIBLE,
  CONSTRAINT `fk_Libro_Editorial1`
    FOREIGN KEY (`Editorial_idEditorial`)
    REFERENCES `mydb`.`Editorial` (`idEditorial`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Autor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Autor` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Autor` (
  `idAutor` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `nacionalidad` VARCHAR(45) NOT NULL,
  `fechaNacimiento` DATE NOT NULL,
  PRIMARY KEY (`idAutor`),
  UNIQUE INDEX `idAutor_UNIQUE` (`idAutor` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Cliente`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `mydb`.`Cliente` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Cliente` (
  `idCliente` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `dni` VARCHAR(45) NOT NULL,
  `Libro_idLibro` INT NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `dni_UNIQUE` (`dni` ASC) VISIBLE,
  UNIQUE INDEX `idCliente_UNIQUE` (`idCliente` ASC) VISIBLE,
  INDEX `fk_Cliente_Libro1_idx` (`Libro_idLibro` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Libro1`
    FOREIGN KEY (`Libro_idLibro`)
    REFERENCES `mydb`.`Libro` (`idLibro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Pedido`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `mydb`.`Pedido` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Pedido` (
  `idPedido` INT NOT NULL,
  `fechaPedido` DATE NOT NULL,
  `total` INT NOT NULL,
  `metodoPago` VARCHAR(45) NOT NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idPedido`),
  UNIQUE INDEX `idPedido_UNIQUE` (`idPedido` ASC) VISIBLE,
  INDEX `fk_Pedido_Cliente_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Cliente`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `mydb`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Factura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Factura` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Factura` (
  `idFactura` INT NOT NULL,
  `fechaEmision` DATE NOT NULL,
  `importeTotal` INT NOT NULL,
  `metodoPago` VARCHAR(45) NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  PRIMARY KEY (`idFactura`),
  UNIQUE INDEX `idFactura_UNIQUE` (`idFactura` ASC) VISIBLE,
  INDEX `fk_Factura_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  CONSTRAINT `fk_Factura_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `mydb`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Libro_has_Autor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Libro_has_Autor` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Libro_has_Autor` (
  `Libro_idLibro` INT NOT NULL,
  `Autor_idAutor` INT NOT NULL,
  PRIMARY KEY (`Libro_idLibro`, `Autor_idAutor`),
  INDEX `fk_Libro_has_Autor_Autor1_idx` (`Autor_idAutor` ASC) VISIBLE,
  INDEX `fk_Libro_has_Autor_Libro1_idx` (`Libro_idLibro` ASC) VISIBLE,
  CONSTRAINT `fk_Libro_has_Autor_Libro1`
    FOREIGN KEY (`Libro_idLibro`)
    REFERENCES `mydb`.`Libro` (`idLibro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Libro_has_Autor_Autor1`
    FOREIGN KEY (`Autor_idAutor`)
    REFERENCES `mydb`.`Autor` (`idAutor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Precio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Precio` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Precio` (
  `Valor` INT NOT NULL,
  `Libro_idLibro` INT NOT NULL,
  PRIMARY KEY (`Libro_idLibro`),
  CONSTRAINT `fk_Precio_Libro1`
    FOREIGN KEY (`Libro_idLibro`)
    REFERENCES `mydb`.`Libro` (`idLibro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Libreria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Libreria` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Libreria` (
  `idLibreria` INT NOT NULL,
  `localizacion` VARCHAR(45) NOT NULL,
  `Empleado_idEmpleado` INT NOT NULL,
  PRIMARY KEY (`idLibreria`),
  UNIQUE INDEX `idLibreria_UNIQUE` (`idLibreria` ASC) VISIBLE,
  INDEX `fk_Libreria_Empleado1_idx` (`Empleado_idEmpleado` ASC) VISIBLE,
  CONSTRAINT `fk_Libreria_Empleado1`
    FOREIGN KEY (`Empleado_idEmpleado`)
    REFERENCES `mydb`.`Empleado` (`idEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Libreria_has_Proveedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Libreria_has_Proveedor` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Libreria_has_Proveedor` (
  `Libreria_idLibreria` INT NOT NULL,
  `Proveedor_idProveedor` INT NOT NULL,
  PRIMARY KEY (`Libreria_idLibreria`, `Proveedor_idProveedor`),
  INDEX `fk_Libreria_has_Proveedor_Proveedor1_idx` (`Proveedor_idProveedor` ASC) VISIBLE,
  INDEX `fk_Libreria_has_Proveedor_Libreria1_idx` (`Libreria_idLibreria` ASC) VISIBLE,
  CONSTRAINT `fk_Libreria_has_Proveedor_Libreria1`
    FOREIGN KEY (`Libreria_idLibreria`)
    REFERENCES `mydb`.`Libreria` (`idLibreria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Libreria_has_Proveedor_Proveedor1`
    FOREIGN KEY (`Proveedor_idProveedor`)
    REFERENCES `mydb`.`Proveedor` (`idProveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Libreria_has_Libro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Libreria_has_Libro` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Libreria_has_Libro` (
  `Libreria_idLibreria` INT NOT NULL,
  `Libro_idLibro` INT NOT NULL,
  PRIMARY KEY (`Libreria_idLibreria`, `Libro_idLibro`),
  INDEX `fk_Libreria_has_Libro_Libro1_idx` (`Libro_idLibro` ASC) VISIBLE,
  INDEX `fk_Libreria_has_Libro_Libreria1_idx` (`Libreria_idLibreria` ASC) VISIBLE,
  CONSTRAINT `fk_Libreria_has_Libro_Libreria1`
    FOREIGN KEY (`Libreria_idLibreria`)
    REFERENCES `mydb`.`Libreria` (`idLibreria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Libreria_has_Libro_Libro1`
    FOREIGN KEY (`Libro_idLibro`)
    REFERENCES `mydb`.`Libro` (`idLibro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Libro_has_Proveedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Libro_has_Proveedor` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Libro_has_Proveedor` (
  `Libro_idLibro` INT NOT NULL,
  `Proveedor_idProveedor` INT NOT NULL,
  PRIMARY KEY (`Libro_idLibro`, `Proveedor_idProveedor`),
  INDEX `fk_Libro_has_Proveedor_Proveedor1_idx` (`Proveedor_idProveedor` ASC) VISIBLE,
  INDEX `fk_Libro_has_Proveedor_Libro1_idx` (`Libro_idLibro` ASC) VISIBLE,
  CONSTRAINT `fk_Libro_has_Proveedor_Libro1`
    FOREIGN KEY (`Libro_idLibro`)
    REFERENCES `mydb`.`Libro` (`idLibro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Libro_has_Proveedor_Proveedor1`
    FOREIGN KEY (`Proveedor_idProveedor`)
    REFERENCES `mydb`.`Proveedor` (`idProveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SHOW TABLES

