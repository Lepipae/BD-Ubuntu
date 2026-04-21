-- 1. Crear y usar la base de datos
DROP SCHEMA IF EXISTS redes_sociales_db;
CREATE SCHEMA redes_sociales_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE redes_sociales_db;

-- 2. Creación de tablas
CREATE TABLE usuario (
    idUsuario INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    apellido1 VARCHAR(30) NOT NULL,
    apellido2 VARCHAR(30),
    pais VARCHAR(3) NOT NULL,
    telefono INT,
    fechaNacimiento DATE NOT NULL,
    email VARCHAR(80) NOT NULL,
    PRIMARY KEY (idUsuario)
);

CREATE TABLE redsocial (
    codRS VARCHAR(3) NOT NULL,
    nombre VARCHAR(30),
    url VARCHAR(50) NOT NULL,
    fechaLanzamiento DATE,
    logo BLOB,
    PRIMARY KEY (codRS)
);

CREATE TABLE suscripcion (
    idUsuario INT NOT NULL,
    codRS VARCHAR(3) NOT NULL,
    fechaAlta DATETIME,
    PRIMARY KEY (idUsuario, codRS),
    CONSTRAINT fk_suscripcion_usuario FOREIGN KEY (idUsuario) 
        REFERENCES usuario(idUsuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_suscripcion_redsocial FOREIGN KEY (codRS) 
        REFERENCES redsocial(codRS) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE seguidores (
    idUsuario INT NOT NULL,
    codRS VARCHAR(3) NOT NULL,
    idSeguidor INT NOT NULL,
    PRIMARY KEY (idUsuario, codRS, idSeguidor),
    CONSTRAINT fk_seguidores_suscripcion FOREIGN KEY (idUsuario, codRS) 
        REFERENCES suscripcion(idUsuario, codRS) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_seguidores_usuario FOREIGN KEY (idSeguidor) 
        REFERENCES usuario(idUsuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Inserción de datos

-- Datos para la tabla `usuario`
INSERT INTO usuario (idUsuario, nombre, apellido1, apellido2, pais, telefono, fechaNacimiento, email) VALUES
(1, 'Albeto', 'Martinez', NULL, 'ESP', 999555555, '2000-01-01', 'xx@xx.com'),
(2, 'Juan', 'García', NULL, 'ESP', 999555555, '2000-01-01', 'xx1@xx.com'),
(3, 'Albeto', 'Iglesias', 'Gómez', 'POR', 999555555, '2000-01-01', 'xx2@xx.com'),
(4, 'Marta', 'Martinez', 'García', 'ESP', 999555555, '1990-01-01', 'xx3@xx.com'),
(5, 'María', 'Martinez', NULL, 'ESP', 999555555, '1980-01-01', 'xx4@xx.com'),
(6, 'Laura', 'Nuñez', 'Iglesias', 'POR', 999555555, '1980-10-10', 'xx5@xx.com');

-- Datos para la tabla `redsocial`
INSERT INTO redsocial (codRS, nombre, url, fechaLanzamiento, logo) VALUES
('FBK', 'facebook', 'www.xxxxx.com', NULL, NULL),
('INS', 'instagram', 'www.xxxxx.com', NULL, NULL),
('LIN', 'linkedin', 'www.xxxxx.com', NULL, NULL),
('TKT', 'tiktok', 'www.xxxxx.com', NULL, NULL),
('TWI', 'twitter', 'www.xxxxx.com', NULL, NULL);

-- Datos para la tabla `suscripcion`
INSERT INTO suscripcion (idUsuario, codRS, fechaAlta) VALUES
(1, 'INS', '2020-01-23 03:00:00'),
(1, 'LIN', '2010-01-23 00:55:00'),
(2, 'FBK', '2021-07-23 12:00:00'),
(2, 'TWI', '2018-03-15 23:00:00'),
(3, 'FBK', '2021-07-23 12:00:00'),
(3, 'INS', '2020-01-23 03:00:00'),
(3, 'LIN', '2010-01-23 00:55:00'),
(3, 'TWI', '2018-03-15 23:00:00'),
(4, 'FBK', '2021-07-23 12:00:09'),
(4, 'INS', '2020-09-23 12:00:00'),
(4, 'LIN', '2010-10-23 21:55:00'),
(4, 'TWI', '2018-10-15 23:00:00'),
(5, 'TWI', '2018-10-15 23:00:00');

-- Datos para la tabla `seguidores`
INSERT INTO seguidores (idUsuario, codRS, idSeguidor) VALUES
(1, 'INS', 3),
(1, 'INS', 4),
(1, 'LIN', 3),
(1, 'LIN', 4),
(2, 'FBK', 3),
(2, 'FBK', 4),
(2, 'TWI', 3),
(2, 'TWI', 4),
(3, 'FBK', 4),
(3, 'INS', 4),
(3, 'LIN', 4),
(3, 'TWI', 4),
(4, 'FBK', 3),
(4, 'INS', 3),
(4, 'LIN', 3),
(4, 'TWI', 3);

-- 1. Crea un trigger que al eliminar un usuario inserte un registro en la tabla auditoría con toda la
-- información de la tabla usuario y un campo fechaRegistro con la fechahora en la que se ha realizado
-- el insert.

CREATE TABLE auditoria (
    idUsuario INT NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    apellido1 VARCHAR(30) NOT NULL,
    apellido2 VARCHAR(30),
    pais VARCHAR(3) NOT NULL,
    telefono INT,
    fechaNacimiento DATE NOT NULL,
    email VARCHAR(80) NOT NULL,
    fechaRegistro DATETIME NOT NULL,
    PRIMARY KEY (idUsuario)
);

DROP TRIGGER IF EXISTS logging;
DELIMITER //
CREATE TRIGGER logging BEFORE DELETE ON usuario FOR EACH ROW
BEGIN
	INSERT INTO auditoria (idUsuario, nombre, apellido1, apellido2, pais, telefono, fechaNacimiento, email, fechaRegistro) VALUES (
		OLD.idUsuario,
        OLD.nombre,
        OLD.apellido1,
        OLD.apellido2,
        OLD.pais,
        OLD.telefono,
        OLD.fechaNacimiento,
        OLD.email,
        now()
    );
END //

DELIMITER ;

-- 2. Crea un procedimiento con un cursor que va recorriendo la lista de usuarios e inserta una
-- notificación personalizada para cada uno de ellos en la tabla notificaciones (idUsuario,
-- textoNotificación, fechaRegistro)
CREATE TABLE notificacion (
	idUsuario INT NOT NULL,
    textoNotificacion VARCHAR(100),
    fechaRegistro DATE
);
DROP PROCEDURE IF EXISTS anyadirNotificacion;
DELIMITER //
CREATE PROCEDURE anyadirNotificacion()
BEGIN
	DECLARE usuario INT;
    DECLARE texto VARCHAR(100);
    DECLARE fechaRegistro DATE;
	DECLARE fin BOOLEAN DEFAULT FALSE;
	DECLARE notificaciones CURSOR FOR SELECT idUsuario, "notificacion", now() FROM usuario;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;
    

    
    OPEN notificaciones;
    bucle:LOOP
		FETCH notificaciones INTO usuario, texto, fechaRegistro;
		IF fin THEN
			LEAVE bucle;
		END IF;
        INSERT INTO notificacion (idUsuario, textoNotificacion, fechaRegistro) VALUES (
			usuario,
            texto,
            fechaRegistro
        );
    END LOOP;
    CLOSE notificaciones;
END //
DELIMITER ;


-- 3. Crea una función que calcule el número de redesSociales en las que está matriculado un usuario
DROP FUNCTION IF EXISTS calculoRedes;
DELIMITER //
CREATE FUNCTION calculoRedes(usuario INT) RETURNS INT
READS SQL DATA
BEGIN
	DECLARE num INT;
    SET num = (
    SELECT count(idUsuario) FROM suscripcion
    WHERE idUsuario = usuario
    );
    RETURN num;
END //
DELIMITER ;


-- 4. Crea un procedimiento para registrar suscripciones y seguidores. Los parámetros de entrada son
-- usuario, redsocial y usuario al que se quiere seguir en esa red social. El parámetro de salida indIcará
-- si se ha producido una excepción de sql. Inserta en la tabla suscripción la suscripción del usuario a
-- la redsocial, si esta no existe, con fechaAlta el momento de la insercción y en la tabla seguidores el
-- usuario, la red social y a quién quiere seguir. Esta operación se gestionará siempre como una única
-- transacción.

DROP PROCEDURE IF EXISTS registrarSuscripcion;
DELIMITER //
CREATE PROCEDURE registrarSuscripcion(IN usuario INT, IN red VARCHAR(3), IN usuarioFollow INT, OUT estado SMALLINT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET estado = 1;
		ROLLBACK;
    END;
	SET estado = 0;
	START TRANSACTION;
		IF NOT EXISTS (
        SELECT 1 FROM suscripcion
        WHERE codRS = red
        AND idUsuario = usuario
        ) THEN
			INSERT INTO suscripcion (idUsuario, codRS, fechaAlta) VALUES (
				usuario,
                red,
                now()
            );
        END IF;
        INSERT INTO seguidores (idUsuario, codRS, idSeguidor) VALUES (
			usuario,
            red,
            usuarioFollow
        );
    COMMIT;
END //
DELIMITER ;

-- Ejercicio 1: El muro de los Triggers (Contexto NEW vs OLD y Condicionales)
-- Crea un trigger llamado validar_actualizacion_usuario que se ejecute ANTES de ACTUALIZAR
-- (BEFORE UPDATE) un registro en la tabla usuario. El trigger debe hacer dos cosas:
-- 1. Comprobar si el usuario está intentando cambiar su email a uno inválido. Si el "nuevo" 
--    email no contiene una arroba ('@'), el trigger debe abortar la operación lanzando un error. 
--    (Pista: usa SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email invalido';)
-- 2. Comprobar si el "nuevo" país es diferente al país "antiguo". Si ha cambiado, debes 
--    forzar a que el nuevo país se guarde siempre en mayúsculas. 
--    (Pista: puedes modificar el valor asignándole la función UPPER(nuevo_valor)).

DROP TRIGGER IF EXISTS validar_actualizacion_usuario;
DELIMITER //
CREATE TRIGGER validar_actualizacion_usuario BEFORE UPDATE ON usuario FOR EACH ROW
BEGIN
	IF NEW.email NOT LIKE '%@%' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email invalido';
    END IF;
    IF NEW.pais != OLD.pais THEN
    SET NEW.pais = upper(NEW.pais);
    END IF;
END //
DELIMITER ;

-- Ejercicio 2: El laberinto del Cursor (Orden estricto y Fetch)
-- Crea un procedimiento almacenado llamado premiarRedesPopulares (sin parámetros de entrada). 
-- Este procedimiento debe usar un cursor para recorrer todas las redes sociales registradas 
-- en la tabla redsocial. 
-- 1. Por cada red social, debes contar cuántos usuarios están suscritos a ella en la tabla 
--    suscripcion. (Pista: usa SELECT COUNT(...) INTO variable ...).
-- 2. Si la red social tiene 2 o más suscripciones, debes actualizar su campo fechaLanzamiento 
--    en la tabla redsocial poniendo la fecha de hoy (CURDATE()).
DROP PROCEDURE IF EXISTS premiarRedesPopulares;
DELIMITER //
CREATE PROCEDURE premiarRedesPopulares()
BEGIN
	DECLARE contador INT;
    DECLARE pNombre VARCHAR(3);
    DECLARE salida BOOLEAN DEFAULT FALSE;
    DECLARE c CURSOR FOR SELECT codRS FROM redsocial;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET salida = TRUE;
    OPEN c;
    bucle:LOOP
    
    FETCH c INTO pNombre;
    IF salida THEN
		LEAVE bucle;
    END IF;
    SELECT count(codRS) INTO contador FROM suscripcion WHERE codRS = pNombre;
    IF contador >= 2 THEN
		UPDATE redsocial
        SET fechaLanzamiento = curdate()
        WHERE codRS = pNombre;
    END IF;
    
    END LOOP;
    CLOSE c;
END //
DELIMITER ;

-- Ejercicio 3: El guardián de las Transacciones (Handlers, Rollbacks y Claves Foráneas)
-- Crea un procedimiento llamado altaRedYBetaTester que reciba por parámetro (IN): 
-- p_codRS (VARCHAR 3), p_nombre (VARCHAR 30), p_url (VARCHAR 50), y p_idUsuario (INT). 
-- También tendrá un parámetro de salida (OUT) llamado p_exito (INT).
-- Esta operación debe ser una Transacción:
-- 1. Si ocurre CUALQUIER error SQL, debes capturarlo, hacer que todo vuelva a su estado 
--    original (ROLLBACK) y poner p_exito = 0.
-- 2. Si todo va bien, pondrás p_exito = 1 y guardarás los cambios (COMMIT).
-- 3. El orden de las acciones dentro de la transacción será: primero insertar la nueva red 
--    en redsocial, y luego insertar la suscripción del p_idUsuario a esa red en la tabla 
--    suscripcion (usando NOW() para la fecha de alta).
DROP PROCEDURE IF EXISTS altaRedYBetaTester;
DELIMITER //
CREATE PROCEDURE altaRedYBetaTester(IN p_codRS VARCHAR(3), IN p_nombre VARCHAR(30),IN p_url VARCHAR(50), IN p_idUsuario INT, OUT p_exito INT)
BEGIN
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
		SET p_exito = 0;
        ROLLBACK;
    END;
    START TRANSACTION;
		INSERT INTO redsocial (codRS, nombre, url, fechaLanzamiento) VALUES (
			p_codRS,
            p_nombre,
            p_url,
            curdate()
        );
        INSERT INTO suscripcion (idUsuario, codRS, fechaAlta) VALUES (
			p_idUsuario,
            p_codRS,
            now()
        );
        SET p_exito = 1;
    COMMIT;
END //
DELIMITER ;


-- Ejercicio 4: La trampa de los nombres (Cursores y Variables)
-- Objetivo: Evitar colisiones entre variables locales y columnas, y asegurar que 
-- todas las referencias se actualizan bien.
--
-- Crea un procedimiento almacenado llamado ascenderUsuariosVip (sin parámetros).
-- Este procedimiento debe utilizar un cursor para recorrer TODOS los usuarios de 
-- la tabla usuario. 
--
-- Por cada usuario, debes hacer lo siguiente:
-- 1. Contar el número total de seguidores que tiene ese usuario en la tabla seguidores 
--    (es decir, donde él sea el idUsuario objetivo, sin importar la red social). 
--    Guarda este número en una variable.
-- 2. Si el usuario tiene 3 o más seguidores en total, debes actualizar su registro 
--    en la tabla usuario, cambiando su pais al valor 'VIP'.

DROP PROCEDURE IF EXISTS ascenderUsuariosVip;
DELIMITER //
CREATE PROCEDURE ascenderUsuariosVip()
BEGIN
	DECLARE numSeguidores INT;
    DECLARE codUsuario INT;
    DECLARE si BOOLEAN DEFAULT FALSE;
    DECLARE c CURSOR FOR SELECT idUsuario FROM usuario;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET si = TRUE;
    OPEN c;
    bucle:LOOP
		FETCH c INTO codUsuario;
        IF si THEN
        LEAVE bucle;
        END IF;
        
        SELECT count(idUsuario) INTO numSeguidores FROM seguidores WHERE idUsuario = codUsuario;
        IF numSeguidores >= 3 THEN
        UPDATE usuario
        SET pais = 'VIP'
        WHERE idUsuario = codUsuario;
        END IF;
    END LOOP;
    CLOSE c;
END //
DELIMITER ;

-- Ejercicio 5: El acuerdo de paz (Transacciones, IN/OUT y Orden)
-- Objetivo: Dominar el bloque de transacciones, declarar correctamente las 
-- entradas/salidas y colocar la bandera de éxito en el lugar perfecto.
--
-- Crea un procedimiento almacenado llamado seguirMutuamente. Este procedimiento 
-- va a registrar que dos usuarios se sigan el uno al otro en una misma red social 
-- al mismo tiempo.
--
-- Debe recibir los siguientes parámetros:
-- * usuario1 (Entero)
-- * usuario2 (Entero)
-- * codigoRed (Cadena de 3 caracteres)
-- * exito (Entero, parámetro de salida)
--
-- Reglas de la transacción:
-- 1. Declara explícitamente qué parámetros son de entrada y cuál es de salida. 
--    ¡Revisa bien los nombres para no tener errores tipográficos!
-- 2. Si ocurre CUALQUIER error (por ejemplo, si ya se seguían y da un error de 
--    clave primaria duplicada), debes atraparlo, deshacer los cambios (ROLLBACK) 
--    y poner exito = 0.
-- 3. Si no hay errores, debes insertar DOS registros en la tabla seguidores:
--    - Uno donde usuario1 sigue a usuario2 en esa red.
--    - Otro donde usuario2 sigue a usuario1 en esa red.
-- 4. Si ambas inserciones van bien, pon exito = 1 y guarda los cambios (COMMIT). 
--    ¡Asegúrate de poner la asignación de éxito en el lugar arquitectónicamente correcto!


DROP PROCEDURE IF EXISTS seguirMutuamente;
DELIMITER //
CREATE PROCEDURE seguirMutuamente(IN usuario1 INT, IN usuario2 INT, IN codigoRed VARCHAR(3), OUT exito INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SET exito = 0;
    END;
    START TRANSACTION;
		INSERT INTO seguidores (idUsuario, codRS, idSeguidor) VALUES
        (usuario1, codigoRed, usuario2),
        (usuario2, codigoRed, usuario1);
	SET exito = 1;
    COMMIT;
END //
DELIMITER ;

-- Ejercicio 1: El guardián de los enlaces (Trigger BEFORE INSERT)
-- Contexto: Queremos asegurar que los datos de las nuevas redes sociales sean consistentes antes de guardarlos.
--
-- Crea un trigger llamado validar_nueva_red que se ejecute ANTES de INSERTAR (BEFORE INSERT) 
-- un registro en la tabla redsocial. El trigger debe hacer dos cosas:
-- 1. Comprobar si la url de la nueva red social empieza por la cadena 'www.'. Si no es así, 
--    el trigger debe abortar la inserción lanzando un error. 
--    (Pista: usa SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'URL invalida';).
-- 2. Asegurarse de que el código de la red social (codRS) se guarde siempre en mayúsculas, 
--    independientemente de si el usuario ha hecho el INSERT en minúsculas.

DROP TRIGGER IF EXISTS validar_nueva_red;
DELIMITER //
CREATE TRIGGER validar_nueva_red BEFORE INSERT ON redsocial FOR EACH ROW
BEGIN
	IF NEW.url NOT LIKE 'www.%' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'URL invalida';
    END IF;
    SET NEW.codRS = upper(NEW.codRS);
END //
DELIMITER ;

-- Ejercicio 2: El ranking de actividad (Procedimiento con Cursor)
-- Contexto: Queremos marcar visualmente a los usuarios que son muy activos siguiendo a otras personas.
--
-- Crea un procedimiento almacenado llamado clasificarUsuariosActivos (sin parámetros de entrada). 
-- Este procedimiento debe utilizar un cursor para recorrer TODOS los usuarios de la tabla usuario.
-- 1. Por cada usuario, debes contar a cuántas personas sigue en TOTAL sin importar la red social 
--    (es decir, cuántas veces aparece ese usuario como idSeguidor en la tabla seguidores). 
--    Guarda este número en una variable.
-- 2. Si el usuario sigue a 2 o más personas, debes actualizar su registro en la tabla usuario, 
--    cambiando el valor de su campo apellido2 a la palabra 'Activo'.

DROP PROCEDURE IF EXISTS clasificarUsuariosActivos;
DELIMITER //
CREATE PROCEDURE clasificarUsuariosActivos()
BEGIN
	DECLARE si BOOLEAN DEFAULT FALSE;
    DECLARE id INT;
    DECLARE num INT;
    DECLARE c CURSOR FOR SELECT idUsuario FROM usuario;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET si = TRUE;
    
    OPEN c;
    bucle: LOOP
    FETCH c INTO id;
    IF si THEN
		LEAVE bucle;
    END IF;
    SELECT count(idSeguidor) INTO num FROM seguidores WHERE idSeguidor = id;
    IF num >= 2 THEN
		UPDATE usuario
        SET apellido2 = 'Activo'
        WHERE idUsuario = id;
    END IF;
    END LOOP;
    CLOSE c;
END //
DELIMITER ;

-- Ejercicio 3: El salto de plataforma (Procedimiento con Transacción)
-- Contexto: Necesitamos una función segura para migrar a un usuario de una red social a otra de un solo golpe.
--
-- Crea un procedimiento almacenado llamado cambiarDeRed. Debe recibir por parámetro (IN): 
-- p_idUsuario (INT), p_redAntigua (VARCHAR 3) y p_redNueva (VARCHAR 3). 
-- También tendrá un parámetro de salida (OUT) llamado p_exito (INT).
--
-- Reglas de la transacción:
-- 1. Si ocurre CUALQUIER error SQL (por ejemplo, intentar suscribirle a una red que no existe), 
--    debes capturarlo, deshacer todos los cambios (ROLLBACK) y establecer p_exito = 0.
-- 2. Si no hay errores, el orden de operaciones será:
--    - Primero, insertar una nueva suscripción para el p_idUsuario en la p_redNueva 
--      con la fecha y hora actuales (NOW()).
--    - Segundo, borrar la suscripción de ese mismo usuario en la p_redAntigua.
-- 3. Si ambas operaciones tienen éxito, pondrás p_exito = 1 y guardarás los cambios (COMMIT).

DROP PROCEDURE IF EXISTS cambiarDeRed;
DELIMITER //
CREATE PROCEDURE cambiarDeRed(IN p_idUsuario INT, IN p_redAntigua VARCHAR(3), IN p_redNueva VARCHAR(3), OUT p_exito INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    ROLLBACK;
    SET p_exito = 0;
    END;
    
    START TRANSACTION;
    INSERT INTO suscripcion (idUsuario, codRS, fechaAlta) VALUES (
		p_idUsuario,
        p_redNueva,
        now()
    );
    DELETE FROM suscripcion WHERE idUsuario = p_idUsuario AND p_redAntigua = codRS;
    SET p_exito = 1;
    COMMIT;
END //
DELIMITER ;

-- Ejercicio 4: El espejo mágico (Trigger BEFORE INSERT)
-- Contexto: Queremos evitar datos absurdos en nuestra red social, como que una persona 
-- se siga a sí misma por error o haciendo trampas para ganar seguidores.
--
-- Crea un trigger llamado evitar_autoseguimiento que se ejecute ANTES de INSERTAR 
-- (BEFORE INSERT) un registro en la tabla seguidores. El trigger debe hacer dos cosas:
-- 1. Comprobar si el usuario que sigue (idUsuario) es exactamente el mismo que el 
--    usuario seguido (idSeguidor). Si son iguales, el trigger debe abortar la inserción 
--    lanzando un error.
-- 2. Al igual que en ejercicios anteriores, asegúrate de que el código de la red social 
--    (codRS) se guarde siempre en mayúsculas por seguridad.

DROP TRIGGER IF EXISTS evitar_autoseguimiento;
DELIMITER //
CREATE TRIGGER evitar_autoseguimiento BEFORE INSERT ON seguidores FOR EACH ROW
BEGIN
	IF NEW.idUsuario = NEW.idSeguidor THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No te puedes seguir a ti mismo';
    END IF;
    IF EXISTS(SELECT 1 FROM seguidores WHERE idUsuario = NEW.idUsuario AND idSeguidor = NEW .idSeguidor AND codRS = NEW.codRS) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya sigues a ese usuario';
    END IF;
    SET NEW.codRS = upper(NEW.codRS);
END //
DELIMITER ;

-- Ejercicio 5: El traspaso de poder (Procedimiento con Transacción)
-- Contexto: Cuando un usuario decide darse de baja, le damos la opción de "ceder" todas 
-- sus suscripciones a un amigo antes de eliminar su cuenta por completo.
--
-- Crea un procedimiento almacenado llamado traspasarCuentasYBorrar. 
-- Debe recibir por parámetro (IN): p_id_origen (INT) y p_id_destino (INT). 
-- También tendrá un parámetro de salida (OUT) llamado p_exito (INT).
--
-- Reglas de la transacción:
-- 1. Si ocurre CUALQUIER error SQL (por ejemplo, si el amigo ya estaba suscrito a esa red 
--    y da un error de clave duplicada), debes capturarlo, deshacer todos los cambios (ROLLBACK) 
--    y establecer p_exito = 0.
-- 2. Si no hay errores, el orden de operaciones será:
--    - Primero, ACTUALIZAR (UPDATE) la tabla suscripcion: debes cambiar el idUsuario al 
--      p_id_destino en todas las filas donde el idUsuario actual sea el p_id_origen.
--    - Segundo, ELIMINAR (DELETE) de la tabla usuario al usuario correspondiente al p_id_origen.
-- 3. Si ambas operaciones tienen éxito, pondrás p_exito = 1 y guardarás los cambios (COMMIT).

DROP PROCEDURE IF EXISTS traspasarCuentasYBorrar;
DELIMITER //
CREATE PROCEDURE traspasarCuentasYBorrar(IN p_id_origen INT, IN p_id_destino INT, OUT p_exito INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET p_exito = 0;
        ROLLBACK;
    END;
    START TRANSACTION;
		UPDATE suscripcion
        SET idUsuario = p_id_destino
        WHERE idUsuario = p_id_origen;
        DELETE FROM usuario
        WHERE idUsuario = p_id_origen;
		SET p_exito = 1;
    COMMIT;
END // 
DELIMITER ;

-- Ejercicio 6: El reloj de arena (Función matemática y de fechas)
-- Contexto: Queremos saber cuántos días exactos lleva un usuario registrado en una 
-- red social concreta para poder enviarle premios de fidelidad.
--
-- Crea una función llamada diasSuscrito.
-- Debe recibir por parámetro: p_idUsuario (INT) y p_codRS (VARCHAR 3).
-- Debe DEVOLVER (RETURNS) un valor entero (INT).
--
-- Reglas de la función:
-- 1. Debe buscar la fechaAlta del usuario en esa red social dentro de la tabla suscripcion.
-- 2. Debe calcular la diferencia en días entre la fecha/hora actual y esa fechaAlta. 
--    (Pista: investiga la función DATEDIFF() de MySQL).
-- 3. Si el usuario NO está suscrito a esa red social, la función debe devolver el valor -1. 
--    (Pista: puedes inicializar una variable a -1 y actualizarla solo si el SELECT encuentra algo).

DROP FUNCTION IF EXISTS diasSuscrito;
DELIMITER //
CREATE FUNCTION diasSuscrito(p_idUsuario INT, p_codRS VARCHAR(3))
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE diferencia INT;
    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
		RETURN -1;
    END;
    SELECT datediff(now(), fechaAlta) INTO diferencia FROM suscripcion WHERE p_idUsuario = idUsuario AND codRS = p_codRS;
    RETURN diferencia;
END //
DELIMITER ;

-- Ejercicio 7: El maestro de ceremonias (Función de cadenas y manejo de nulos)
-- Contexto: Para la interfaz gráfica de nuestra aplicación, necesitamos mostrar el nombre 
-- completo de los usuarios, pero algunos no tienen segundo apellido registrado (es NULL) 
-- y no queremos que la pantalla muestre cosas feas como "Juan García NULL".
--
-- Crea una función llamada obtenerNombreCompleto.
-- Debe recibir por parámetro: p_idUsuario (INT).
-- Debe DEVOLVER (RETURNS) una cadena de texto (VARCHAR 100).
--
-- Reglas de la función:
-- 1. Debe buscar en la tabla usuario el nombre, apellido1 y apellido2 correspondientes al p_idUsuario.
-- 2. Debe unir (concatenar) estas partes poniendo un espacio en blanco entre ellas. 
--    (Pista: investiga la función CONCAT() o CONCAT_WS() de MySQL).
-- 3. ¡Cuidado con el apellido2! Si es nulo, la función debe devolver solo el nombre y el 
--    primer apellido sin dejar espacios dobles al final. Puedes resolverlo usando condicionales (IF) 
--    o investigando funciones como IFNULL() o COALESCE().

DROP FUNCTION IF EXISTS obtenerNombreCompleto;
DELIMITER //
CREATE FUNCTION obtenerNombreCompleto(p_idUsuario INT)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
	DECLARE nombreCompleto VARCHAR(100);
    DECLARE nom VARCHAR(30);
    DECLARE ap1 VARCHAR(30);
    DECLARE ap2 VARCHAR(30);
    
    SELECT nombre INTO nom FROM usuario WHERE idUsuario = p_idUsuario;
    SELECT apellido1 INTO ap1 FROM usuario WHERE idUsuario = p_idUsuario;
    SELECT apellido2 INTO ap2 FROM usuario WHERE idUsuario = p_idUsuario;
    
    IF ap2 IS NULL THEN
    SET nombreCompleto = concat_ws(', ', nom, ap1);
    ELSE
    SET nombreCompleto = concat_ws(', ', nom, ap1, ap2);
    END IF;
    SET nombreCompleto = trim(nombreCompleto);
    RETURN nombreCompleto;
END //
DELIMITER ;

-- ==============================================================================
-- RETO 1: EL TRIGGER (Validación avanzada con consultas previas)
-- ==============================================================================
-- Contexto: Queremos evitar la "fuga de talentos". Si un usuario es muy popular 
-- en una red social, no queremos que pueda darse de baja de esa red por error.
--
-- Crea un trigger llamado evitar_fuga_talentos que se ejecute ANTES de ELIMINAR 
-- (BEFORE DELETE) un registro en la tabla suscripcion.
--
-- Reglas:
-- 1. Cuando alguien intente borrar una suscripción, el trigger debe contar cuántos 
--    seguidores tiene ese usuario (OLD.idUsuario) exactamente en esa red social (OLD.codRS).
--    (Pista: Necesitarás declarar una variable dentro del trigger y usar SELECT COUNT... INTO).
-- 2. Si el usuario tiene 2 o más seguidores en esa red, debes abortar el borrado 
--    lanzando un error personalizado (SIGNAL SQLSTATE) que diga: 
--    'No puedes darte de baja, eres demasiado popular'.
DROP TRIGGER IF EXISTS evitar_fuga_talentos;
DELIMITER //
CREATE TRIGGER evitar_fuga_talentos BEFORE DELETE ON suscripcion FOR EACH ROW
BEGIN
	DECLARE numFollows INT;
    SELECT count(idSeguidor) INTO numFollows FROM seguidores WHERE idUsuario = OLD.idUsuario AND codRS = OLD.codRS;
    IF numFollows >= 2 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes darte de baja, eres demasiado popular'; -- Vaya violacion del GDPR por cierto
    END IF;
END //
DELIMITER ;
-- ==============================================================================
-- RETO 2: LA FUNCIÓN (Manejo de cadenas, múltiples consultas y formateo)
-- ==============================================================================
-- Contexto: El equipo de frontend necesita generar enlaces amigables para los 
-- perfiles de los usuarios, combinando datos de tres tablas diferentes.
--
-- Crea una función llamada generarEnlacePerfil.
-- Debe recibir: p_idUsuario (INT) y p_codRS (VARCHAR 3).
-- Debe DEVOLVER: VARCHAR(100). (Recuerda usar READS SQL DATA).
--
-- Reglas:
-- 1. Debe obtener el 'nombre' del usuario de la tabla usuario, y convertirlo todo a 
--    minúsculas. (Pista: usa la función LOWER() de MySQL).
-- 2. Debe obtener la 'url' de la red social de la tabla redsocial.
-- 3. Debe contar el número total de seguidores que tiene ese usuario en esa red social.
-- 4. Debe devolver una única cadena concatenando todo con este formato exacto:
--    "[url]/[nombre]-[numero_seguidores]followers"
--    Ejemplo si todo va bien: "www.xxxxx.com/juan-3followers"
--    (Pista: Investiga la función CONCAT() para unir cadenas y variables).
DROP FUNCTION IF EXISTS generarEnlacePerfil;
DELIMITER //
CREATE FUNCTION generarEnlacePerfil(p_idUsuario INT, p_codRS VARCHAR(3))
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
	
	DECLARE nuevaURL VARCHAR(100);
    DECLARE oldURL VARCHAR(50);
    DECLARE numSeguidores INT;
    SELECT url INTO oldURL FROM redsocial WHERE codRS = p_codRS;
    SELECT count(idSeguidor) INTO numSeguidores FROM seguidores WHERE idUsuario = p_idUsuario AND codRS = p_codRS;
    SELECT concat(oldURL, '/' , lower(nombre), '-', numSeguidores, 'followers') INTO nuevaURL FROM usuario WHERE idUsuario = p_idUsuario; 
	RETURN nuevaURL;
END //
DELIMITER ;
-- ==============================================================================
-- RETO 3: EL PROCEDIMIENTO (El "Jefe Final": Transacciones + Cursores + Excepciones)
-- ==============================================================================
-- Contexto: Vamos a lanzar una campaña donde un usuario "Sponsor" (patrocinador) 
-- va a empezar a seguir automáticamente a todos los usuarios de una red social 
-- que tengan muy pocos seguidores para darles apoyo.
--
-- Crea un procedimiento llamado lanzarCampanyaSponsor.
-- Recibe (IN): p_idSponsor (INT) y p_codRS (VARCHAR 3).
-- Devuelve (OUT): p_exito (INT).
--
-- Reglas:
-- 1. Transacción y Seguridad: Toda la operación debe estar dentro de una transacción. 
--    Si falla cualquier INSERT (ej. el sponsor ya le seguía y da error de clave primaria), 
--    debes capturar la SQLEXCEPTION, hacer ROLLBACK y poner p_exito = 0.
-- 2. Cursor: Debes usar un cursor para recorrer TODOS los idUsuario que estén 
--    suscritos a la red social p_codRS en la tabla suscripcion.
-- 3. Lógica dentro del bucle:
--    - Por cada usuario que saque el cursor, asegúrate de que NO es el propio sponsor 
--      (¡el sponsor no se va a seguir a sí mismo!).
--    - Cuenta cuántos seguidores tiene ese usuario en esa red social.
--    - Si el usuario tiene menos de 2 seguidores (< 2), haz que el p_idSponsor 
--      le siga (INSERT en la tabla seguidores).
-- 4. Cierre: Si el cursor termina de recorrer a todos los usuarios sin que salte 
--    ningún error, guarda los datos (COMMIT) y pon p_exito = 1.
DROP PROCEDURE IF EXISTS lanzarCampanyaSponsor;
DELIMITER //
CREATE PROCEDURE lanzarCampanyaSponsor(IN p_idSponsor INT, IN p_codRS VARCHAR(3), OUT p_exito INT)
BEGIN
	 DECLARE si BOOLEAN DEFAULT FALSE;
     DECLARE target INT;
     DECLARE numSeguidores INT;
     DECLARE c CURSOR FOR SELECT idUsuario FROM suscripcion WHERE codRS = p_codRS;
     DECLARE CONTINUE HANDLER FOR NOT FOUND SET si = TRUE;
     DECLARE EXIT HANDLER FOR SQLEXCEPTION
     BEGIN
		ROLLBACK;
        SET p_exito = 0;
     END;
     OPEN c;
     START TRANSACTION;
		bucle:LOOP
        FETCH c INTO target;
        IF si THEN
        LEAVE bucle;
        END IF;
        IF target != p_idSponsor THEN
			SELECT count(idSeguidor) INTO numSeguidores FROM seguidores WHERE idUsuario = target;
			IF numSeguidores <= 2 THEN
				INSERT INTO seguidores (idUsuario, codRS, idSeguidor) VALUES (
					target,
					p_codRS,
					p_idSponsor
				);
            END IF;
        END IF;
        END LOOP;
		SET p_exito = 1;
     COMMIT;
     CLOSE c;
END //
DELIMITER ;










