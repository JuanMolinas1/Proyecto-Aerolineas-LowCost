1)  
delimiter //
create trigger validacionUsuario 
before insert on Usuario
for each row
begin

  if char_length(NEW.contraseña_usuario) < 8 then
    signal sqlstate '45000'
    set MESSAGE_TEXT = 'La contraseña debe tener al menos 8 caracteres';
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
        set MESSAGE_TEXT = 'Error: El aeropuerto de destino no puede ser igual al de origen.';
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

    -- Obtener el precio base desde la tabla Boleto
    select precio_base into v_precio_base 
    from Boleto 
    where IDBoleto = NEW.boleto_id;

    -- Calcular el total sumando ambos costos
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
        set MESSAGE_TEXT = 'Error: No se puede registrar un pasajero con el pasaporte vencido.';
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
        set MESSAGE_TEXT = 'Error: El precio del servicio debe ser un valor positivo mayor a cero.';
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
        set MESSAGE_TEXT = 'Error: El nuevo sueldo modificado debe ser mayor a cero.';
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
        set MESSAGE_TEXT = 'Error: La fecha de salida del vuelo no puede ser en el pasado.';
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
        set MESSAGE_TEXT = 'Error: La fecha de nacimiento no puede ser futura.';
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
        set MESSAGE_TEXT = 'Error: La fecha del boleto no puede ser una fecha futura.';
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
        set MESSAGE_TEXT = 'Error: La capacidad del avión debe ser un número positivo.';
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
        set MESSAGE_TEXT = 'Error: El precio base del boleto debe ser mayor a cero.';
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
        set MESSAGE_TEXT = 'Error: El costo de los servicios adicionales no puede ser negativo.';
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
        set MESSAGE_TEXT = 'Error: La nueva fecha de llegada debe ser posterior a la de salida.';
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
        set MESSAGE_TEXT = 'Error: El precio actualizado del servicio debe ser mayor a cero.';
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
        set MESSAGE_TEXT = 'Error: La capacidad modificada del avión debe ser un número positivo.';
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
        set MESSAGE_TEXT = 'Error: El correo electrónico ingresado no tiene un formato válido.';
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
        set MESSAGE_TEXT = 'Error: El DNI del empleado debe tener exactamente 8 caracteres.';
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
        set MESSAGE_TEXT = 'Error: El código de asiento no puede estar vacío.';
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
        set MESSAGE_TEXT = 'Error: La respuesta de seguridad debe tener al menos 3 caracteres.';
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
        set MESSAGE_TEXT = 'Error: Un nuevo vuelo no puede registrarse con ese estado inicial.';
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
        set MESSAGE_TEXT = 'Error: El estado inicial del pago no es válido para un nuevo registro.';
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
        set MESSAGE_TEXT = 'Error: Los asientos nuevos deben registrarse como disponibles.';
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
        set MESSAGE_TEXT = 'Error: El nuevo correo electrónico modificado no es válido.';
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
        set MESSAGE_TEXT = 'Error: No está permitido modificar el número de DNI de un pasajero.';
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
        set MESSAGE_TEXT = 'Error: El número de pasaporte es inmutable y no se puede modificar.';
    end if;
end //
delimiter ;

35)
  delimiter //
create trigger tg_validar_longitud_dni_empleado_update
before update on Empleado
for each row
begin
    -- Si el DNI cambió, validamos que el nuevo tenga 8 caracteres
    if OLD.dni_empleado <> NEW.dni_empleado and char_length(NEW.dni_empleado) <> 8 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'Error: El nuevo DNI corregido debe tener exactamente 8 caracteres.';
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
        set MESSAGE_TEXT = 'Error: No se puede revertir un pago que ya ha sido completado.';
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
        set MESSAGE_TEXT = 'Error: El nombre del aeropuerto debe tener al menos 5 caracteres.';
    end if;
end //
delimiter ;

38)
  
39)
  
40)
  
41)
  
42)
  
43)
  
44)
  
45)
  
46)
  
47)
  
48)
  
49)
  
50)

