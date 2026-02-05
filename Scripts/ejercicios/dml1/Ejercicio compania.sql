USE company;

-- 2.2 Crea la consulta para recuperar las oficinas y la ciudad
SELECT office, city FROM offices;
-- 2.3 Crea la consulta para mostrar la oficina, el objetivo (target) y las ventas (sales)
SELECT office, target, sales FROM offices;
-- 2.4 Crea la consulta para obtener la diferencia que se da en cada oficina entre la venta real y el objetivo
SELECT sales - target FROM offices;
-- 2.5 Crea la consulta para obtener la diferencia que se produce en cada oficina entre la venta real y el
-- objetivo. Crea un alias para la columna con la diferencia.
SELECT sales - target AS diferencia FROM offices;
-- 