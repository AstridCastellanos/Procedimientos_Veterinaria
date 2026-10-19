# Sistema de Base de Datos para Veterinaria

Este taller contiene el desarrollo de una BD relacional para una veterinaria, junto con la implementación de 19 procedimientos almacenados en MySQL para la gestión de clientes, mascotas y sus servicios.

## Documentos

*   **DDL.sql**: Script con la creación de la BD, las tablas, llaves primarias, llaves foráneas.
*   **DML.sql**: Script con la inserción de 10 registros para cada una de las tablas de la BD.
*   **DQL.sql**: Script con la creación de los 19 procedimientos almacenados solicitados en el taller.

## Requisitos y Tecnologías

*   **MySQL** (Versión 8.0 o superior).
*   Gestor de BDs.

## ¿Cómo ejecutar y probar el proyecto?

1. Ejecute el archivo `DDL.sql` para crear la base de datos, las tablas y  el archivo `DML.sql` para insertar los registros iniciales.
2. Ejecute cada procedimiento del archivo `DQL.sql` para cargar todos los procedimientos almacenados.
3. Para probar cualquier procedimiento, utilice la instrucción `CALL`. Ejemplo:
   ```sql
   -- Procedimiento 1
    CALL sp_insertar_cliente('Astrid Castellanos', 'Moyuta, Jutiapa', 'astrid.corado@gmail.com');
    SELECT * FROM clientes;

    -- Procedimiento 2
    CALL sp_actualizar_estado_cliente(7, 1);
    SELECT * FROM clientes;

    -- Procedimiento 3
    CALL sp_contar_mascotas_cliente(3, @total);
    SELECT @total AS total_mascotas;
    SELECT * FROM mascotas;

    -- Procedimiento 4
    CALL sp_listar_servicios_mascota(6);

    -- Procedimiento 5 
    CALL sp_registrar_servicio_mascota(2, 3, CURDATE());
    SELECT * FROM mascota_servicio;

    -- Procedimiento 6
    CALL sp_eliminar_mascota(10);
    SELECT * FROM mascotas;

    -- Procedimiento 7
    CALL sp_actualizar_precio_servicio(1, 160.00);
    SELECT * FROM servicios;

    -- Procedimiento 8
    CALL sp_contar_servicios_mascota(1, @total_serv);
    SELECT @total_serv AS total_servicios;
    SELECT * FROM mascota_servicio;

    -- Procedimiento 9
    CALL sp_incrementar_precio_servicios(10.00);
    SELECT * FROM servicios;

    -- Procedimiento 10
    CALL sp_repetir_registro_servicio(1, 2, 3);
    SELECT * FROM mascota_servicio;

    -- Procedimiento 11
    CALL sp_verificar_correo('maria.lopz@gmail.com');
    SELECT * FROM clientes;

    -- Procedimiento 12
    CALL sp_aumentar_estatura_mascotas(0.05);
    SELECT * FROM mascotas;

    -- Procedimiento 13
    CALL sp_clasificar_mascotas();

    -- Procedimiento 14
    CALL sp_contar_clientes_activos(@activos);
    SELECT @activos AS clientes_activos;
    SELECT * FROM clientes;

    -- Procedimiento 15
    CALL sp_actualizar_mascota(1, 'Firulais II', 0.40);
    SELECT * FROM mascotas WHERE IdMascota = 1;

    -- Procedimiento 16
    CALL sp_eliminar_servicio_nombre('Microchip');
    SELECT * FROM servicios;

    -- Procedimiento 17
    CALL sp_listar_mascotas_cliente(1);

    -- Procedimiento 18
    CALL sp_transferir_mascota(1, 2);
    SELECT * FROM mascotas;
    
    -- Procedimiento 19
    CALL sp_registrar_multiples_servicios(2, '1,2,3');
    SELECT * FROM mascota_servicio;