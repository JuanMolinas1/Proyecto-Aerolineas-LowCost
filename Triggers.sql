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
  delimiter //
create trigger tg_bloquear_checkin_sin_pago
before insert on CheckIn
for each row
begin
    declare v_estado_pago varchar(20);
    select estado into v_estado_pago from Pago where IDPago = NEW.pago_id;
    if v_estado_pago <> 'Pagado' then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'Error: No se puede realizar Check-In si la factura no está en estado Pagado.';
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
        set MESSAGE_TEXT = 'Error: El nombre del pasajero no puede estar compuesto únicamente por espacios vacíos.';
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
        set MESSAGE_TEXT = 'Error: El apellido del pasajero es obligatorio y no puede quedar vacío.';
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
        set MESSAGE_TEXT = 'Error: La descripción del servicio debe ser más detallada (mínimo 10 caracteres).';
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
        set MESSAGE_TEXT = 'Error: La pregunta de seguridad no puede ser un campo vacío.';
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
        set MESSAGE_TEXT = 'Error de seguridad: El pasajero del Check-In no coincide con el dueño original del boleto.';
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
        set MESSAGE_TEXT = 'Error: No se puede modificar el nombre del pasajero dejándolo en blanco.';
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
        set MESSAGE_TEXT = 'Error: No se puede modificar el apellido del pasajero dejándolo en blanco.';
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
        set MESSAGE_TEXT = 'Error: La nueva descripción modificada debe tener al menos 10 caracteres.';
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
        set MESSAGE_TEXT = 'Error: La nueva pregunta de seguridad no puede ser un texto vacío.';
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
        set MESSAGE_TEXT = 'Error de auditoría: Está estrictamente prohibido alterar el costo total de un pago ya realizado.';
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
        set MESSAGE_TEXT = 'Error lógico: La fecha de emisión del boleto no puede ser posterior al despegue del vuelo.';
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
        set MESSAGE_TEXT = 'Error salarial: El sueldo para personal terrestre no puede ser inferior a 500.00.';
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
        set MESSAGE_TEXT = 'Error de flota: La capacidad del avión no puede superar los 500 asientos en categoría LowCost.';
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
        set MESSAGE_TEXT = 'Error operativo: El precio de un servicio adicional no puede exceder los 500,000.00.';
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
        set MESSAGE_TEXT = 'Error lógico: Al actualizar, la fecha del boleto no puede quedar posterior al vuelo.';
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
        set MESSAGE_TEXT = 'Error salarial: El sueldo modificado para personal terrestre no puede ser menor a 500.00.';
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
        set MESSAGE_TEXT = 'Error de flota: La nueva capacidad modificada no puede superar los 500 asientos.';
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
        set MESSAGE_TEXT = 'Error operativo: El precio actualizado del servicio supera el límite permitido.';
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
        set MESSAGE_TEXT = 'Seguridad: La respuesta de seguridad no puede ser igual a la pregunta.';
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
        set MESSAGE_TEXT = 'Seguridad: La respuesta de seguridad modificada no puede coincidir con la pregunta.';
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
        set MESSAGE_TEXT = 'Error: El teléfono del pasajero debe tener al menos 7 caracteres.';
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
        set MESSAGE_TEXT = 'Error: El teléfono del empleado debe tener al menos 7 caracteres.';
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
        set MESSAGE_TEXT = 'Error: El nuevo teléfono del pasajero no puede ser inferior a 7 caracteres.';
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
        set MESSAGE_TEXT = 'Error: El nuevo teléfono del empleado no puede ser inferior a 7 caracteres.';
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
        set MESSAGE_TEXT = 'Error: No se pueden programar vuelos con más de un año de anticipación.';
    end if;
end //
delimiter ;

85)
  
86)
  
87)
  
88)
  
89)
  
90)
  
91)
  
92)
  
93)
  
94)
  
95)
  
96)
  
97)
  
98)
  
99)
  
100)
  
101)
  
102)
  
103)
  
104)
  
105)
  
106)
  
107)
  
108)
  
109)
  
110)
  
111)
  
112)
  
113)
  
114)
  
115)
  
116)
  
117)
  
118)
  
119)
  
120)
  
121)
  
122)
  
123)
  
124)
  
125)
  
126)
  
127)
  
128)
  
129)
  
130)




