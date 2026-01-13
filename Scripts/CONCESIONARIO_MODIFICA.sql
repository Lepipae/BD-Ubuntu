USE concesionario;
CREATE INDEX indice_fechaventa ON venta(fechaventa);
DROP INDEX indice_fechaventa ON venta;
ALTER TABLE cliente DROP PRIMARY KEY;

