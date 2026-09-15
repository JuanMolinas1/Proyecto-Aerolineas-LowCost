drop database if exists Chorifly;
create database         Chorifly;
use                     Chorifly;


create table Aeropuerto (
    IDAeropuerto  int auto_increment primary key,
    nombre        varchar (120),
    pais          varchar (30),
    ciudad        varchar (80)
);


create table Avion (
    IDAvion   varchar (30) primary key,
    modelo    varchar (50),
    capacidad int
);


create table Departamento (
    IDDepartamento int auto_increment primary key,
    nombre         varchar (100),
    tipo           enum("Aéreo", "Terrestre") default "Terrestre"
);


create table Servicio (
    IDServicio      int auto_increment primary key,
    nombre_servicio varchar (20),
    precio          decimal (10, 2),
    descripcion     varchar (120)
);


create table Usuario(
    IDUsuario            int auto_increment primary key,
    nombre_usuario       varchar (30),
    contraseña_usuario   varchar (15),
    privilegios_empleado boolean
);


create table Pasajero (
    IDPasajero        int auto_increment primary key,
    nombre_pasajero   varchar (30),
    apellido_pasajero varchar (30),
    dni_pasajero      char (8),
    telefono          char (10),
    email             varchar (40),
    fecha_nacimiento  datetime,
    usuario_id        int,
    foreign key (usuario_id) references Usuario (IDUsuario)
);


create table Empleado (
    IDEmpleado        int auto_increment primary key,
    nombre_empleado   varchar (30),
    apellido_empleado varchar (30),
    dni_empleado      char (8),
    sueldo            decimal (10, 2),
    departamento_id   int,
    aeropuerto_id     int,
    usuario_id        int,
    foreign key (departamento_id) references Departamento (IDDepartamento),
    foreign key (aeropuerto_id)   references Aeropuerto   (IDAeropuerto),
    foreign key (usuario_id)      references Usuario      (IDUsuario)
);


create table Asiento (
    IDAsiento  varchar (50) primary key,
    numero     int,
    avion_id   varchar (30),
    tipo enum("Ventana", "Medio", "Pasillo") not null,
    disponible boolean,
    foreign key (avion_id) references Avion (IDAvion)
);


create table Vuelo (
    IDVuelo      int auto_increment primary key,
    avion_id     varchar (30),
    origen_id    int,
    destino_id   int,
    hora_salida  datetime,
    hora_llegada datetime,
    estado       enum("Completado", "Volando", "A Tiempo", "Atrasado", "Cancelado", "Choco", "Exploto", "Perdido"),
    foreign key (avion_id)   references Avion      (IDAvion),
    foreign key (origen_id)  references Aeropuerto (IDAeropuerto),
    foreign key (destino_id) references Aeropuerto (IDAeropuerto)
);


create table Boleto (
    IDBoleto    int auto_increment primary key,
    pasajero_id int,
    vuelo_id    int,
    asiento_id  varchar (50),
    fecha       datetime,
    precio_base decimal (10, 2),
    foreign key (pasajero_id) references Pasajero (IDPasajero),
    foreign key (vuelo_id)    references Vuelo    (IDVuelo),
    foreign key (asiento_id)  references Asiento  (IDAsiento)
);


create table Boleto_Servicio (
    boleto_id   int,
    servicio_id int,
    primary key (boleto_id, servicio_id),
    foreign key (boleto_id)   references Boleto   (IDBoleto),
    foreign key (servicio_id) references Servicio (IDServicio)
);


create table Pago (
    IDPago          int auto_increment primary key,
    pasajero_id     int,
    boleto_id       int,
    costo_servicios decimal (10, 2),
    costo_total     decimal (10, 2),
    foreign key (pasajero_id) references Pasajero (IDPasajero),
    foreign key (boleto_id)   references Boleto   (IDBoleto)
);


create table CheckIn (
    IDCheckin       int auto_increment primary key,
    vuelo_id        int,
    pago_id         int,
    puerta_embarque char (3),
    foreign key (vuelo_id) references Vuelo (IDVuelo),
    foreign key (pago_id)  references Pago  (IDPago)
);

INSERT INTO Departamento (nombre, tipo) VALUES 
('Pilot', 'Aéreo'),
('Seguridad', 'Terrestre'),
('Encargado del equipaje', 'Terrestre'),
('Check-in', 'Terrestre');

INSERT INTO Aeropuerto (nombre, pais, ciudad) VALUES 
('Aeropuerto Internacional do Macaquinho', 'Brasil', 'São Paulo'),
('Aeropuerto Internacional de Aura', 'Brasil', 'Río de Janeiro'),
('Aeropuerto Internacional Charlie Kirk', 'México', 'Ciudad de México'),
('Aeropuerto Internacional 67', 'México', 'Cancún'),
('Aeropuerto Internacional Quiero Queque', 'Argentina', 'Buenos Aires'),
('Aeropuerto Internacional Quiero Pico', 'Chile', 'Santiago'),
('Aeropuerto Internacional Pablo Escobar', 'Colombia', 'Bogotá'),
('Aeropuerto Internacional Faraón', 'Perú', 'Lima');

INSERT INTO Avion (IDAvion, modelo, capacidad) VALUES 
('AV-A320-01', 'Airbus A320neo', 186),
('AV-A320-02', 'Airbus A320neo', 186),
('AV-B737-01', 'Boeing 737 MAX 8', 186),
('AV-B737-02', 'Boeing 737 MAX 8', 186);

INSERT INTO Servicio (nombre_servicio, precio, descripcion) VALUES 
('Equipaje Extra', 16700.00, 'Permite llevar hasta 2 valijas extra, una en la bodega y otra en la guantera.'),
('Embarque Prioritario', 10000.00, 'Permite entrar primero al avión.'),
('Menú Premium', 20000.00, 'Ofrece un menú con comidas y bebidas para consumir durante el viaje.');

INSERT INTO Usuario (nombre_usuario, contraseña_usuario, privilegios_empleado) VALUES 
('Chorifly_Admin', 'Choriflyadmin1@!', True),
('la_cobra', 'Cobra123!', True),
('davo_xeneize', 'Davo123!', True),
('coscu_army', 'Coscu123!', True),
('goncho_batan', 'Goncho123!', True),
('momo_gero', 'Momo123!', True),
('brunenger_ok', 'Brunenger123!', True),
('pimpeano_in', 'Pimpe123!', True),
('joaco_lopez', 'Joaco123!', True);

INSERT INTO Empleado (nombre_empleado, apellido_empleado, dni_empleado, sueldo, departamento_id, aeropuerto_id, usuario_id) VALUES 
('Lautaro', 'del Campo', '40111222', 5500.00, 1, 5, 4),
('David', 'Quintanilla', '40222333', 5500.00, 1, 5, 5),
('Martín', 'Pérez Disalvo', '38333444', 1800.00, 2, 1, 6),
('Gonzalo', 'Banzas', '38444555', 1800.00, 2, 1, 7),
('Gerónimo', 'Benavides', '37555666', 1500.00, 3, 3, 8),
('Bruno', 'Kr Kr Kr', '41666777', 1500.00, 3, 3, 9),
('Galileo', 'Caro', '41777888', 1600.00, 4, 6, 10),
('Joaquín', 'López', '40888999', 1600.00, 4, 6, 11);

-- Limpiamos registros previos para evitar duplicados en tus pruebas
DELETE FROM Asiento;

-- =========================================================
-- ASIENTOS PARA EL AVION 1: AV-A320-01 (Airbus A320neo)
-- =========================================================
INSERT INTO Asiento (IDAsiento, numero, avion_id, tipo, disponible) VALUES 
('AV-A320-01-1A', 1, 'AV-A320-01', 'Ventana', 1), ('AV-A320-01-1B', 2, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-1C', 3, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-1D', 4, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-1E', 5, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-1F', 6, 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-2A', 7, 'AV-A320-01', 'Ventana', 1), ('AV-A320-01-2B', 8, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-2C', 9, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-2D', 10, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-2E', 11, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-2F', 12, 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-3A', 13, 'AV-A320-01', 'Ventana', 1), ('AV-A320-01-3B', 14, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-3C', 15, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-3D', 16, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-3E', 17, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-3F', 18, 'AV-A320-01', 'Ventana', 1),
-- [Se repite la misma secuencia lógica para las filas 4 a 29...]
('AV-A320-01-30A', 175, 'AV-A320-01', 'Ventana', 1), ('AV-A320-01-30B', 176, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-30C', 177, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-30D', 178, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-30E', 179, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-30F', 180, 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-31A', 181, 'AV-A320-01', 'Ventana', 1), ('AV-A320-01-31B', 182, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-31C', 183, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-31D', 184, 'AV-A320-01', 'Pasillo', 1), ('AV-A320-01-31E', 185, 'AV-A320-01', 'Medio', 1), ('AV-A320-01-31F', 186, 'AV-A320-01', 'Ventana', 1);

-- =========================================================
-- ASIENTOS PARA EL AVION 2: AV-A320-02 (Airbus A320neo)
-- =========================================================
INSERT INTO Asiento (IDAsiento, numero, avion_id, tipo, disponible) VALUES 
('AV-A320-02-1A', 1, 'AV-A320-02', 'Ventana', 1), ('AV-A320-02-1B', 2, 'AV-A320-02', 'Medio', 1), ('AV-A320-02-1C', 3, 'AV-A320-02', 'Pasillo', 1), ('AV-A320-02-1D', 4, 'AV-A320-02', 'Pasillo', 1), ('AV-A320-02-1E', 5, 'AV-A320-02', 'Medio', 1), ('AV-A320-02-1F', 6, 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-2A', 7, 'AV-A320-02', 'Ventana', 1), ('AV-A320-02-2B', 8, 'AV-A320-02', 'Medio', 1), ('AV-A320-02-2C', 9, 'AV-A320-02', 'Pasillo', 1), ('AV-A320-02-2D', 10, 'AV-A320-02', 'Pasillo', 1), ('AV-A320-02-2E', 11, 'AV-A320-02', 'Medio', 1), ('AV-A320-02-2F', 12, 'AV-A320-02', 'Ventana', 1),
-- [Se repite la misma secuencia lógica para las filas 3 a 30...]
('AV-A320-02-31A', 181, 'AV-A320-02', 'Ventana', 1), ('AV-A320-02-31B', 182, 'AV-A320-02', 'Medio', 1), ('AV-A320-02-31C', 183, 'AV-A320-02', 'Pasillo', 1), ('AV-A320-02-31D', 184, 'AV-A320-02', 'Pasillo', 1), ('AV-A320-02-31E', 185, 'AV-A320-02', 'Medio', 1), ('AV-A320-02-31F', 186, 'AV-A320-02', 'Ventana', 1);

-- =========================================================
-- ASIENTOS PARA EL AVION 3: AV-B737-01 (Boeing 737 MAX 8)
-- =========================================================
INSERT INTO Asiento (IDAsiento, numero, avion_id, tipo, disponible) VALUES 
('AV-B737-01-1A', 1, 'AV-B737-01', 'Ventana', 1), ('AV-B737-01-1B', 2, 'AV-B737-01', 'Medio', 1), ('AV-B737-01-1C', 3, 'AV-B737-01', 'Pasillo', 1), ('AV-B737-01-1D', 4, 'AV-B737-01', 'Pasillo', 1), ('AV-B737-01-1E', 5, 'AV-B737-01', 'Medio', 1), ('AV-B737-01-1F', 6, 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-2A', 7, 'AV-B737-01', 'Ventana', 1), ('AV-B737-01-2B', 8, 'AV-B737-01', 'Medio', 1), ('AV-B737-01-2C', 9, 'AV-B737-01', 'Pasillo', 1), ('AV-B737-01-2D', 10, 'AV-B737-01', 'Pasillo', 1), ('AV-B737-01-2E', 11, 'AV-B737-01', 'Medio', 1), ('AV-B737-01-2F', 12, 'AV-B737-01', 'Ventana', 1),
-- [Se repite la misma secuencia lógica para las filas 3 a 30...]
('AV-B737-01-31A', 181, 'AV-B737-01', 'Ventana', 1), ('AV-B737-01-31B', 182, 'AV-B737-01', 'Medio', 1), ('AV-B737-01-31C', 183, 'AV-B737-01', 'Pasillo', 1), ('AV-B737-01-31D', 184, 'AV-B737-01', 'Pasillo', 1), ('AV-B737-01-31E', 185, 'AV-B737-01', 'Medio', 1), ('AV-B737-01-31F', 186, 'AV-B737-01', 'Ventana', 1);

-- =========================================================
-- ASIENTOS PARA EL AVION 4: AV-B737-02 (Boeing 737 MAX 8)
-- =========================================================
INSERT INTO Asiento (IDAsiento, numero, avion_id, tipo, disponible) VALUES 
('AV-B737-02-1A', 1, 'AV-B737-02', 'Ventana', 1), ('AV-B737-02-1B', 2, 'AV-B737-02', 'Medio', 1), ('AV-B737-02-1C', 3, 'AV-B737-02', 'Pasillo', 1), ('AV-B737-02-1D', 4, 'AV-B737-02', 'Pasillo', 1), ('AV-B737-02-1E', 5, 'AV-B737-02', 'Medio', 1), ('AV-B737-02-1F', 6, 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-2A', 7, 'AV-B737-02', 'Ventana', 1), ('AV-B737-02-2B', 8, 'AV-B737-02', 'Medio', 1), ('AV-B737-02-2C', 9, 'AV-B737-02', 'Pasillo', 1), ('AV-B737-02-2D', 10, 'AV-B737-02', 'Pasillo', 1), ('AV-B737-02-2E', 11, 'AV-B737-02', 'Medio', 1), ('AV-B737-02-2F', 12, 'AV-B737-02', 'Ventana', 1),
-- [Se repite la misma secuencia lógica para las filas 3 a 30...]
('AV-B737-02-31A', 181, 'AV-B737-02', 'Ventana', 1), ('AV-B737-02-31B', 182, 'AV-B737-02', 'Medio', 1), ('AV-B737-02-31C', 183, 'AV-B737-02', 'Pasillo', 1), ('AV-B737-02-31D', 184, 'AV-B737-02', 'Pasillo', 1), ('AV-B737-02-31E', 185, 'AV-B737-02', 'Medio', 1), ('AV-B737-02-31F', 186, 'AV-B737-02', 'Ventana', 1);


-- 9. Vuelos
INSERT INTO Vuelo (avion_id, origen_id, destino_id, hora_salida, hora_llegada, estado) VALUES 
('AV-001', 1, 2, '2026-10-20 08:00:00', '2026-10-20 10:15:00', 'A Tiempo'),
('AV-002', 2, 3, '2026-10-21 14:00:00', '2026-10-21 19:30:00', 'Volando');

-- 10. Boletos
INSERT INTO Boleto (pasajero_id, vuelo_id, asiento_id, fecha, precio_base) VALUES 
(1, 1, 'AV001-A1', '2026-09-15 10:00:00', 150.00),
(2, 2, 'AV002-B1', '2026-09-15 10:30:00', 220.00);

-- 11. Relación Boleto y Servicios contratados
INSERT INTO Boleto_Servicio (boleto_id, servicio_id) VALUES 
(1, 1), -- Juan Perez contrató Equipaje Extra
(1, 2), -- Juan Perez contrató Embarque Prioritario
(2, 3); -- Maria Gomez contrató Menú Premium

-- 12. Pagos (Cálculos basados en el precio base y los servicios de arriba)
INSERT INTO Pago (pasajero_id, boleto_id, costo_servicios, costo_total) VALUES 
(1, 1, 40.00, 190.00), -- 150 base + 25 equipaje + 15 embarque
(2, 2, 12.50, 232.50); -- 220 base + 12.50 menú

-- 13. Check-In
INSERT INTO CheckIn (vuelo_id, pago_id, puerta_embarque) VALUES 
(1, 1, 'A03'),
(2, 2, 'B11');
