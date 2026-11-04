-- =========================================================================
-- Triggers de Chorifly
-- =========================================================================

USE Chorifly;

-- =========================================================================
-- TRIGGERS DE Usuario
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_usuario_insert_val_pass
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.contraseña_usuario) < 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La contraseña debe tener al menos 8 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_val_email
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El correo electrónico no tiene un formato válido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_val_resp_seg
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.respuesta_seguridad) < 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La respuesta de seguridad debe tener al menos 3 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_preg_vacia
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF TRIM(NEW.pregunta_seguridad) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La pregunta de seguridad no puede estar vacía.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_preg_resp_dist
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF LOWER(TRIM(NEW.pregunta_seguridad)) = LOWER(TRIM(NEW.respuesta_seguridad)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La respuesta no puede ser idéntica a la pregunta.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_trim_email
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    SET NEW.email = TRIM(NEW.email);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_trim_pass
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    SET NEW.contraseña_usuario = TRIM(NEW.contraseña_usuario);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_update_val_email
BEFORE UPDATE ON Usuario FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El correo electrónico modificado no es válido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_update_preg_resp_dist
BEFORE UPDATE ON Usuario FOR EACH ROW
BEGIN
    IF LOWER(TRIM(NEW.pregunta_seguridad)) = LOWER(TRIM(NEW.respuesta_seguridad)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La nueva respuesta modificada no puede coincidir con la pregunta.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_update_preg_vacia
BEFORE UPDATE ON Usuario FOR EACH ROW
BEGIN
    IF TRIM(NEW.pregunta_seguridad) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La nueva pregunta de seguridad no puede estar vacía.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_update_trim_email
BEFORE UPDATE ON Usuario FOR EACH ROW
BEGIN
    SET NEW.email = TRIM(NEW.email);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_delete_cascade_pasajero
AFTER DELETE ON Usuario FOR EACH ROW
BEGIN
    DELETE FROM Pasajero WHERE usuario_id = OLD.IDUsuario;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_delete_cascade_empleado
AFTER DELETE ON Usuario FOR EACH ROW
BEGIN
    DELETE FROM Empleado WHERE usuario_id = OLD.IDUsuario;
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Aeropuerto
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_aeropuerto_insert_norm_nombre
BEFORE INSERT ON Aeropuerto FOR EACH ROW
BEGIN
    SET NEW.nombre = UPPER(TRIM(NEW.nombre));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_insert_norm_ciudad
BEFORE INSERT ON Aeropuerto FOR EACH ROW
BEGIN
    SET NEW.ciudad = CONCAT(UPPER(LEFT(TRIM(NEW.ciudad), 1)), LOWER(SUBSTRING(TRIM(NEW.ciudad), 2)));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_insert_norm_pais
BEFORE INSERT ON Aeropuerto FOR EACH ROW
BEGIN
    SET NEW.pais = CONCAT(UPPER(LEFT(TRIM(NEW.pais), 1)), LOWER(SUBSTRING(TRIM(NEW.pais), 2)));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_insert_val_long_nombre
BEFORE INSERT ON Aeropuerto FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.nombre)) < 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nombre del aeropuerto debe tener al menos 5 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_update_val_nombre
BEFORE UPDATE ON Aeropuerto FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.nombre) < 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nombre corregido del aeropuerto debe tener al menos 5 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_update_norm_nombre
BEFORE UPDATE ON Aeropuerto FOR EACH ROW
BEGIN
    SET NEW.nombre = UPPER(TRIM(NEW.nombre));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_update_norm_ciudad
BEFORE UPDATE ON Aeropuerto FOR EACH ROW
BEGIN
    SET NEW.ciudad = CONCAT(UPPER(LEFT(TRIM(NEW.ciudad), 1)), LOWER(SUBSTRING(TRIM(NEW.ciudad), 2)));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_update_norm_pais
BEFORE UPDATE ON Aeropuerto FOR EACH ROW
BEGIN
    SET NEW.pais = CONCAT(UPPER(LEFT(TRIM(NEW.pais), 1)), LOWER(SUBSTRING(TRIM(NEW.pais), 2)));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_insert_val_vacio
BEFORE INSERT ON Aeropuerto FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre) = '' OR TRIM(NEW.ciudad) = '' OR TRIM(NEW.pais) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Ningún campo de ubicación de aeropuerto puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_update_val_vacio
BEFORE UPDATE ON Aeropuerto FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre) = '' OR TRIM(NEW.ciudad) = '' OR TRIM(NEW.pais) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede actualizar aeropuerto dejando campos vacíos.';
    END IF;
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Avion
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_avion_insert_val_capacidad
BEFORE INSERT ON Avion FOR EACH ROW
BEGIN
    IF NEW.capacidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La capacidad del avión debe ser un número positivo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_insert_capacidad_max
BEFORE INSERT ON Avion FOR EACH ROW
BEGIN
    IF NEW.capacidad > 500 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La capacidad del avión no puede superar los 500 asientos en LowCost.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_insert_norm_id
BEFORE INSERT ON Avion FOR EACH ROW
BEGIN
    SET NEW.IDAvion = UPPER(NEW.IDAvion);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_update_val_capacidad
BEFORE UPDATE ON Avion FOR EACH ROW
BEGIN
    IF NEW.capacidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La capacidad modificada del avión debe ser un número positivo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_update_capacidad_max
BEFORE UPDATE ON Avion FOR EACH ROW
BEGIN
    IF NEW.capacidad > 500 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La nueva capacidad modificada no puede superar los 500 asientos.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_update_deshab_asientos
AFTER UPDATE ON Avion FOR EACH ROW
BEGIN
    IF NEW.capacidad <= 0 THEN
        UPDATE Asiento SET disponible = 0 WHERE avion_id = NEW.IDAvion;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_delete_cascade_asientos
AFTER DELETE ON Avion FOR EACH ROW
BEGIN
    DELETE FROM Asiento WHERE avion_id = OLD.IDAvion;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_insert_modelo_vacio
BEFORE INSERT ON Avion FOR EACH ROW
BEGIN
    IF TRIM(NEW.modelo) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El modelo de avión no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_update_modelo_vacio
BEFORE UPDATE ON Avion FOR EACH ROW
BEGIN
    IF TRIM(NEW.modelo) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede modificar un avión dejando el modelo vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_update_norm_id
BEFORE UPDATE ON Avion FOR EACH ROW
BEGIN
    SET NEW.IDAvion = UPPER(NEW.IDAvion);
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Departamento
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_departamento_insert_nombre_vacio
BEFORE INSERT ON Departamento FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nombre del departamento es obligatorio.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_update_nombre_vacio
BEFORE UPDATE ON Departamento FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede actualizar el departamento con un nombre vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_insert_trim_nombre
BEFORE INSERT ON Departamento FOR EACH ROW
BEGIN
    SET NEW.nombre = TRIM(NEW.nombre);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_update_trim_nombre
BEFORE UPDATE ON Departamento FOR EACH ROW
BEGIN
    SET NEW.nombre = TRIM(NEW.nombre);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_insert_val_tipo
BEFORE INSERT ON Departamento FOR EACH ROW
BEGIN
    IF NEW.tipo NOT IN ('Aéreo', 'Terrestre') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El tipo de departamento debe ser Aéreo o Terrestre.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_update_val_tipo
BEFORE UPDATE ON Departamento FOR EACH ROW
BEGIN
    IF NEW.tipo NOT IN ('Aéreo', 'Terrestre') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El tipo de departamento modificado no es válido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_insert_val_longitud
BEFORE INSERT ON Departamento FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.nombre)) < 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nombre del departamento debe tener al menos 3 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_update_val_longitud
BEFORE UPDATE ON Departamento FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.nombre)) < 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nombre modificado del departamento debe tener al menos 3 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_delete_restrict_empleado
BEFORE DELETE ON Departamento FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM Empleado WHERE departamento_id = OLD.IDDepartamento;
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede eliminar un departamento que tiene empleados asociados.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_update_upper_nombre
BEFORE UPDATE ON Departamento FOR EACH ROW
BEGIN
    SET NEW.nombre = UPPER(TRIM(NEW.nombre));
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Servicio
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_servicio_insert_val_precio
BEFORE INSERT ON Servicio FOR EACH ROW
BEGIN
    IF NEW.precio <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El precio del servicio debe ser un valor positivo mayor a cero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_val_precio
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    IF NEW.precio <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El precio actualizado del servicio debe ser mayor a cero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_insert_val_desc_long
BEFORE INSERT ON Servicio FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.descripcion)) < 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La descripción del servicio debe tener al menos 10 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_val_desc_long
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.descripcion)) < 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La nueva descripción modificada debe tener al menos 10 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_insert_precio_max
BEFORE INSERT ON Servicio FOR EACH ROW
BEGIN
    IF NEW.precio > 500000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El precio de un servicio adicional no puede exceder los 500,000.00.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_precio_max
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    IF NEW.precio > 500000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El precio actualizado del servicio supera el límite permitido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_insert_norm_nombre
BEFORE INSERT ON Servicio FOR EACH ROW
BEGIN
    SET NEW.nombre_servicio = UPPER(TRIM(NEW.nombre_servicio));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_norm_nombre
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    SET NEW.nombre_servicio = UPPER(TRIM(NEW.nombre_servicio));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_insert_nombre_vacio
BEFORE INSERT ON Servicio FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre_servicio) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nombre del servicio catálogo no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_nombre_vacio
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre_servicio) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede modificar el nombre del servicio dejándolo vacío.';
    END IF;
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Pasajero
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_val_venc_pas
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF NEW.vencimiento_pasaporte < CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede registrar un pasajero con el pasaporte vencido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_val_nacimiento
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF NEW.fecha_nacimiento > CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La fecha de nacimiento no puede ser futura.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_block_dni
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF OLD.dni_pasajero <> NEW.dni_pasajero THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No está permitido modificar el número de DNI de un pasajero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_block_pasaporte
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF OLD.nro_pasaporte <> NEW.nro_pasaporte THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El número de pasaporte es inmutable y no se puede modificar.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_nombre_vacio
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre_pasajero) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nombre del pasajero no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_apellido_vacio
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF TRIM(NEW.apellido_pasajero) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El apellido del pasajero es obligatorio.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_nombre_vacio
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre_pasajero) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede modificar el nombre del pasajero dejándolo en blanco.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_apellido_vacio
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF TRIM(NEW.apellido_pasajero) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede modificar el apellido del pasajero dejándolo en blanco.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_val_tel_long
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.telefono)) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El teléfono del pasajero debe tener al menos 7 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_val_tel_long
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.telefono)) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nuevo teléfono del pasajero no puede ser inferior a 7 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_norm_pais_emision
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    SET NEW.pais_emision = UPPER(TRIM(NEW.pais_emision));
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Empleado
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_empleado_update_val_sueldo
BEFORE UPDATE ON Empleado FOR EACH ROW
BEGIN
    IF NEW.sueldo <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nuevo sueldo modificado debe ser mayor a cero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_insert_val_dni_long
BEFORE INSERT ON Empleado FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.dni_empleado) <> 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El DNI del empleado debe tener exactamente 8 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_update_val_dni_long
BEFORE UPDATE ON Empleado FOR EACH ROW
BEGIN
    IF OLD.dni_empleado <> NEW.dni_empleado AND CHAR_LENGTH(NEW.dni_empleado) <> 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nuevo DNI corregido debe tener exactamente 8 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_insert_sueldo_min_terr
BEFORE INSERT ON Empleado FOR EACH ROW
BEGIN
    DECLARE v_tipo_dep VARCHAR(20);
    SELECT tipo INTO v_tipo_dep FROM Departamento WHERE IDDepartamento = NEW.departamento_id;
    IF v_tipo_dep = 'Terrestre' AND NEW.sueldo < 500.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error salarial: El sueldo para personal terrestre no puede ser inferior a 500.00.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_update_sueldo_min_terr
BEFORE UPDATE ON Empleado FOR EACH ROW
BEGIN
    DECLARE v_tipo_dep VARCHAR(20);
    SELECT tipo INTO v_tipo_dep FROM Departamento WHERE IDDepartamento = NEW.departamento_id;
    IF v_tipo_dep = 'Terrestre' AND NEW.sueldo < 500.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error salarial: El sueldo modificado para personal terrestre no puede ser menor a 500.00.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_insert_val_tel_long
BEFORE INSERT ON Empleado FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.telefono)) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El teléfono del empleado debe tener al menos 7 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_update_val_tel_long
BEFORE UPDATE ON Empleado FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.telefono)) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nuevo teléfono del empleado no puede ser inferior a 7 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_insert_formato_nombre
BEFORE INSERT ON Empleado FOR EACH ROW
BEGIN
    SET NEW.nombre_empleado = CONCAT(UPPER(LEFT(TRIM(NEW.nombre_empleado), 1)), LOWER(SUBSTRING(TRIM(NEW.nombre_empleado), 2)));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_insert_formato_apellido
BEFORE INSERT ON Empleado FOR EACH ROW
BEGIN
    SET NEW.apellido_empleado = CONCAT(UPPER(LEFT(TRIM(NEW.apellido_empleado), 1)), LOWER(SUBSTRING(TRIM(NEW.apellido_empleado), 2)));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_insert_vacio
BEFORE INSERT ON Empleado FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre_empleado) = '' OR TRIM(NEW.apellido_empleado) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nombre y apellido del empleado no pueden estar vacíos.';
    END IF;
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Asiento
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_asiento_insert_val_codigo
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    IF TRIM(NEW.codigo) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El código de asiento no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_insert_dispon_inicial
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    IF NEW.disponible = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Los asientos nuevos deben registrarse como disponibles.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_insert_norm_id
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    SET NEW.IDAsiento = UPPER(NEW.IDAsiento);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_update_val_codigo
BEFORE UPDATE ON Asiento FOR EACH ROW
BEGIN
    IF TRIM(NEW.codigo) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El código de asiento no puede modificarse quedando vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_insert_val_tipo
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    IF NEW.tipo NOT IN ('Ventana', 'Medio', 'Pasillo') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El tipo de asiento debe ser Ventana, Medio o Pasillo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_update_val_tipo
BEFORE UPDATE ON Asiento FOR EACH ROW
BEGIN
    IF NEW.tipo NOT IN ('Ventana', 'Medio', 'Pasillo') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El tipo de asiento modificado no es válido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_insert_trim_codigo
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    SET NEW.codigo = TRIM(NEW.codigo);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_update_trim_codigo
BEFORE UPDATE ON Asiento FOR EACH ROW
BEGIN
    SET NEW.codigo = TRIM(NEW.codigo);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_update_block_avion
BEFORE UPDATE ON Asiento FOR EACH ROW
BEGIN
    IF OLD.avion_id <> NEW.avion_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No está permitido cambiar un asiento de avión.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_insert_val_long_id
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.IDAsiento) < 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ID del asiento debe tener una longitud válida.';
    END IF;
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Vuelo
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_val_destino
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.origen_id = NEW.destino_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El aeropuerto de destino no puede ser igual al de origen.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_val_salida_futura
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_salida < CURRENT_TIMESTAMP() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La fecha de salida del vuelo no puede ser en el pasado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_val_estado_ini
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.estado IN ('Completado', 'Volando', 'Cancelado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Un nuevo vuelo no puede registrarse con ese estado inicial.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_update_val_fechas
BEFORE UPDATE ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_llegada <= NEW.fecha_hora_salida THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La nueva fecha de llegada debe ser posterior a la de salida.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_update_bloqueo_cancelado
AFTER UPDATE ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.estado = 'Cancelado' THEN
        UPDATE Asiento SET disponible = 0 WHERE avion_id = NEW.avion_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_update_deshab_accidente
AFTER UPDATE ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.estado IN ('Choco', 'Exploto', 'Perdido') THEN
        UPDATE Asiento SET disponible = 0 WHERE avion_id = NEW.avion_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_limite_un_anio
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_salida > NOW() + INTERVAL 1 YEAR THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se pueden programar vuelos con más de un año de anticipación.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_update_limite_un_anio
BEFORE UPDATE ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_salida > NOW() + INTERVAL 1 YEAR THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La reprogramación del vuelo no puede exceder el límite de un año futuro.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_update_val_salida_pasada
BEFORE UPDATE ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_salida < NOW() AND NEW.estado = 'Programado' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La nueva reprogramación de salida del vuelo no puede ser en el pasado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_duracion_minima
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_llegada <= NEW.fecha_hora_salida THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error operativo: La fecha de llegada debe ser posterior a la fecha de salida.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_duplicidad_avion
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Vuelo WHERE avion_id = NEW.avion_id AND estado IN ('Programado', 'Volando')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El avión seleccionado ya se encuentra asignado a un vuelo activo.';
    END IF;
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Boleto
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_boleto_insert_ocupar_asiento
AFTER INSERT ON Boleto FOR EACH ROW
BEGIN
    UPDATE Asiento SET disponible = 0 WHERE IDAsiento = NEW.asiento_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_delete_liberar_asiento
AFTER DELETE ON Boleto FOR EACH ROW
BEGIN
    UPDATE Asiento SET disponible = 1 WHERE IDAsiento = OLD.asiento_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_insert_val_precio_base
BEFORE INSERT ON Boleto FOR EACH ROW
BEGIN
    IF NEW.precio_base <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El precio base del boleto debe ser mayor a cero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_update_liberar_asiento_cambio
AFTER UPDATE ON Boleto FOR EACH ROW
BEGIN
    IF OLD.asiento_id <> NEW.asiento_id THEN
        UPDATE Asiento SET disponible = 1 WHERE IDAsiento = OLD.asiento_id;
        UPDATE Asiento SET disponible = 0 WHERE IDAsiento = NEW.asiento_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_insert_val_fecha_vuelo
BEFORE INSERT ON Boleto FOR EACH ROW
BEGIN
    DECLARE v_fecha_vuelo DATETIME;
    SELECT fecha_hora_salida INTO v_fecha_vuelo FROM Vuelo WHERE IDVuelo = NEW.vuelo_id;
    IF NEW.fecha > v_fecha_vuelo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lógico: La fecha de emisión del boleto no puede ser posterior al despegue del vuelo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_update_val_fecha_vuelo
BEFORE UPDATE ON Boleto FOR EACH ROW
BEGIN
    DECLARE v_fecha_vuelo DATETIME;
    SELECT fecha_hora_salida INTO v_fecha_vuelo FROM Vuelo WHERE IDVuelo = NEW.vuelo_id;
    IF NEW.fecha > v_fecha_vuelo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lógico: Al actualizar, la fecha del boleto no puede quedar posterior al vuelo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_update_val_aumento_abusivo
BEFORE UPDATE ON Boleto FOR EACH ROW
BEGIN
    IF NEW.precio_base > (OLD.precio_base * 3) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error comercial: El nuevo precio base no puede superar el triple del precio anterior.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_insert_generar_pago
AFTER INSERT ON Boleto FOR EACH ROW
BEGIN
    INSERT INTO Pago (pasajero_id, boleto_id, costo_servicios, costo_total, estado)
    VALUES (NEW.pasajero_id, NEW.IDBoleto, 0.00, NEW.precio_base, 'Pendiente');
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_insert_val_sobreventa
BEFORE INSERT ON Boleto FOR EACH ROW
BEGIN
    DECLARE v_capacidad_max INT;
    DECLARE v_vendidos INT;
    SELECT capacidad INTO v_capacidad_max FROM Avion WHERE IDAvion = (SELECT avion_id FROM Vuelo WHERE IDVuelo = NEW.vuelo_id);
    SELECT COUNT(*) INTO v_vendidos FROM Boleto WHERE vuelo_id = NEW.vuelo_id;
    IF v_vendidos >= v_capacidad_max THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El vuelo se encuentra totalmente completo. Capacidad máxima alcanzada.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_delete_cascade_pago
AFTER DELETE ON Boleto FOR EACH ROW
BEGIN
    UPDATE Pago SET estado = 'Cancelado' WHERE boleto_id = OLD.IDBoleto;
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE Pago
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_pago_insert_calc_costo_total
BEFORE INSERT ON Pago FOR EACH ROW
BEGIN
    DECLARE v_precio_base DECIMAL(10,2);
    SELECT precio_base INTO v_precio_base FROM Boleto WHERE IDBoleto = NEW.boleto_id;
    SET NEW.costo_total = v_precio_base + NEW.costo_servicios;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_insert_val_costo_serv
BEFORE INSERT ON Pago FOR EACH ROW
BEGIN
    IF NEW.costo_servicios < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El costo de los servicios adicionales no puede ser negativo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_insert_val_estado_ini
BEFORE INSERT ON Pago FOR EACH ROW
BEGIN
    IF NEW.estado IN ('Robado', 'Devuelto', 'Cancelado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El estado inicial del pago no es válido para un nuevo registro.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_update_proteger_pagado
BEFORE UPDATE ON Pago FOR EACH ROW
BEGIN
    IF OLD.estado = 'Pagado' AND NEW.estado = 'Pendiente' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede revertir un pago que ya ha sido completado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_update_proteger_monto_liquidado
BEFORE UPDATE ON Pago FOR EACH ROW
BEGIN
    IF OLD.estado = 'Pagado' AND NEW.costo_total <> OLD.costo_total THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de auditoría: Está estrictamente prohibido alterar el costo total de un pago realizado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_update_liberar_asiento_nulo
AFTER UPDATE ON Pago FOR EACH ROW
BEGIN
    IF NEW.estado IN ('Cancelado', 'Robado') AND OLD.estado <> NEW.estado THEN
        UPDATE Asiento SET disponible = 1 WHERE IDAsiento = (SELECT asiento_id FROM Boleto WHERE IDBoleto = NEW.boleto_id);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_update_val_costo_serv
BEFORE UPDATE ON Pago FOR EACH ROW
BEGIN
    IF NEW.costo_servicios < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El costo de los servicios adicionales modificado no puede ser negativo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_insert_val_costo_total
BEFORE INSERT ON Pago FOR EACH ROW
BEGIN
    IF NEW.costo_total < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El costo total del pago no puede ser un valor numérico negativo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_update_val_costo_total
BEFORE UPDATE ON Pago FOR EACH ROW
BEGIN
    IF NEW.costo_total < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El costo total del pago modificado no puede ser negativo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_delete_cascade_checkin
AFTER DELETE ON Pago FOR EACH ROW
BEGIN
    DELETE FROM CheckIn WHERE pago_id = OLD.IDPago;
END //
DELIMITER ;


-- =========================================================================
-- TRIGGERS DE CheckIn
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_checkin_insert_bloqueo_sin_pago
BEFORE INSERT ON CheckIn FOR EACH ROW
BEGIN
    DECLARE v_estado_pago VARCHAR(20);
    SELECT estado INTO v_estado_pago FROM Pago WHERE IDPago = NEW.pago_id;
    IF v_estado_pago <> 'Pagado' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede realizar Check-In si la factura no está en estado Pagado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_insert_val_titular
BEFORE INSERT ON CheckIn FOR EACH ROW
BEGIN
    DECLARE v_pasajero_boleto INT;
    SELECT pasajero_id INTO v_pasajero_boleto FROM Boleto WHERE IDBoleto = NEW.boleto_id;
    IF NEW.pasajero_id <> v_pasajero_boleto THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de seguridad: El pasajero del Check-In no coincide con el dueño original del boleto.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_insert_val_vuelo_cancelado
BEFORE INSERT ON CheckIn FOR EACH ROW
BEGIN
    DECLARE v_estado_vuelo VARCHAR(20);
    SELECT estado INTO v_estado_vuelo FROM Vuelo WHERE IDVuelo = NEW.vuelo_id;
    IF v_estado_vuelo = 'Cancelado' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede realizar Check-In para un vuelo que se encuentra cancelado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_insert_val_vuelo_comp
BEFORE INSERT ON CheckIn FOR EACH ROW
BEGIN
    DECLARE v_estado_vuelo VARCHAR(20);
    SELECT estado INTO v_estado_vuelo FROM Vuelo WHERE IDVuelo = NEW.vuelo_id;
    IF v_estado_vuelo = 'Completado' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El vuelo ya finalizó. No se permiten nuevos registros de Check-In.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_insert_val_fecha_coherente
BEFORE INSERT ON CheckIn FOR EACH ROW
BEGIN
    DECLARE v_fecha_boleto DATETIME;
    SELECT fecha INTO v_fecha_boleto FROM Boleto WHERE IDBoleto = NEW.boleto_id;
    IF NOW() < v_fecha_boleto THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La fecha de Check-In no puede ser anterior a la de emisión del boleto.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_insert_norm_puerta
BEFORE INSERT ON CheckIn FOR EACH ROW
BEGIN
    SET NEW.puerta_embarque = UPPER(TRIM(NEW.puerta_embarque));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_update_norm_puerta
BEFORE UPDATE ON CheckIn FOR EACH ROW
BEGIN
    SET NEW.puerta_embarque = UPPER(TRIM(NEW.puerta_embarque));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_insert_puerta_vacia
BEFORE INSERT ON CheckIn FOR EACH ROW
BEGIN
    IF TRIM(NEW.puerta_embarque) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La puerta de embarque no puede estar vacía.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_update_puerta_vacia
BEFORE UPDATE ON CheckIn FOR EACH ROW
BEGIN
    IF TRIM(NEW.puerta_embarque) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede modificar Check-In dejando la puerta de embarque vacía.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_update_block_boleto
BEFORE UPDATE ON CheckIn FOR EACH ROW
BEGIN
    IF OLD.boleto_id <> NEW.boleto_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El boleto asociado al Check-In es inmutable.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_delete_cascade_pago
AFTER DELETE ON CheckIn FOR EACH ROW
BEGIN
    UPDATE Pago SET estado = 'Cancelado' WHERE IDPago = OLD.pago_id;
END //
DELIMITER ;
