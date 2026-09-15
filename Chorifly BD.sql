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

-- Insertamos la flota del MVP (2 y 2)
INSERT INTO Avion (IDAvion, modelo, capacidad) VALUES 
('AV-A320-01', 'Airbus A320neo', 186),
('AV-A320-02', 'Airbus A320neo', 186),
('AV-B737-01', 'Boeing 737 MAX 8', 186),
('AV-B737-02', 'Boeing 737 MAX 8', 186);

-- 4. Servicios adicionales
INSERT INTO Servicio (nombre_servicio, precio, descripcion) VALUES 
('Equipaje Extra', 25.00, 'Permite llevar una maleta adicional en bodega'),
('Embarque Prioritario', 15.00, 'Acceso preferente al avión'),
('Menú Premium', 12.50, 'Comida caliente y bebida a elección durante el vuelo');

-- 5. Usuarios (Para pasajeros y empleados)
INSERT INTO Usuario (nombre_usuario, contraseña_usuario, privilegios_empleado) VALUES 
('admin1', 'admin123', 1),
('piloto_juarez', 'pilo987', 1),
('juan_perez', 'juanito1', 0),
('maria_gomez', 'maria22', 0);

-- 6. Empleados (Relacionados a departamentos, aeropuertos y usuarios)
INSERT INTO Empleado (nombre_empleado, apellido_empleado, dni_empleado, sueldo, departamento_id, aeropuerto_id, usuario_id) VALUES 
('Carlos', 'Juarez', '22333444', 4500.00, 1, 1, 2), -- Piloto en Buenos Aires
('Ana', 'Martinez', '33444555', 2000.00, 4, 1, 1); -- Check-in en Buenos Aires

-- 7. Pasajeros
INSERT INTO Pasajero (nombre_pasajero, apellido_pasajero, dni_pasajero, telefono, email, fecha_nacimiento, usuario_id) VALUES 
('Juan', 'Perez', '44555666', '1122334455', 'juan@email.com', '1990-05-15 00:00:00', 3),
('Maria', 'Gomez', '55666777', '1199887766', 'maria@email.com', '1995-10-20 00:00:00', 4);

-- 8. Asientos (Algunos ejemplos para los aviones registrados)
INSERT INTO Asiento (IDAsiento, numero, avion_id, disponible) VALUES 
('AV001-A1', 1, 'AV-001', 0),
('AV001-A2', 2, 'AV-001', 1),
('AV002-B1', 1, 'AV-002', 0),
('AV002-B2', 2, 'AV-002', 1);

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
