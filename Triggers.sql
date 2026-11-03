1)  
delimiter //
create trigger validacionUsuario 
before insert on Usuario
for each row
begin
  if char_length(NEW.contraseña_usuario) < 8 then
    signal sqlstate '45000'
    set MESSAGE_TEXT = 'trigger [validacionUsuario] -> Error: La contraseña debe tener al menos 8 caracteres';
  end if;
end //
delimiter ;


2)
delimiter //
create trigger tg_validar_destino_vuelo
before insert on Vuelo
for each row
begin
    if NEW.origen_id = NEW.destino_id then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_destino_vuelo] -> Error: El aeropuerto de destino no puede ser igual al de origen.';
    end if;
end //
delimiter ;


3)
delimiter //
create trigger tg_calcular_costo_total_pago
before insert on Pago
for each row
begin
    declare v_precio_base decimal(10,2);
   
    select precio_base into v_precio_base 
    from Boleto 
    where IDBoleto = NEW.boleto_id;
   
    set NEW.costo_total = v_precio_base + NEW.costo_servicios;
end //
delimiter ;


4)
delimiter //
create trigger tg_ocupar_asiento_boleto
after insert on Boleto
for each row
begin
    update Asiento 
    set disponible = 0 
    where IDAsiento = NEW.asiento_id;
end //
delimiter ;

5)
delimiter //
create trigger tg_validar_vencimiento_pasaporte
before insert on Pasajero
for each row
begin
    if NEW.vencimiento_pasaporte < current_date() then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_vencimiento_pasaporte] -> Error: No se puede registrar un pasajero con el pasaporte vencido.';
    end if;
end //
delimiter ;


6)
delimiter //
create trigger tg_validar_precio_servicio
before insert on Servicio
for each row
begin
    if NEW.precio <= 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_precio_servicio] -> Error: El precio del servicio debe ser un valor positivo mayor a cero.';
    end if;
end //
delimiter ;

7)
delimiter //

create trigger tg_liberar_asiento_cancelado
after delete on Boleto
for each row
begin
    update Asiento 
    set disponible = 1 
    where IDAsiento = OLD.asiento_id;
end //

delimiter ;
8)
delimiter //
create trigger tg_validar_sueldo_empleado_update
before update on Empleado
for each row
begin
    if NEW.sueldo <= 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_sueldo_empleado_update] -> Error: El nuevo sueldo modificado debe ser mayor a cero.';
    end if;
end //
delimiter ;

9)
 delimiter //

create trigger tg_eliminar_pasajero_por_usuario
after delete on Usuario
for each row
begin
    delete from Pasajero 
    where usuario_id = OLD.IDUsuario;
end //

delimiter ;
 
10)
delimiter //
create trigger tg_validar_salida_futura
before insert on Vuelo
for each row
begin
    if NEW.fecha_hora_salida < current_timestamp() then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_salida_futura] -> Error: La fecha de salida del vuelo no puede ser en el pasado.';
    end if;
end //
delimiter ;


11)
 delimiter //
create trigger tg_validar_nacimiento_pasajero
before insert on Pasajero
for each row
begin
    if NEW.fecha_nacimiento > current_date() then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_nacimiento_pasajero] -> Error: La fecha de nacimiento no puede ser futura.';
    end if;
end //
delimiter ;


12)
 delimiter //
create trigger tg_validar_fecha_compra_boleto
before insert on Boleto
for each row
begin
    if NEW.fecha > current_timestamp() then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_fecha_compra_boleto] -> Error: La fecha del boleto no puede ser una fecha futura.';
    end if;
end //
delimiter ;


13)
 delimiter //
create trigger tg_validar_capacidad_avion
before insert on Avion
for each row
begin
    if NEW.capacidad <= 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_capacidad_avion] -> Error: La capacidad del avión debe ser un número positivo.';
    end if;
end //
delimiter ;


14)
  delimiter //
create trigger tg_validar_precio_base_boleto
before insert on Boleto
for each row
begin
    if NEW.precio_base <= 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_precio_base_boleto] -> Error: El precio base del boleto debe ser mayor a cero.';
    end if;
end //
delimiter ;


15)
 delimiter //
create trigger tg_validar_costo_servicios_pago
before insert on Pago
for each row
begin
    if NEW.costo_servicios < 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_costo_servicios_pago] -> Error: El costo de los servicios adicionales no puede ser negativo.';
    end if;
end //
delimiter ;


16)
  delimiter //
create trigger tg_eliminar_empleado_por_usuario
after delete on Usuario
for each row
begin
    delete from Empleado 
    where usuario_id = OLD.IDUsuario;
end //
delimiter ;

17)
  delimiter //
create trigger tg_limpiar_servicios_de_boleto
after delete on Boleto
for each row
begin
    delete from Boleto_Servicio 
    where boleto_id = OLD.IDBoleto;
end //
delimiter ;

18)
  delimiter //
create trigger tg_eliminar_checkin_por_boleto
after delete on Boleto
for each row
begin
    delete from CheckIn 
    where boleto_id = OLD.IDBoleto;
end //
delimiter ;

19)
 delimiter //
create trigger tg_validar_fechas_vuelo_update
before update on Vuelo
for each row
begin
    if NEW.fecha_hora_llegada <= NEW.fecha_hora_salida then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_fechas_vuelo_update] -> Error: La nueva fecha de llegada debe ser posterior a la de salida.';
    end if;
end //
delimiter ;


20)
delimiter //
create trigger tg_validar_precio_servicio_update
before update on Servicio
for each row
begin
    if NEW.precio <= 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_precio_servicio_update] -> Error: El precio actualizado del servicio debe ser mayor a cero.';
    end if;
end //
delimiter ;


21)
delimiter //
create trigger tg_validar_capacidad_avion_update
before update on Avion
for each row
begin
    if NEW.capacidad <= 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_capacidad_avion_update] -> Error: La capacidad modificada del avión debe ser un número positivo.';
    end if;
end //
delimiter ;


22)
 delimiter //
create trigger tg_validar_email_usuario
before insert on Usuario
for each row
begin
    if NEW.email not like '%@%' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_email_usuario] -> Error: El correo electrónico ingresado no tiene un formato válido.';
    end if;
end //
delimiter ;


23)
delimiter //
create trigger tg_validar_longitud_dni_empleado
before insert on Empleado
for each row
begin
    if char_length(NEW.dni_empleado) <> 8 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_longitud_dni_empleado] -> Error: El DNI del empleado debe tener exactamente 8 caracteres.';
    end if;
end //
delimiter ;

24)
delimiter //
create trigger tg_validar_codigo_asiento
before insert on Asiento
for each row
begin
    if trim(NEW.codigo) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_codigo_asiento] -> Error: El código de asiento no puede estar vacío.';
    end if;
end //
delimiter ;


25)
delimiter //
create trigger tg_validar_respuesta_seguridad_longitud
before insert on Usuario
for each row
begin
    if char_length(NEW.respuesta_seguridad) < 3 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_respuesta_seguridad_longitud] -> Error: La respuesta de seguridad debe tener al menos 3 caracteres.';
    end if;
end //
delimiter ;


26)
delimiter //
create trigger tg_validar_estado_inicial_vuelo
before insert on Vuelo
for each row
begin
    if NEW.estado in ('Completado', 'Volando', 'Cancelado') then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_estado_inicial_vuelo] -> Error: Un nuevo vuelo no puede registrarse con ese estado inicial.';
    end if;
end //
delimiter ;


27)
delimiter //
create trigger tg_validar_estado_inicial_pago
before insert on Pago
for each row
begin
    if NEW.estado in ('Robado', 'Devuelto', 'Cancelado') then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_estado_inicial_pago] -> Error: El estado inicial del pago no es válido para un nuevo registro.';
    end if;
end //
delimiter ;


28)
 delimiter //
create trigger tg_asiento_disponible_inicial
before insert on Asiento
for each row
begin
    if NEW.disponible = 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_asiento_disponible_inicial] -> Error: Los asientos nuevos deben registrarse como disponibles.';
    end if;
end //
delimiter ;


29)
  delimiter //
create trigger tg_bloquear_asientos_vuelo_cancelado
after update on Vuelo
for each row
begin
    if NEW.estado = 'Cancelado' then
        update Asiento 
        set disponible = 0 
        where avion_id = NEW.avion_id;
    end if;
end //
delimiter ;

30)
delimiter //
create trigger tg_eliminar_pago_por_checkin
after delete on CheckIn
for each row
begin
    delete from Pago 
    where IDPago = OLD.pago_id;
end //
delimiter ;

31)
  delimiter //
create trigger tg_liberar_asiento_por_cambio
after update on Boleto
for each row
begin
    if OLD.asiento_id <> NEW.asiento_id then
        update Asiento 
        set disponible = 1 
        where IDAsiento = OLD.asiento_id;
    end if;
end //
delimiter ;

32)
delimiter //
create trigger tg_validar_email_usuario_update
before update on Usuario
for each row
begin
    if NEW.email not like '%@%' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_email_usuario_update] -> Error: El nuevo correo electrónico modificado no es válido.';
    end if;
end //
delimiter ;


33)
delimiter //
create trigger tg_bloquear_cambio_dni_pasajero
before update on Pasajero
for each row
begin
    if OLD.dni_pasajero <> NEW.dni_pasajero then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_bloquear_cambio_dni_pasajero] -> Error: No está permitido modificar el número de DNI de un pasajero.';
    end if;
end //
delimiter ;


34)
delimiter //
create trigger tg_bloquear_cambio_pasaporte
before update on Pasajero
for each row
begin
    if OLD.nro_pasaporte <> NEW.nro_pasaporte then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_bloquear_cambio_pasaporte] -> Error: El número de pasaporte es inmutable y no se puede modificar.';
    end if;
end //
delimiter ;


35)
delimiter //
create trigger tg_validar_longitud_dni_empleado_update
before update on Empleado
for each row
begin
    if OLD.dni_empleado <> NEW.dni_empleado and char_length(NEW.dni_empleado) <> 8 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_longitud_dni_empleado_update] -> Error: El nuevo DNI corregido debe tener exactamente 8 caracteres.';
    end if;
end //
delimiter ;


36)
delimiter //
create trigger tg_proteger_pago_realizado
before update on Pago
for each row
begin
    if OLD.estado = 'Pagado' and NEW.estado = 'Pendiente' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_proteger_pago_realizado] -> Error: No se puede revertir un pago que ya ha sido completado.';
    end if;
end //
delimiter ;

 
37)
delimiter //
create trigger tg_validar_nombre_aeropuerto_update
before update on Aeropuerto
for each row
begin
    if char_length(NEW.nombre) < 5 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_nombre_aeropuerto_update] -> Error: El nombre del aeropuerto debe tener al menos 5 caracteres.';
    end if;
end //
delimiter ;


38)
 delimiter //
create trigger tg_bloquear_checkin_sin_pago
before insert on CheckIn
for each row
begin
    declare v_estado_pago varchar(20);
    select estado into v_estado_pago from Pago where IDPago = NEW.pago_id;
    if v_estado_pago <> 'Pagado' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_bloquear_checkin_sin_pago] -> Error: No se puede realizar Check-In si la factura no está en estado Pagado.';
    end if;
end //
delimiter ;

39)
 delimiter //
create trigger tg_validar_nombre_pasajero_vacio
before insert on Pasajero
for each row
begin
    if trim(NEW.nombre_pasajero) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_nombre_pasajero_vacio] -> Error: El nombre del pasajero no puede estar compuesto únicamente por espacios vacíos.';
    end if;
end //
delimiter ;


40)
 delimiter //
create trigger tg_validar_apellido_pasajero_vacio
before insert on Pasajero
for each row
begin
    if trim(NEW.apellido_pasajero) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_apellido_pasajero_vacio] -> Error: El apellido del pasajero es obligatorio y no puede quedar vacío.';
    end if;
end //
delimiter ;


41)
 delimiter //
create trigger tg_validar_descripcion_servicio_longitud
before insert on Servicio
for each row
begin
    if char_length(trim(NEW.descripcion)) < 10 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_descripcion_servicio_longitud] -> Error: La descripción del servicio debe ser más detallada (mínimo 10 caracteres).';
    end if;
end //
delimiter ;


42)
 delimiter //
create trigger tg_validar_pregunta_seguridad_vacia
before insert on Usuario
for each row
begin
    if trim(NEW.pregunta_security) = '' or trim(NEW.pregunta_seguridad) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_pregunta_seguridad_vacia] -> Error: La pregunta de seguridad no puede ser un campo vacío.';
    end if;
end //
delimiter ;


43)
delimiter //
create trigger tg_validar_titular_checkin
before insert on CheckIn
for each row
begin
    declare v_pasajero_boleto int;
    select pasajero_id into v_pasajero_boleto from Boleto where IDBoleto = NEW.boleto_id;
    if NEW.pasajero_id <> v_pasajero_boleto then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_titular_checkin] -> Error de seguridad: El pasajero del Check-In no coincide con el dueño original del boleto.';
    end if;
end //
delimiter ;


44)
delimiter //
create trigger tg_validar_nombre_pasajero_update
before update on Pasajero
for each row
begin
    if trim(NEW.nombre_pasajero) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_nombre_pasajero_update] -> Error: No se puede modificar el nombre del pasajero dejándolo en blanco.';
    end if;
end //
delimiter ;


45)
delimiter //
create trigger tg_validar_apellido_pasajero_update
before update on Pasajero
for each row
begin
    if trim(NEW.apellido_pasajero) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_apellido_pasajero_update] -> Error: No se puede modificar el apellido del pasajero dejándolo en blanco.';
    end if;
end //
delimiter ;


46)
 delimiter //
create trigger tg_validar_descripcion_servicio_update
before update on Servicio
for each row
begin
    if char_length(trim(NEW.descripcion)) < 10 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_descripcion_servicio_update] -> Error: La nueva descripción modificada debe tener al menos 10 caracteres.';
    end if;
end //
delimiter ;


47)
delimiter //
create trigger tg_validar_pregunta_seguridad_update
before update on Usuario
for each row
begin
    if trim(NEW.pregunta_seguridad) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_pregunta_seguridad_update] -> Error: La nueva pregunta de seguridad no puede ser un texto vacío.';
    end if;
end //
delimiter ;

 
48)
 delimiter //
create trigger tg_proteger_monto_pago_liquidado
before update on Pago
for each row
begin
    if OLD.estado = 'Pagado' and NEW.costo_total <> OLD.costo_total then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_proteger_monto_pago_liquidado] -> Error de auditoría: Está estrictamente prohibido alterar el costo total de un pago ya realizado.';
    end if;
end //
delimiter ;


49)
 delimiter //
create trigger tg_deshabilitar_asientos_por_accidente
after update on Vuelo
for each row
begin
    if NEW.estado in ('Choco', 'Exploto', 'Perdido') then
        update Asiento 
        set disponible = 0 
        where avion_id = NEW.avion_id;
    end if;
end //
delimiter ;
 
50)
delimiter //
create trigger tg_liberar_asiento_por_pago_nulo
after update on Pago
for each row
begin
    if NEW.estado in ('Cancelado', 'Robado') and OLD.estado <> NEW.estado then
        update Asiento 
        set disponible = 1 
        where IDAsiento = (select asiento_id from Boleto where IDBoleto = NEW.boleto_id);
    end if;
end //
delimiter ;

51)
 delimiter //
create trigger tg_validar_fecha_boleto_vuelo
before insert on Boleto
for each row
begin
    declare v_fecha_vuelo datetime;
    select fecha_hora_salida into v_fecha_vuelo from Vuelo where IDVuelo = NEW.vuelo_id;
    if NEW.fecha > v_fecha_vuelo then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_fecha_boleto_vuelo] -> Error lógico: La fecha de emisión del boleto no puede ser posterior al despegue del vuelo.';
    end if;
end //
delimiter ;


52)
  delimiter //
create trigger tg_validar_sueldo_minimo_terrestre
before insert on Empleado
for each row
begin
    declare v_tipo_dep varchar(20);
    select tipo into v_tipo_dep from Departamento where IDDepartamento = NEW.departamento_id;
    if v_tipo_dep = 'Terrestre' and NEW.sueldo < 500.00 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_sueldo_minimo_terrestre] -> Error salarial: El sueldo para personal terrestre no puede ser inferior a 500.00.';
    end if;
end //
delimiter ;


53)
delimiter //
create trigger tg_validar_capacidad_maxima_avion
before insert on Avion
for each row
begin
    if NEW.capacidad > 500 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_capacidad_maxima_avion] -> Error de flota: La capacidad del avión no puede superar los 500 asientos en categoría LowCost.';
    end if;
end //
delimiter ;


54)
delimiter //
create trigger tg_validar_precio_maximo_servicio
before insert on Servicio
for each row
begin
    if NEW.precio > 500000.00 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_precio_maximo_servicio] -> Error operativo: El precio de un servicio adicional no puede exceder los 500,000.00.';
    end if;
end //
delimiter ;


55)
  delimiter //
create trigger tg_cancelar_pago_al_borrar_checkin
after delete on CheckIn
for each row
begin
    update Pago 
    set estado = 'Cancelado' 
    where IDPago = OLD.pago_id;
end //
delimiter ;

56)
  delimiter //
create trigger tg_limpiar_boleto_servicio_por_baja_catalogo
after delete on Servicio
for each row
begin
    delete from Boleto_Servicio 
    where servicio_id = OLD.IDServicio;
end //
delimiter ;

57)
  delimiter //
create trigger tg_eliminar_asientos_por_baja_avion
after delete on Avion
for each row
begin
    delete from Asiento 
    where avion_id = OLD.IDAvion;
end //
delimiter ;

58)
delimiter //
create trigger tg_validar_fecha_boleto_vuelo_update
before update on Boleto
for each row
begin
    declare v_fecha_vuelo datetime;
    select fecha_hora_salida into v_fecha_vuelo from Vuelo where IDVuelo = NEW.vuelo_id;
    if NEW.fecha > v_fecha_vuelo then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_fecha_boleto_vuelo_update] -> Error lógico: Al actualizar, la fecha del boleto no puede quedar posterior al vuelo.';
    end if;
end //
delimiter ;


59)
  delimiter //
create trigger tg_validar_sueldo_minimo_terrestre_update
before update on Empleado
for each row
begin
    declare v_tipo_dep varchar(20);
    select tipo into v_tipo_dep from Departamento where IDDepartamento = NEW.departamento_id;
    if v_tipo_dep = 'Terrestre' and NEW.sueldo < 500.00 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_sueldo_minimo_terrestre_update] -> Error salarial: El sueldo modificado para personal terrestre no puede ser menor a 500.00.';
    end if;
end //
delimiter ;


60)
 delimiter //
create trigger tg_validar_capacidad_maxima_avion_update
before update on Avion
for each row
begin
    if NEW.capacidad > 500 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_capacidad_maxima_avion_update] -> Error de flota: La nueva capacidad modificada no puede superar los 500 asientos.';
    end if;
end //
delimiter ;

 
61)
delimiter //
create trigger tg_validar_precio_maximo_servicio_update
before update on Servicio
for each row
begin
    if NEW.precio > 500000.00 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_precio_maximo_servicio_update] -> Error operativo: El precio actualizado del servicio supera el límite permitido.';
    end if;
end //
delimiter ;


62)
 delimiter //
create trigger tg_normalizar_pais_pasajero_insert
before insert on Pasajero
for each row
begin
    set NEW.pais_emision = upper(NEW.pais_emision);
end //
delimiter ;
 
63)
  delimiter //
create trigger tg_normalizar_pais_pasajero_update
before update on Pasajero
for each row
begin
    set NEW.pais_emision = upper(NEW.pais_emision);
end //
delimiter ;

64)
  delimiter //
create trigger tg_normalizar_puerta_checkin_insert
before insert on CheckIn
for each row
begin
    set NEW.puerta_embarque = upper(NEW.puerta_embarque);
end //
delimiter ;

65)
  delimiter //
create trigger tg_normalizar_puerta_checkin_update
before update on CheckIn
for each row
begin
    set NEW.puerta_embarque = upper(NEW.puerta_embarque);
end //
delimiter ;

66)
  delimiter //
create trigger tg_normalizar_id_avion_insert
before insert on Avion
for each row
begin
    set NEW.IDAvion = upper(NEW.IDAvion);
end //
delimiter ;

67)
  delimiter //
create trigger tg_normalizar_id_asiento_insert
before insert on Asiento
for each row
begin
    set NEW.IDAsiento = upper(NEW.IDAsiento);
end //
delimiter ;

68)
 delimiter //
create trigger tg_seguridad_pregunta_respuesta_distintas
before insert on Usuario
for each row
begin
    if lower(trim(NEW.pregunta_seguridad)) = lower(trim(NEW.respuesta_seguridad)) then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_seguridad_pregunta_respuesta_distintas] -> Seguridad: La respuesta de seguridad no puede ser igual a la pregunta.';
    end if;
end //
delimiter ;


69)
 delimiter //
create trigger tg_seguridad_pregunta_respuesta_distintas_update
before update on Usuario
for each row
begin
    if lower(trim(NEW.pregunta_seguridad)) = lower(trim(NEW.respuesta_seguridad)) then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_seguridad_pregunta_respuesta_distintas_update] -> Seguridad: La respuesta de seguridad modificada no puede coincidir con la pregunta.';
    end if;
end //
delimiter ;


70)
  delimiter //
create trigger tg_limpiar_email_usuario_insert
before insert on Usuario
for each row
begin
    set NEW.email = trim(NEW.email);
end //
delimiter ;

71)
  delimiter //
create trigger tg_limpiar_email_usuario_update
before update on Usuario
for each row
begin
    set NEW.email = trim(NEW.email);
end //
delimiter ;

72)
  delimiter //
create trigger tg_cancelar_pago_por_boleto_borrado
after delete on Boleto
for each row
begin
    update Pago 
    set estado = 'Cancelado' 
    where boleto_id = OLD.IDBoleto;
end //
delimiter ;

73)
  delimiter //
create trigger tg_deshabilitar_asientos_por_capacidad_nula
after update on Avion
for each row
begin
    if NEW.capacidad <= 0 then
        update Asiento 
        set disponible = 0 
        where avion_id = NEW.IDAvion;
    end if;
end //
delimiter ;

74)
delimiter //
create trigger tg_validar_telefono_pasajero_insert
before insert on Pasajero
for each row
begin
    if char_length(trim(NEW.telefono)) < 7 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_telefono_pasajero_insert] -> Error: El teléfono del pasajero debe tener al menos 7 caracteres.';
    end if;
end //
delimiter ;


75)
delimiter //
create trigger tg_validar_telefono_empleado_insert
before insert on Empleado
for each row
begin
    if char_length(trim(NEW.telefono)) < 7 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_telefono_empleado_insert] -> Error: El teléfono del empleado debe tener al menos 7 caracteres.';
    end if;
end //
delimiter ;


76)
delimiter //
create trigger tg_validar_telefono_pasajero_update
before update on Pasajero
for each row
begin
    if char_length(trim(NEW.telefono)) < 7 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_telefono_pasajero_update] -> Error: El nuevo teléfono del pasajero no puede ser inferior a 7 caracteres.';
    end if;
end //
delimiter ;


77)
delimiter //
create trigger tg_validar_telefono_empleado_update
before update on Empleado
for each row
begin
    if char_length(trim(NEW.telefono)) < 7 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_telefono_empleado_update] -> Error: El nuevo teléfono del empleado no puede ser inferior a 7 caracteres.';
    end if;
end //
delimiter ;

78)
  delimiter //
create trigger tg_normalizar_nombre_aeropuerto_insert
before insert on Aeropuerto
for each row
begin
    set NEW.nombre = upper(trim(NEW.nombre));
end //
delimiter ;

79)
  delimiter //
create trigger tg_normalizar_nombre_aeropuerto_update
before update on Aeropuerto
for each row
begin
    set NEW.nombre = upper(trim(NEW.nombre));
end //
delimiter ;

80)
  delimiter //
create trigger tg_normalizar_ciudad_aeropuerto_insert
before insert on Aeropuerto
for each row
begin
    set NEW.ciudad = upper(trim(NEW.ciudad));
end //
delimiter ;

81)
  delimiter //
create trigger tg_normalizar_ciudad_aeropuerto_update
before update on Aeropuerto
for each row
begin
    set NEW.ciudad = upper(trim(NEW.ciudad));
end //
delimiter ;

82)
  delimiter //
create trigger tg_normalizar_nombre_servicio_insert
before insert on Servicio
for each row
begin
    set NEW.nombre_servicio = upper(trim(NEW.nombre_servicio));
end //
delimiter ;

83)
  delimiter //
create trigger tg_normalizar_nombre_servicio_update
before update on Servicio
for each row
begin
    set NEW.nombre_servicio = upper(trim(NEW.nombre_servicio));
end //
delimiter ;

84)
delimiter //
create trigger tg_validar_limite_futuro_vuelo
before insert on Vuelo
for each row
begin
    if NEW.fecha_hora_salida > now() + interval 1 year then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_limite_futuro_vuelo] -> Error: No se pueden programar vuelos con más de un año de anticipación.';
    end if;
end //
delimiter ;


85)
 delimiter //
create trigger tg_validar_limite_futuro_vuelo_update
before update on Vuelo
for each row
begin
    if NEW.fecha_hora_salida > now() + interval 1 year then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_limite_futuro_vuelo_update] -> Error: La reprogramación del vuelo no puede exceder el límite de un año futuro.';
    end if;
end //
delimiter ;


86)
delimiter //
create trigger tg_validar_vuelo_no_pasado
before insert on Vuelo
for each row
begin
    if NEW.fecha_hora_salida < now() then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_vuelo_no_pasado] -> Error: La fecha y hora de salida del vuelo no puede ser en el pasado.';
    end if;
end //
delimiter ;


87)
delimiter //
create trigger tg_validar_compra_boleto_no_futura
before insert on Boleto
for each row
begin
    if NEW.fecha > now() then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_compra_boleto_no_futura] -> Error operativo: La fecha de emisión del boleto no puede ser una fecha futura.';
    end if;
end //
delimiter ;


88)
 delimiter //
create trigger tg_validar_vuelo_no_pasado_update
before update on Vuelo
for each row
begin
    if NEW.fecha_hora_salida < now() then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_vuelo_no_pasado_update] -> Error: La nueva reprogramación de salida del vuelo no puede ser en el pasado.';
    end if;
end //
delimiter ;


89)
  delimiter //
create trigger tg_validar_compra_boleto_no_futura_update
before update on Boleto
for each row
begin
    if NEW.fecha > now() then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_compra_boleto_no_futura_update] -> Error operativo: La nueva fecha del boleto no puede quedar en el futuro.';
    end if;
end //
delimiter ;


90)
  delimiter //
create trigger tg_mayuscula_puerta_embarque_insert
before insert on CheckIn
for each row
begin
    set NEW.puerta_embarque = upper(trim(NEW.puerta_embarque));
end //
delimiter ;

91)
  delimiter //
create trigger tg_mayuscula_puerta_embarque_update
before update on CheckIn
for each row
begin
    set NEW.puerta_embarque = upper(trim(NEW.puerta_embarque));
end //
delimiter ;

92)
  delimiter //
create trigger tg_mayuscula_pais_emision_insert
before insert on Pasajero
for each row
begin
    set NEW.pais_emision = upper(trim(NEW.pais_emision));
end //
delimiter ;

93)
  delimiter //
create trigger tg_mayuscula_pais_emision_update
before update on Pasajero
for each row
begin
    set NEW.pais_emision = upper(trim(NEW.pais_emision));
end //
delimiter ;

94)
  delimiter //
create trigger tg_limpiar_servicios_por_boleto_borrado
after delete on Boleto
for each row
begin
    delete from Boleto_Servicio where boleto_id = OLD.IDBoleto;
end //
delimiter ;

95)
  delimiter //
create trigger tg_eliminar_checkin_por_pago_borrado
after delete on Pago
for each row
begin
    delete from CheckIn where pago_id = OLD.IDPago;
end //
delimiter ;

96)
 delimiter //
create trigger tg_servicio_nombre_vacio_insert
before insert on Servicio
for each row
begin
    if trim(NEW.nombre_servicio) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_servicio_nombre_vacio_insert] -> error: El nombre del servicio catálogo no puede estar vacío.';
    end if;
end //
delimiter ;


97)
delimiter //
create trigger tg_servicio_nombre_vacio_update
before update on Servicio
for each row
begin
    if trim(NEW.nombre_servicio) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_servicio_nombre_vacio_update] -> error: No se puede modificar el nombre del servicio dejándolo vacío.';
    end if;
end //
delimiter ;


98)
  delimiter //
create trigger tg_servicio_trim_nombre_insert
before insert on Servicio
for each row
begin
    set NEW.nombre_servicio = trim(NEW.nombre_servicio);
end //
delimiter ;

99)
  delimiter //
create trigger tg_servicio_trim_nombre_update
before update on Servicio
for each row
begin
    set NEW.nombre_servicio = trim(NEW.nombre_servicio);
end //
delimiter ;

100)
delimiter //
create trigger tg_departamento_nombre_vacio_insert
before insert on Departamento
for each row
begin
    if trim(NEW.nombre) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_departamento_nombre_vacio_insert] -> error: El nombre del departamento es obligatorio.';
    end if;
end //
delimiter ;


101)
delimiter //
create trigger tg_departamento_nombre_vacio_update
before update on Departamento
for each row
begin
    if trim(NEW.nombre) = '' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_departamento_nombre_vacio_update] -> error: No se puede actualizar el departamento con un nombre vacío.';
    end if;
end //
delimiter ;


102)
  delimiter //
create trigger tg_formato_nombre_pasajero_insert
before insert on Pasajero
for each row
begin
    set NEW.nombre_pasajero = concat(upper(left(trim(NEW.nombre_pasajero), 1)), lower(substring(trim(NEW.nombre_pasajero), 2)));
end //
delimiter ;

103)
  delimiter //
create trigger tg_formato_apellido_pasajero_insert
before insert on Pasajero
for each row
begin
    set NEW.apellido_pasajero = concat(upper(left(trim(NEW.apellido_pasajero), 1)), lower(substring(trim(NEW.apellido_pasajero), 2)));
end //
delimiter ;

104)
  delimiter //
create trigger tg_formato_nombre_empleado_insert
before insert on Empleado
for each row
begin
    set NEW.nombre_empleado = concat(upper(left(trim(NEW.nombre_empleado), 1)), lower(substring(trim(NEW.nombre_empleado), 2)));
end //
delimiter ;

105)
  delimiter //
create trigger tg_formato_apellido_empleado_insert
before insert on Empleado
for each row
begin
    set NEW.apellido_empleado = concat(upper(left(trim(NEW.apellido_empleado), 1)), lower(substring(trim(NEW.apellido_empleado), 2)));
end //
delimiter ;

106)
  delimiter //
create trigger tg_formato_ciudad_aeropuerto_insert
before insert on Aeropuerto
for each row
begin
    set NEW.ciudad = concat(upper(left(trim(NEW.ciudad), 1)), lower(substring(trim(NEW.ciudad), 2)));
end //
delimiter ;

107)
  delimiter //
create trigger tg_formato_pais_aeropuerto_insert
before insert on Aeropuerto
for each row
begin
    set NEW.pais = concat(upper(left(trim(NEW.pais), 1)), lower(substring(trim(NEW.pais), 2)));
end //
delimiter ;

108)
  delimiter //
create trigger tg_formato_nombre_pasajero_update
before update on Pasajero
for each row
begin
    set NEW.nombre_pasajero = concat(upper(left(trim(NEW.nombre_pasajero), 1)), lower(substring(trim(NEW.nombre_pasajero), 2)));
end //
delimiter ;

109)
  delimiter //
create trigger tg_formato_apellido_pasajero_update
before update on Pasajero
for each row
begin
    set NEW.apellido_pasajero = concat(upper(left(trim(NEW.apellido_pasajero), 1)), lower(substring(trim(NEW.apellido_pasajero), 2)));
end //
delimiter ;

110)
  delimiter //
create trigger tg_formato_nombre_empleado_update
before update on Empleado
for each row
begin
    set NEW.nombre_empleado = concat(upper(left(trim(NEW.nombre_empleado), 1)), lower(substring(trim(NEW.nombre_empleado), 2)));
end //
delimiter ;

111)
  delimiter //
create trigger tg_formato_apellido_empleado_update
before update on Empleado
for each row
begin
    set NEW.apellido_empleado = concat(upper(left(trim(NEW.apellido_empleado), 1)), lower(substring(trim(NEW.apellido_empleado), 2)));
end //
delimiter ;

112)
  delimiter //
create trigger tg_formato_pais_aeropuerto_update
before update on Aeropuerto
for each row
begin
    set NEW.pais = concat(upper(left(trim(NEW.pais), 1)), lower(substring(trim(NEW.pais), 2)));
end //
delimiter ;

113)
  delimiter //
create trigger tg_formato_ciudad_aeropuerto_update
before update on Aeropuerto
for each row
begin
    set NEW.ciudad = concat(upper(left(trim(NEW.ciudad), 1)), lower(substring(trim(NEW.ciudad), 2)));
end //
delimiter ;

114)
delimiter //
create trigger tg_bloquear_servicios_vuelo_cancelado
before insert on Boleto_Servicio
for each row
begin
    declare v_estado_vuelo varchar(20);
    select estado into v_estado_vuelo from Vuelo 
    where IDVuelo = (select vuelo_id from Boleto where IDBoleto = NEW.boleto_id);
    if v_estado_vuelo = 'Cancelado' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_bloquear_servicios_vuelo_cancelado] -> error: No se pueden agregar servicios adicionales a un boleto de un vuelo cancelado.';
    end if;
end //
delimiter ;


115)
delimiter //
create trigger tg_bloquear_servicios_vuelo_completado
before insert on Boleto_Servicio
for each row
begin
    declare v_estado_vuelo varchar(20);
    select estado into v_estado_vuelo from Vuelo 
    where IDVuelo = (select vuelo_id from Boleto where IDBoleto = NEW.boleto_id);
    if v_estado_vuelo = 'Completado' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_bloquear_servicios_vuelo_completado] -> error: No se pueden añadir servicios a un vuelo que ya ha finalizado.';
    end if;
end //
delimiter ;


116)
 delimiter //
create trigger tg_bloquear_checkin_vuelo_cancelado
before insert on CheckIn
for each row
begin
    declare v_estado_vuelo varchar(20);
    select estado into v_estado_vuelo from Vuelo where IDVuelo = NEW.vuelo_id;
    if v_estado_vuelo = 'Cancelado' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_bloquear_checkin_vuelo_cancelado] -> error: No se puede realizar Check-In para un vuelo que se encuentra cancelado.';
    end if;
end //
delimiter ;


117)
 delimiter //
create trigger tg_bloquear_checkin_vuelo_completado
before insert on CheckIn
for each row
begin
    declare v_estado_vuelo varchar(20);
    select estado into v_estado_vuelo from Vuelo where IDVuelo = NEW.vuelo_id;
    if v_estado_vuelo = 'Completado' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_bloquear_checkin_vuelo_completado] -> error: El vuelo ya finalizó. No se permiten nuevos registros de Check-In.';
    end if;
end //
delimiter ;


118)
 delimiter //
create trigger tg_validar_fecha_checkin_coherente
before insert on CheckIn
for each row
begin
    declare v_fecha_boleto datetime;
    select fecha into v_fecha_boleto from Boleto where IDBoleto = NEW.boleto_id;
    if now() < v_fecha_boleto then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_fecha_checkin_coherente] -> error: La fecha actual de Check-In no puede ser anterior a la fecha de emisión del boleto.';
    end if;
end //
delimiter ;


119)
 delimiter //
create trigger tg_validar_sobreventa_capacidad
before insert on Boleto
for each row
begin
    declare v_capacidad_max int;
    declare v_vendidos int;
    select capacidad into v_capacidad_max from Avion where IDAvion = (select avion_id from Vuelo where IDVuelo = NEW.vuelo_id);
    select count(*) into v_vendidos from Boleto where vuelo_id = NEW.vuelo_id;
    if v_vendidos >= v_capacidad_max then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_validar_sobreventa_capacidad] -> error: El vuelo se encuentra totalmente completo. Capacidad máxima alcanzada.';
    end if;
end //
delimiter ;


120)
  delimiter //
create trigger tg_cascada_checkin_por_pasajero
after delete on Pasajero
for each row
begin
    delete from CheckIn where pasajero_id = OLD.IDPasajero;
end //
delimiter ;

121)
  delimiter //
create trigger tg_cascada_pagos_por_pasajero
after delete on Pasajero
for each row
begin
    delete from Pago where pasajero_id = OLD.IDPasajero;
end //
delimiter ;

122)
  delimiter //
create trigger tg_cascada_checkin_por_pago
after delete on Pago
for each row
begin
    delete from CheckIn where pago_id = OLD.IDPago;
end //
delimiter ;

123)
  delimiter //
create trigger tg_cascada_boletos_por_vuelo
after delete on Vuelo
for each row
begin
    delete from Boleto where vuelo_id = OLD.IDVuelo;
end //
delimiter ;

124)
  delimiter //
create trigger tg_cascada_checkin_por_boleto
after delete on Boleto
for each row
begin
    delete from CheckIn where boleto_id = OLD.IDBoleto;
end //
delimiter ;

125)
  delimiter //
create trigger tg_limpiar_servicios_por_baja_pasajero
after delete on Pasajero
for each row
begin
    delete from Boleto_Servicio 
    where boleto_id in (select IDBoleto from Boleto where pasajero_id = OLD.IDPasajero);
end //
delimiter ;

126)
  delimiter //
create trigger tg_cascada_checkin_por_vuelo
after delete on Vuelo
for each row
begin
    delete from CheckIn where vuelo_id = OLD.IDVuelo;
end //
delimiter ;

127)
  delimiter //
create trigger tg_limpiar_servicios_por_boleto_borrado
after delete on Boleto
for each row
begin
    delete from Boleto_Servicio where boleto_id = OLD.IDBoleto;
end //
delimiter ;

128)
  delimiter //
create trigger tg_eliminar_checkin_por_pago_borrado
after delete on Pago
for each row
begin
    delete from CheckIn where pago_id = OLD.IDPago;
end //
delimiter ;

129)
  delimiter //
create trigger tg_limpiar_contraseña_usuario_insert
before insert on Usuario
for each row
begin
    set NEW.contraseña_usuario = trim(NEW.contraseña_usuario);
end //
delimiter ;

130)
delimiter //
create trigger tg_prevenir_aumento_abusivo_boleto
before update on Boleto
for each row
begin
    if NEW.precio_base > (OLD.precio_base * 2) then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'trigger [tg_prevenir_aumento_abusivo_boleto] -> error comercial: El nuevo precio base no puede superar el doble del precio anterior en una sola actualización.';
    end if;
end //
delimiter ;
131)
delimiter //

create trigger tg_validar_duracion_minima_vuelo
before insert on vuelo
for each row
begin

    if datediff(new.fecha_hora_llegada, new.fecha_hora_salida) < 1 then
        signal sqlstate '45000'
        set message_text = 'trigger [tg_validar_duracion_minima_vuelo] -> error comercial: la fecha de llegada debe ser como mínimo 1 día posterior a la fecha de salida.';
    end if;
end //

delimiter ;
132)
delimiter //

create trigger tg_generar_pago_pendiente_boleto
after insert on boleto
for each row
begin
    -- inserta automáticamente el registro de cobro relacionado al nuevo boleto
    insert into pago (pasajero_id, boleto_id, costo_servicios, costo_total, estado)
    values (new.pasajero_id, new.IDBoleto, 0.00, new.precio_base, 'Pendiente');
end //

delimiter ;






