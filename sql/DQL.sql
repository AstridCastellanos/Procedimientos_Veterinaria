-- 1. Insertar Cliente
DELIMITER $$
CREATE PROCEDURE sp_insertar_cliente(
	IN p_nombre  VARCHAR(100),
    IN p_direccion VARCHAR(100),
    IN p_correoElectronico VARCHAR(100)
    )
BEGIN
	-- Comprobar si el correo existe
    IF EXISTS (SELECT 1 FROM clientes WHERE correoElectronico = p_correoElectronico) THEN
		SELECT 'Error: El cliente con este correo electrónico ya existe.' AS mensaje_error;
	ELSE
		-- Mensaje para cualquier otro error
        BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SELECT 'Error inesperado: No se pudo insertar el cliente. Verifique los datos.' AS mensaje_error;
			END;

			-- Insertar
			INSERT INTO clientes(nombre, direccion, correoElectronico) 
			VALUES (p_nombre, p_direccion, p_correoElectronico);
			
			SELECT 'Cliente insertado correctamente.' AS mensaje_exito;
		END;
	END IF;
END $$
DELIMITER ;

-- APLICAR ('María López', 'Zona 1, Ciudad de Guatemala', 'maria.lopez@gmail.com', 
CALL sp_insertar_cliente('Astrid Castellanos', 'Moyuta, Jutiapa', 'astrid.corado@gmail.com');
SELECT * FROM clientes;

-- 2. Actualizar Estado del Cliente
DELIMITER $$
CREATE PROCEDURE sp_actualizar_estado_cliente(
	IN p_IdCliente INT,
    IN p_nuevo_estado BOOLEAN
    )
BEGIN
	IF NOT EXISTS (SELECT 1 FROM clientes WHERE IdCliente = p_IdCliente) THEN
		SELECT 'Error: El ID de cliente indicado no existe.' AS mensaje_exito;
    ELSE
		UPDATE clientes
		SET activo = p_nuevo_estado
		WHERE IdCliente = p_IdCliente;
        
        SELECT 'Estado del cliente actualizado correctamente.' AS mensaje_exito;
	END IF;
END $$
DELIMITER ;

-- APLICAR
CALL sp_actualizar_estado_cliente(7, 1);
SELECT * FROM clientes;

-- 3. Contar Mascotas por Cliente
DELIMITER $$
CREATE PROCEDURE sp_contar_mascotas_cliente(
    IN p_IdCliente INT,
    OUT p_total_mascotas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_mascotas 
    FROM mascotas 
    WHERE IdCliente = p_IdCliente;
END $$
DELIMITER ;

-- APLICAR
CALL sp_contar_mascotas_cliente(3, @total);
SELECT @total AS total_mascotas;
SELECT * FROM mascotas;

-- 4. Listar Servicios de una Mascota
DELIMITER $$
CREATE PROCEDURE sp_listar_servicios_mascota(
    IN p_IdMascota INT
)
BEGIN
    SELECT s.nombre AS servicio, s.precio, ms.fecha
    FROM mascota_servicio ms
    INNER JOIN servicios s ON ms.IdServicio = s.IdServicio
    WHERE ms.IdMascota = p_IdMascota;
END $$
DELIMITER ;

-- APLICAR
CALL sp_listar_servicios_mascota(6);

-- 5. Registrar Servicio a Mascota
DELIMITER $$
CREATE PROCEDURE sp_registrar_servicio_mascota(
    IN p_IdMascota INT,
    IN p_IdServicio INT,
    IN p_fecha DATE
)
BEGIN
    INSERT INTO mascota_servicio(IdMascota, IdServicio, fecha)
    VALUES (p_IdMascota, p_IdServicio, p_fecha);
    SELECT 'Servicio registrado correctamente.' AS mensaje_exito;
END $$
DELIMITER ;

-- APLICAR
CALL sp_registrar_servicio_mascota(2, 3, CURDATE());
SELECT * FROM mascota_servicio;

-- 6. Eliminar Mascota
DELIMITER $$
CREATE PROCEDURE sp_eliminar_mascota(
    IN p_IdMascota INT
)
BEGIN
    -- Primero eliminamos los servicios asociados
    DELETE FROM mascota_servicio WHERE IdMascota = p_IdMascota;
    
    -- Luego eliminamos la mascota
    DELETE FROM mascotas WHERE IdMascota = p_IdMascota;
    
    SELECT 'Mascota y sus servicios fueron eliminados correctamente.' AS mensaje_exito;
END $$
DELIMITER ;

-- APLICAR
CALL sp_eliminar_mascota(10);
SELECT * FROM mascotas;

-- 7. Actualizar Precio de Servicio
DELIMITER $$
CREATE PROCEDURE sp_actualizar_precio_servicio(
    IN p_IdServicio INT,
    IN p_nuevo_precio DECIMAL(10,2)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM servicios WHERE IdServicio = p_IdServicio) THEN
        SELECT 'Error: El servicio no existe.' AS mensaje_error;
    ELSE
        UPDATE servicios 
        SET precio = p_nuevo_precio 
        WHERE IdServicio = p_IdServicio;
        SELECT 'Precio actualizado correctamente.' AS mensaje_exito;
    END IF;
END $$
DELIMITER ;

-- APLICAR
CALL sp_actualizar_precio_servicio(1, 160.00);
SELECT * FROM servicios;

-- 8. Contar Servicios por Mascota
DELIMITER $$
CREATE PROCEDURE sp_contar_servicios_mascota(
    IN p_IdMascota INT,
    OUT p_total_servicios INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_servicios 
    FROM mascota_servicio 
    WHERE IdMascota = p_IdMascota;
END $$
DELIMITER ;

-- APLICAR
CALL sp_contar_servicios_mascota(1, @total_serv);
SELECT @total_serv AS total_servicios;
SELECT * FROM mascota_servicio;

-- 9. Incrementar Salario de Servicios
DELIMITER $$
CREATE PROCEDURE sp_incrementar_precio_servicios(
    IN p_porcentaje DECIMAL(5,2)
)
BEGIN
    UPDATE servicios 
    SET precio = precio + (precio * (p_porcentaje / 100));
    SELECT 'Precios incrementados correctamente.' AS mensaje_exito;
END $$
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;

-- APLICAR (Incrementar un 10%)
CALL sp_incrementar_precio_servicios(10.00);
SELECT * FROM servicios;

-- 10. Repetir Registro de Servicio
DELIMITER $$
CREATE PROCEDURE sp_repetir_registro_servicio(
    IN p_IdMascota INT,
    IN p_IdServicio INT,
    IN p_veces INT
)
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    DECLARE v_fecha DATE DEFAULT CURDATE();

    REPEAT
        INSERT INTO mascota_servicio(IdMascota, IdServicio, fecha)
        VALUES (p_IdMascota, p_IdServicio, v_fecha);
        
        SET v_contador = v_contador + 1;
        -- Le sumamos un día a la fecha
        SET v_fecha = DATE_ADD(v_fecha, INTERVAL 1 DAY); 
    UNTIL v_contador > p_veces
    END REPEAT;

    SELECT CONCAT('Servicio registrado ', p_veces, ' veces.') AS mensaje_exito;
END $$
DELIMITER ;

-- APLICAR
CALL sp_repetir_registro_servicio(1, 2, 3);
SELECT * FROM mascota_servicio;

-- 11. Verificar Existencia de Correo Electrónico
DELIMITER $$
CREATE PROCEDURE sp_verificar_correo(
    IN p_correo VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM clientes WHERE correoElectronico = p_correo) THEN
        SELECT 'Error: El correo ya está registrado.' AS mensaje_error;
    ELSE
        SELECT 'El correo está disponible.' AS mensaje_exito;
    END IF;
END $$
DELIMITER ;

-- APLICAR
CALL sp_verificar_correo('maria.lopz@gmail.com');
SELECT * FROM clientes;


-- 12. Aumentar Estatura de Mascotas
DELIMITER $$
CREATE PROCEDURE sp_aumentar_estatura_mascotas(
    IN p_aumento FLOAT
)
BEGIN
    DECLARE v_IdMascota INT;
    DECLARE v_fin INT DEFAULT 0;
    
    -- Declaramos un cursor para recorrer las mascotas
    DECLARE cur_mascotas CURSOR FOR SELECT IdMascota FROM mascotas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = 1;

    OPEN cur_mascotas;
    
    WHILE v_fin = 0 DO
        FETCH cur_mascotas INTO v_IdMascota;
        
        IF v_fin = 0 THEN
            UPDATE mascotas 
            SET estatura = estatura + p_aumento 
            WHERE IdMascota = v_IdMascota;
        END IF;
    END WHILE;
    
    CLOSE cur_mascotas;
    
    SELECT 'Estaturas actualizadas correctamente.' AS mensaje_exito;
END $$
DELIMITER ;

-- APLICAR
CALL sp_aumentar_estatura_mascotas(0.05);
SELECT * FROM mascotas;

-- 13. Clasificar Mascotas por Estatura
DELIMITER $$
CREATE PROCEDURE sp_clasificar_mascotas()
BEGIN
    SELECT nombre, estatura,
        IF(estatura >= 0.40, 'Alta', 'Baja') AS clasificacion
    FROM mascotas;
END $$
DELIMITER ;

-- APLICAR
CALL sp_clasificar_mascotas();

-- 14. Contar Clientes Activos
DELIMITER $$
CREATE PROCEDURE sp_contar_clientes_activos(
    OUT p_total_activos INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_activos 
    FROM clientes 
    WHERE activo = 1;
END $$
DELIMITER ;

-- APLICAR
CALL sp_contar_clientes_activos(@activos);
SELECT @activos AS clientes_activos;
SELECT * FROM clientes;

-- 15. Actualizar Mascota
DELIMITER $$
CREATE PROCEDURE sp_actualizar_mascota(
    IN p_IdMascota INT,
    IN p_nuevo_nombre VARCHAR(20),
    IN p_nueva_estatura FLOAT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM mascotas WHERE IdMascota = p_IdMascota) THEN
        SELECT 'Error: La mascota no existe.' AS mensaje_error;
    ELSE
        UPDATE mascotas 
        SET nombre = p_nuevo_nombre, estatura = p_nueva_estatura 
        WHERE IdMascota = p_IdMascota;
        SELECT 'Mascota actualizada correctamente.' AS mensaje_exito;
    END IF;
END $$
DELIMITER ;

-- APLICAR
CALL sp_actualizar_mascota(1, 'Firulais II', 0.40);
SELECT * FROM mascotas WHERE IdMascota = 1;

-- 16. Eliminar Servicios por Nombre
DELIMITER $$
CREATE PROCEDURE sp_eliminar_servicio_nombre(
    IN p_nombre VARCHAR(50)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM servicios WHERE nombre = p_nombre) THEN
        SELECT 'Error: El servicio no existe.' AS mensaje_error;
    ELSE
        -- Borramos el historial si el servicio ya fue usado
        DELETE FROM mascota_servicio WHERE IdServicio IN (SELECT IdServicio FROM servicios WHERE nombre = p_nombre);
        
        DELETE FROM servicios WHERE nombre = p_nombre;
        SELECT 'Servicio eliminado correctamente.' AS mensaje_exito;
    END IF;
END $$
DELIMITER ;

-- APLICAR
CALL sp_eliminar_servicio_nombre('Microchip');
SELECT * FROM servicios;

-- 17. Listar Mascotas por Cliente
DELIMITER $$
CREATE PROCEDURE sp_listar_mascotas_cliente(
    IN p_IdCliente INT
)
BEGIN
    SELECT IdMascota, nombre, nPatas, estatura 
    FROM mascotas 
    WHERE IdCliente = p_IdCliente;
END $$
DELIMITER ;

-- APLICAR
CALL sp_listar_mascotas_cliente(1);

-- 18. Transferir Mascota a Otro Cliente
DELIMITER $$
CREATE PROCEDURE sp_transferir_mascota(
    IN p_IdMascota INT,
    IN p_nuevo_IdCliente INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM mascotas WHERE IdMascota = p_IdMascota) THEN
        SELECT 'Error: La mascota no existe.' AS mensaje_error;
    ELSEIF NOT EXISTS (SELECT 1 FROM clientes WHERE IdCliente = p_nuevo_IdCliente) THEN
        SELECT 'Error: El nuevo cliente no existe.' AS mensaje_error;
    ELSE
        UPDATE mascotas 
        SET IdCliente = p_nuevo_IdCliente 
        WHERE IdMascota = p_IdMascota;
        SELECT 'Mascota transferida correctamente.' AS mensaje_exito;
    END IF;
END $$
DELIMITER ;

-- APLICAR
CALL sp_transferir_mascota(1, 2);
SELECT * FROM mascotas;

-- 19. Registrar Múltiples Servicios 
DELIMITER $$
CREATE PROCEDURE sp_registrar_multiples_servicios(
    IN p_IdMascota INT,
    IN p_lista_ids VARCHAR(100)
)
BEGIN
    DECLARE v_id_actual VARCHAR(10);
    DECLARE v_posicion INT DEFAULT 1;
    DECLARE v_fecha DATE DEFAULT CURDATE();

    mi_loop: LOOP
        -- Extraemos el primer ID de la lista
        SET v_id_actual = SUBSTRING_INDEX(p_lista_ids, ',', 1);
        
        -- Si ya no hay nada salimos del loop
        IF v_id_actual = '' THEN
            LEAVE mi_loop;
        END IF;

        -- Insertamos el servicio
        INSERT INTO mascota_servicio(IdMascota, IdServicio, fecha)
        VALUES (p_IdMascota, CAST(v_id_actual AS UNSIGNED), v_fecha);

        IF LOCATE(',', p_lista_ids) = 0 THEN
            LEAVE mi_loop;
        END IF;

        -- Quitamos el ID que ya usamos
        SET p_lista_ids = SUBSTRING(p_lista_ids, LOCATE(',', p_lista_ids) + 1);
    END LOOP;

    SELECT 'Los servicios fueron registrados correctamente.' AS mensaje_exito;
END $$
DELIMITER ;

-- APLICAR
CALL sp_registrar_multiples_servicios(2, '1,2,3');
SELECT * FROM mascota_servicio;