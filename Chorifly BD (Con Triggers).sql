DROP DATABASE IF EXISTS Chorifly;
CREATE DATABASE Chorifly;
USE Chorifly;

CREATE TABLE Aeropuerto (
    IDAeropuerto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL UNIQUE,
    pais VARCHAR(30) NOT NULL,
    ciudad VARCHAR(80) NOT NULL
);

CREATE TABLE Avion (
    IDAvion VARCHAR(30) PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL
);

CREATE TABLE Departamento (
    IDDepartamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    tipo ENUM("Aéreo", "Terrestre") DEFAULT "Terrestre"
);

CREATE TABLE Servicio (
    IDServicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(20) NOT NULL UNIQUE,
    precio DECIMAL(10, 2) NOT NULL,
    descripcion VARCHAR(120) NOT NULL
);

CREATE TABLE Usuario (
    IDUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(40) NOT NULL UNIQUE,
    contraseña_usuario VARCHAR(30) NOT NULL,
    privilegios_empleado BOOLEAN NOT NULL,
    pregunta_seguridad VARCHAR(100) NOT NULL,
    respuesta_seguridad VARCHAR(100) NOT NULL
);

CREATE TABLE Pasajero (
    IDPasajero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pasajero VARCHAR(50) NOT NULL,
    apellido_pasajero VARCHAR(50) NOT NULL,
    dni_pasajero VARCHAR(15) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    nro_pasaporte VARCHAR(20) NOT NULL UNIQUE,
    pais_emision CHAR(3) NOT NULL,
    vencimiento_pasaporte DATE NOT NULL,
    usuario_id INT NOT NULL UNIQUE,
    FOREIGN KEY (usuario_id) REFERENCES Usuario (IDUsuario)
);

CREATE TABLE Empleado (
    IDEmpleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empleado VARCHAR(30) NOT NULL,
    apellido_empleado VARCHAR(30) NOT NULL,
    dni_empleado CHAR(8) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    sueldo DECIMAL(10, 2) NOT NULL,
    departamento_id INT NOT NULL,
    aeropuerto_id INT NOT NULL,
    usuario_id INT NOT NULL UNIQUE,
    FOREIGN KEY (departamento_id) REFERENCES Departamento (IDDepartamento),
    FOREIGN KEY (aeropuerto_id) REFERENCES Aeropuerto (IDAeropuerto),
    FOREIGN KEY (usuario_id) REFERENCES Usuario (IDUsuario)
);

CREATE TABLE Asiento (
    IDAsiento VARCHAR(50) PRIMARY KEY,
    codigo VARCHAR(5) NOT NULL,
    avion_id VARCHAR(30) NOT NULL,
    tipo ENUM("Ventana", "Medio", "Pasillo") NOT NULL,
    disponible BOOLEAN NOT NULL,
    FOREIGN KEY (avion_id) REFERENCES Avion (IDAvion)
);

CREATE TABLE Vuelo (
    IDVuelo INT AUTO_INCREMENT PRIMARY KEY,
    avion_id VARCHAR(30) NOT NULL,
    origen_id INT NOT NULL,
    destino_id INT NOT NULL,
    fecha_hora_salida DATETIME NOT NULL,
    fecha_hora_llegada DATETIME NOT NULL,
    estado ENUM("Completado", "Volando", "Programado", "A Tiempo", "Atrasado", "Cancelado", "Choco", "Exploto", "Perdido") NOT NULL,
    FOREIGN KEY (avion_id) REFERENCES Avion (IDAvion),
    FOREIGN KEY (origen_id) REFERENCES Aeropuerto (IDAeropuerto),
    FOREIGN KEY (destino_id) REFERENCES Aeropuerto (IDAeropuerto)
);

CREATE TABLE Boleto (
    IDBoleto INT AUTO_INCREMENT PRIMARY KEY,
    pasajero_id INT NOT NULL,
    vuelo_id INT NOT NULL,
    asiento_id VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL,
    precio_base DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pasajero_id) REFERENCES Pasajero (IDPasajero),
    FOREIGN KEY (vuelo_id) REFERENCES Vuelo (IDVuelo),
    FOREIGN KEY (asiento_id) REFERENCES Asiento (IDAsiento)
);

CREATE TABLE Boleto_Servicio (
    boleto_id INT NOT NULL,
    servicio_id INT NOT NULL,
    PRIMARY KEY (boleto_id, servicio_id),
    FOREIGN KEY (boleto_id) REFERENCES Boleto (IDBoleto),
    FOREIGN KEY (servicio_id) REFERENCES Servicio (IDServicio)
);

CREATE TABLE Pago (
    IDPago INT AUTO_INCREMENT PRIMARY KEY,
    pasajero_id INT NOT NULL,
    boleto_id INT NOT NULL UNIQUE,
    costo_servicios DECIMAL(10, 2) NOT NULL,
    costo_total DECIMAL(10, 2) NOT NULL,
    estado ENUM("Pagado", "Pendiente", "Cancelado", "Robado", "Fiado", "Reducido", "Detenido", "Devuelto") NOT NULL,
    FOREIGN KEY (pasajero_id) REFERENCES Pasajero (IDPasajero),
    FOREIGN KEY (boleto_id) REFERENCES Boleto (IDBoleto)
);

CREATE TABLE CheckIn (
    IDCheckin INT AUTO_INCREMENT PRIMARY KEY,
    pasajero_id INT NOT NULL,
    boleto_id INT NOT NULL UNIQUE,
    vuelo_id INT NOT NULL,
    pago_id INT NOT NULL UNIQUE,
    puerta_embarque CHAR(3) NOT NULL,
    FOREIGN KEY (pasajero_id) REFERENCES Pasajero (IDPasajero),
    FOREIGN KEY (boleto_id) REFERENCES Boleto (IDBoleto),
    FOREIGN KEY (vuelo_id) REFERENCES Vuelo (IDVuelo),
    FOREIGN KEY (pago_id) REFERENCES Pago (IDPago)
);

INSERT INTO Departamento (nombre, tipo) VALUES 
('Piloto', 'Aéreo'),
('Seguridad', 'Terrestre'),
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
('AV-A320-01', 'Airbus A320neo', 180),
('AV-A320-02', 'Airbus A320neo', 180),
('AV-B737-01', 'Boeing 737 MAX 8', 180),
('AV-B737-02', 'Boeing 737 MAX 8', 180);

INSERT INTO Servicio (nombre_servicio, precio, descripcion) VALUES 
('Equipaje Extra', 16700.00, 'Permite llevar hasta 2 valijas extra, una en la bodega y otra en la guantera.'),
('Embarque Prioritario', 10000.00, 'Permite entrar primero al avión.'),
('Menú Premium', 20000.00, 'Ofrece un menú con comidas y bebidas para consumir during el viaje.'),
('Selección de Asiento', 15000, 'Permite elegir tu asiento y que no te sea seleccionado de forma aleatoria');

INSERT INTO Usuario (nombre_usuario, email, contraseña_usuario, privilegios_empleado, pregunta_seguridad, respuesta_seguridad) VALUES 
('Chorifly_Admin', 'admin@chorifly.com', 'Choriflyadmin1@!', True, 'Nombre de primera empresa laboral', 'Chorifly SRL'),
('la_cobra', 'lacobra@gmail.com', 'Cobra123!', True, 'Ciudad de nacimiento', 'Buenos Aires'),
('davo_xeneize', 'davoxeneize@gmail.com', 'Davo123!', True, 'Comida favorita', 'Milanesa'),
('goncho_batan', 'gonchobatan@gmail.com', 'Goncho123!', True, 'Nombre de mascota actual', 'Roco'),
('momo_gero', 'momogero@gmail.com', 'Momo123!', True, 'Ciudad de nacimiento', 'La Plata'),
('brunenger_ok', 'brunengerok@gmail.com', 'Brunenger123!', True, 'Comida favorita', 'Asado'),
('oppenjuamer', 'juanmer@gmail.com', '32157Juan!', FALSE, 'Color Favorito', 'Dortmund'),
('mateo_arg', 'mateo.arg@gmail.com', 'Mateo123!', FALSE, 'Comida favorita', 'Milanesa'),
('sofia_bra', 'sofia.bra@gmail.com', 'Sofia123!', FALSE, 'Ciudad de nacimiento', 'São Paulo'),
('diego_mex', 'diego.mex@gmail.com', 'Diego123!', FALSE, 'Nombre de mascota', 'Luna'),
('valentina_chl', 'valentina.chl@gmail.com', 'Vale123!', FALSE, 'Color favorito', 'Azul'),
('camilo_col', 'camilo.col@gmail.com', 'Camilo123!', FALSE, 'Comida favorita', 'Arepas');

INSERT INTO Empleado (nombre_empleado, apellido_empleado, dni_empleado, telefono, sueldo, departamento_id, aeropuerto_id, usuario_id) VALUES
('CEOJuanMer', 'Jefe', '49112572', '1165929456', 670000.67, 1, 1, 1),
('Lautaro', 'del Campo', '40555444', '1123456789', 3500.00, 2, 5, 2),
('David', 'Quintanilla', '40222333', '1134567890', 4000.00, 1, 5, 3),
('Gonzalo', 'Banzas', '38444555', '1145678901', 1800.00, 2, 1, 4),
('Gerónimo', 'Benavides', '37555666', '1156789012', 1500.00, 1, 3, 5),
('Bruno', 'Kr Kr Kr', '41666777', '1167890123', 1500.00, 3, 3, 6);

INSERT INTO Pasajero (nombre_pasajero, apellido_pasajero, dni_pasajero, telefono, fecha_nacimiento, nro_pasaporte, pais_emision, vencimiento_pasaporte, usuario_id) VALUES
('Mateo', 'González', '45111222', '+5491123456789', '2002-04-12', 'ARG123456', 'ARG', '2030-04-12', 7),
('Sofia', 'Oliveira', 'BRA123456', '+5511987654321', '1998-08-21', 'BR123456', 'BRA', '2031-08-21', 8),
('Diego', 'Hernández', 'MEX123456', '+525512345678', '2000-02-15', 'MX123456', 'MEX', '2030-02-15', 9),
('Valentina', 'Rojas', 'CHL123456', '+56912345678', '2001-11-03', 'CH123456', 'CHL', '2031-11-03', 10),
('Camilo', 'Restrepo', 'COL123456', '+573001234567', '1997-06-27', 'CO123456', 'COL', '2030-06-27', 11);

INSERT INTO Asiento (IDAsiento, codigo, avion_id, tipo, disponible) VALUES 
('AV-A320-01-01A', '01A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-01B', '01B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-01C', '01C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-01D', '01D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-01E', '01E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-01F', '01F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-02A', '02A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-02B', '02B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-02C', '02C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-02D', '02D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-02E', '02E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-02F', '02F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-03A', '03A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-03B', '03B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-03C', '03C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-03D', '03D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-03E', '03E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-03F', '03F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-04A', '04A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-04B', '04B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-04C', '04C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-04D', '04D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-04E', '04E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-04F', '04F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-05A', '05A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-05B', '05B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-05C', '05C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-05D', '05D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-05E', '05E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-05F', '05F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-06A', '06A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-06B', '06B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-06C', '06C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-06D', '06D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-06E', '06E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-06F', '06F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-07A', '07A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-07B', '07B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-07C', '07C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-07D', '07D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-07E', '07E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-07F', '07F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-08A', '08A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-08B', '08B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-08C', '08C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-08D', '08D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-08E', '08E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-08F', '08F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-09A', '09A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-09B', '09B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-09C', '09C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-09D', '09D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-09E', '09E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-09F', '09F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-10A', '10A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-10B', '10B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-10C', '10C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-10D', '10D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-10E', '10E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-10F', '10F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-11A', '11A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-11B', '11B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-11C', '11C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-11D', '11D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-11E', '11E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-11F', '11F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-12A', '12A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-12B', '12B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-12C', '12C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-12D', '12D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-12E', '12E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-12F', '12F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-13A', '13A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-13B', '13B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-13C', '13C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-13D', '13D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-13E', '13E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-13F', '13F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-14A', '14A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-14B', '14B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-14C', '14C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-14D', '14D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-14E', '14E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-14F', '14F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-15A', '15A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-15B', '15B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-15C', '15C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-15D', '15D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-15E', '15E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-15F', '15F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-16A', '16A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-16B', '16B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-16C', '16C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-16D', '16D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-16E', '16E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-16F', '16F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-17A', '17A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-17B', '17B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-17C', '17C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-17D', '17D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-17E', '17E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-17F', '17F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-18A', '18A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-18B', '18B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-18C', '18C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-18D', '18D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-18E', '18E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-18F', '18F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-19A', '19A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-19B', '19B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-19C', '19C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-19D', '19D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-19E', '19E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-19F', '19F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-20A', '20A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-20B', '20B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-20C', '20C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-20D', '20D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-20E', '20E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-20F', '20F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-21A', '21A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-21B', '21B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-21C', '21C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-21D', '21D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-21E', '21E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-21F', '21F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-22A', '22A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-22B', '22B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-22C', '22C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-22D', '22D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-22E', '22E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-22F', '22F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-23A', '23A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-23B', '23B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-23C', '23C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-23D', '23D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-23E', '23E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-23F', '23F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-24A', '24A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-24B', '24B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-24C', '24C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-24D', '24D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-24E', '24E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-24F', '24F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-25A', '25A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-25B', '25B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-25C', '25C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-25D', '25D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-25E', '25E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-25F', '25F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-26A', '26A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-26B', '26B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-26C', '26C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-26D', '26D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-26E', '26E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-26F', '26F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-27A', '27A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-27B', '27B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-27C', '27C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-27D', '27D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-27E', '27E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-27F', '27F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-28A', '28A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-28B', '28B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-28C', '28C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-28D', '28D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-28E', '28E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-28F', '28F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-29A', '29A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-29B', '29B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-29C', '29C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-29D', '29D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-29E', '29E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-29F', '29F', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-30A', '30A', 'AV-A320-01', 'Ventana', 1),
('AV-A320-01-30B', '30B', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-30C', '30C', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-30D', '30D', 'AV-A320-01', 'Pasillo', 1),
('AV-A320-01-30E', '30E', 'AV-A320-01', 'Medio', 1),
('AV-A320-01-30F', '30F', 'AV-A320-01', 'Ventana', 1);

INSERT INTO Asiento (IDAsiento, codigo, avion_id, tipo, disponible) VALUES 
('AV-A320-02-01A', '01A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-01B', '01B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-01C', '01C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-01D', '01D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-01E', '01E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-01F', '01F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-02A', '02A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-02B', '02B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-02C', '02C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-02D', '02D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-02E', '02E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-02F', '02F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-03A', '03A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-03B', '03B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-03C', '03C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-03D', '03D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-03E', '03E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-03F', '03F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-04A', '04A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-04B', '04B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-04C', '04C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-04D', '04D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-04E', '04E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-04F', '04F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-05A', '05A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-05B', '05B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-05C', '05C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-05D', '05D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-05E', '05E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-05F', '05F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-06A', '06A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-06B', '06B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-06C', '06C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-06D', '06D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-06E', '06E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-06F', '06F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-07A', '07A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-07B', '07B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-07C', '07C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-07D', '07D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-07E', '07E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-07F', '07F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-08A', '08A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-08B', '08B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-08C', '08C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-08D', '08D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-08E', '08E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-08F', '08F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-09A', '09A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-09B', '09B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-09C', '09C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-09D', '09D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-09E', '09E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-09F', '09F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-10A', '10A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-10B', '10B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-10C', '10C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-10D', '10D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-10E', '10E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-10F', '10F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-11A', '11A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-11B', '11B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-11C', '11C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-11D', '11D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-11E', '11E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-11F', '11F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-12A', '12A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-12B', '12B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-12C', '12C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-12D', '12D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-12E', '12E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-12F', '12F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-13A', '13A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-13B', '13B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-13C', '13C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-13D', '13D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-13E', '13E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-13F', '13F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-14A', '14A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-14B', '14B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-14C', '14C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-14D', '14D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-14E', '14E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-14F', '14F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-15A', '15A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-15B', '15B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-15C', '15C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-15D', '15D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-15E', '15E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-15F', '15F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-16A', '16A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-16B', '16B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-16C', '16C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-16D', '16D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-16E', '16E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-16F', '16F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-17A', '17A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-17B', '17B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-17C', '17C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-17D', '17D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-17E', '17E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-17F', '17F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-18A', '18A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-18B', '18B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-18C', '18C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-18D', '18D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-18E', '18E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-18F', '18F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-19A', '19A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-19B', '19B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-19C', '19C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-19D', '19D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-19E', '19E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-19F', '19F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-20A', '20A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-20B', '20B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-20C', '20C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-20D', '20D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-20E', '20E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-20F', '20F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-21A', '21A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-21B', '21B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-21C', '21C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-21D', '21D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-21E', '21E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-21F', '21F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-22A', '22A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-22B', '22B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-22C', '22C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-22D', '22D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-22E', '22E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-22F', '22F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-23A', '23A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-23B', '23B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-23C', '23C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-23D', '23D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-23E', '23E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-23F', '23F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-24A', '24A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-24B', '24B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-24C', '24C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-24D', '24D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-24E', '24E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-24F', '24F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-25A', '25A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-25B', '25B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-25C', '25C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-25D', '25D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-25E', '25E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-25F', '25F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-26A', '26A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-26B', '26B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-26C', '26C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-26D', '26D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-26E', '26E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-26F', '26F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-27A', '27A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-27B', '27B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-27C', '27C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-27D', '27D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-27E', '27E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-27F', '27F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-28A', '28A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-28B', '28B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-28C', '28C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-28D', '28D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-28E', '28E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-28F', '28F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-29A', '29A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-29B', '29B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-29C', '29C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-29D', '29D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-29E', '29E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-29F', '29F', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-30A', '30A', 'AV-A320-02', 'Ventana', 1),
('AV-A320-02-30B', '30B', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-30C', '30C', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-30D', '30D', 'AV-A320-02', 'Pasillo', 1),
('AV-A320-02-30E', '30E', 'AV-A320-02', 'Medio', 1),
('AV-A320-02-30F', '30F', 'AV-A320-02', 'Ventana', 1);

INSERT INTO Asiento (IDAsiento, codigo, avion_id, tipo, disponible) VALUES 
('AV-B737-01-01A', '01A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-01B', '01B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-01C', '01C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-01D', '01D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-01E', '01E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-01F', '01F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-02A', '02A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-02B', '02B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-02C', '02C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-02D', '02D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-02E', '02E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-02F', '02F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-03A', '03A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-03B', '03B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-03C', '03C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-03D', '03D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-03E', '03E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-03F', '03F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-04A', '04A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-04B', '04B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-04C', '04C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-04D', '04D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-04E', '04E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-04F', '04F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-05A', '05A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-05B', '05B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-05C', '05C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-05D', '05D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-05E', '05E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-05F', '05F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-06A', '06A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-06B', '06B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-06C', '06C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-06D', '06D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-06E', '06E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-06F', '06F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-07A', '07A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-07B', '07B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-07C', '07C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-07D', '07D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-07E', '07E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-07F', '07F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-08A', '08A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-08B', '08B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-08C', '08C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-08D', '08D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-08E', '08E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-08F', '08F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-09A', '09A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-09B', '09B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-09C', '09C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-09D', '09D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-09E', '09E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-09F', '09F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-10A', '10A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-10B', '10B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-10C', '10C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-10D', '10D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-10E', '10E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-10F', '10F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-11A', '11A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-11B', '11B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-11C', '11C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-11D', '11D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-11E', '11E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-11F', '11F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-12A', '12A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-12B', '12B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-12C', '12C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-12D', '12D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-12E', '12E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-12F', '12F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-13A', '13A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-13B', '13B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-13C', '13C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-13D', '13D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-13E', '13E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-13F', '13F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-14A', '14A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-14B', '14B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-14C', '14C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-14D', '14D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-14E', '14E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-14F', '14F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-15A', '15A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-15B', '15B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-15C', '15C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-15D', '15D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-15E', '15E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-15F', '15F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-16A', '16A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-16B', '16B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-16C', '16C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-16D', '16D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-16E', '16E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-16F', '16F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-17A', '17A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-17B', '17B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-17C', '17C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-17D', '17D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-17E', '17E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-17F', '17F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-18A', '18A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-18B', '18B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-18C', '18C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-18D', '18D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-18E', '18E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-18F', '18F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-19A', '19A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-19B', '19B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-19C', '19C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-19D', '19D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-19E', '19E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-19F', '19F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-20A', '20A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-20B', '20B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-20C', '20C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-20D', '20D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-20E', '20E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-20F', '20F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-21A', '21A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-21B', '21B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-21C', '21C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-21D', '21D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-21E', '21E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-21F', '21F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-22A', '22A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-22B', '22B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-22C', '22C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-22D', '22D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-22E', '22E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-22F', '22F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-23A', '23A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-23B', '23B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-23C', '23C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-23D', '23D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-23E', '23E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-23F', '23F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-24A', '24A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-24B', '24B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-24C', '24C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-24D', '24D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-24E', '24E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-24F', '24F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-25A', '25A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-25B', '25B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-25C', '25C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-25D', '25D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-25E', '25E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-25F', '25F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-26A', '26A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-26B', '26B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-26C', '26C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-26D', '26D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-26E', '26E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-26F', '26F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-27A', '27A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-27B', '27B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-27C', '27C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-27D', '27D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-27E', '27E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-27F', '27F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-28A', '28A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-28B', '28B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-28C', '28C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-28D', '28D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-28E', '28E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-28F', '28F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-29A', '29A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-29B', '29B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-29C', '29C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-29D', '29D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-29E', '29E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-29F', '29F', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-30A', '30A', 'AV-B737-01', 'Ventana', 1),
('AV-B737-01-30B', '30B', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-30C', '30C', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-30D', '30D', 'AV-B737-01', 'Pasillo', 1),
('AV-B737-01-30E', '30E', 'AV-B737-01', 'Medio', 1),
('AV-B737-01-30F', '30F', 'AV-B737-01', 'Ventana', 1);

INSERT INTO Asiento (IDAsiento, codigo, avion_id, tipo, disponible) VALUES 
('AV-B737-02-01A', '01A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-01B', '01B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-01C', '01C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-01D', '01D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-01E', '01E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-01F', '01F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-02A', '02A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-02B', '02B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-02C', '02C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-02D', '02D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-02E', '02E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-02F', '02F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-03A', '03A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-03B', '03B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-03C', '03C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-03D', '03D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-03E', '03E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-03F', '03F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-04A', '04A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-04B', '04B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-04C', '04C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-04D', '04D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-04E', '04E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-04F', '04F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-05A', '05A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-05B', '05B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-05C', '05C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-05D', '05D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-05E', '05E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-05F', '05F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-06A', '06A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-06B', '06B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-06C', '06C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-06D', '06D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-06E', '06E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-06F', '06F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-07A', '07A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-07B', '07B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-07C', '07C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-07D', '07D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-07E', '07E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-07F', '07F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-08A', '08A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-08B', '08B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-08C', '08C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-08D', '08D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-08E', '08E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-08F', '08F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-09A', '09A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-09B', '09B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-09C', '09C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-09D', '09D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-09E', '09E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-09F', '09F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-10A', '10A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-10B', '10B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-10C', '10C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-10D', '10D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-10E', '10E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-10F', '10F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-11A', '11A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-11B', '11B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-11C', '11C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-11D', '11D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-11E', '11E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-11F', '11F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-12A', '12A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-12B', '12B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-12C', '12C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-12D', '12D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-12E', '12E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-12F', '12F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-13A', '13A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-13B', '13B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-13C', '13C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-13D', '13D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-13E', '13E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-13F', '13F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-14A', '14A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-14B', '14B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-14C', '14C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-14D', '14D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-14E', '14E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-14F', '14F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-15A', '15A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-15B', '15B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-15C', '15C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-15D', '15D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-15E', '15E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-15F', '15F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-16A', '16A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-16B', '16B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-16C', '16C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-16D', '16D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-16E', '16E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-16F', '16F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-17A', '17A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-17B', '17B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-17C', '17C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-17D', '17D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-17E', '17E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-17F', '17F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-18A', '18A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-18B', '18B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-18C', '18C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-18D', '18D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-18E', '18E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-18F', '18F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-19A', '19A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-19B', '19B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-19C', '19C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-19D', '19D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-19E', '19E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-19F', '19F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-20A', '20A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-20B', '20B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-20C', '20C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-20D', '20D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-20E', '20E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-20F', '20F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-21A', '21A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-21B', '21B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-21C', '21C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-21D', '21D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-21E', '21E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-21F', '21F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-22A', '22A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-22B', '22B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-22C', '22C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-22D', '22D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-22E', '22E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-22F', '22F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-23A', '23A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-23B', '23B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-23C', '23C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-23D', '23D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-23E', '23E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-23F', '23F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-24A', '24A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-24B', '24B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-24C', '24C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-24D', '24D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-24E', '24E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-24F', '24F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-25A', '25A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-25B', '25B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-25C', '25C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-25D', '25D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-25E', '25E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-25F', '25F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-26A', '26A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-26B', '26B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-26C', '26C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-26D', '26D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-26E', '26E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-26F', '26F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-27A', '27A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-27B', '27B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-27C', '27C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-27D', '27D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-27E', '27E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-27F', '27F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-28A', '28A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-28B', '28B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-28C', '28C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-28D', '28D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-28E', '28E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-28F', '28F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-29A', '29A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-29B', '29B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-29C', '29C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-29D', '29D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-29E', '29E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-29F', '29F', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-30A', '30A', 'AV-B737-02', 'Ventana', 1),
('AV-B737-02-30B', '30B', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-30C', '30C', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-30D', '30D', 'AV-B737-02', 'Pasillo', 1),
('AV-B737-02-30E', '30E', 'AV-B737-02', 'Medio', 1),
('AV-B737-02-30F', '30F', 'AV-B737-02', 'Ventana', 1);

-- =========================================================================
-- Procedimientos de Chorifly
-- =========================================================================

-- =========================================
-- PROCEDIMIENTOS DE Aeropuerto
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Aeropuerto(IN p_nombre VARCHAR(120), IN p_pais VARCHAR(30), IN p_ciudad VARCHAR(80))
BEGIN
    INSERT INTO Aeropuerto(nombre, pais, city) VALUES(p_nombre, p_pais, p_ciudad);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Aeropuerto(IN p_idaeropuerto INT, IN p_nombre VARCHAR(120), IN p_pais VARCHAR(30), IN p_ciudad VARCHAR(80))
BEGIN
    UPDATE Aeropuerto SET nombre = COALESCE(p_nombre, nombre), pais = COALESCE(p_pais, pais), ciudad = COALESCE(p_ciudad, ciudad) WHERE IDAeropuerto = p_idaeropuerto;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Aeropuertos()
BEGIN
    SELECT * FROM Aeropuerto;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Aeropuerto(IN p_idaeropuerto INT)
BEGIN
    SELECT * FROM Aeropuerto WHERE IDAeropuerto = p_idaeropuerto;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Aeropuerto(IN p_idaeropuerto INT)
BEGIN
    DELETE FROM Aeropuerto WHERE IDAeropuerto = p_idaeropuerto;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Aeropuerto_Por_Pais(IN p_pais VARCHAR(30))
BEGIN
    SELECT * FROM Aeropuerto WHERE pais = p_pais;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Aeropuerto_Por_Nombre(IN p_nombre VARCHAR(120))
BEGIN
    SELECT * FROM Aeropuerto WHERE nombre = p_nombre;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Aeropuerto_Por_Ciudad(IN p_ciudad VARCHAR(80))
BEGIN
    SELECT * FROM Aeropuerto WHERE ciudad = p_ciudad;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Nombre_Aeropuertos()
BEGIN
    SELECT nombre FROM Aeropuerto;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Extras_Aeropuertos()
BEGIN
    SELECT IDAeropuerto, nombre FROM Aeropuerto;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Avion
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Avion(IN p_idavion VARCHAR(30), IN p_modelo VARCHAR(50), IN p_capacidad INT)
BEGIN
    INSERT INTO Avion(IDAvion, modelo, capacidad) VALUES(p_idavion, p_modelo, p_capacidad);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Avion(IN p_idavion VARCHAR(30), IN p_modelo VARCHAR(50), IN p_capacidad INT)
BEGIN
    UPDATE Avion SET modelo = COALESCE(p_modelo, modelo), capacidad = COALESCE(p_capacidad, capacidad) WHERE IDAvion = p_idavion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Avion()
BEGIN
    SELECT * FROM Avion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Avion(IN p_idavion VARCHAR(30))
BEGIN
    SELECT * FROM Avion WHERE IDAvion = p_idavion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Avion(IN p_idavion VARCHAR(30))
BEGIN
    DELETE FROM Avion WHERE IDAvion = p_idavion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Avion_Por_Modelo(IN p_modelo VARCHAR(30))
BEGIN
    SELECT * FROM Avion WHERE modelo = p_modelo;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_ID_Aviones()
BEGIN
    SELECT IDAvion FROM Avion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Avion_Por_Capacidad(IN p_capacidad INT)
BEGIN
    SELECT * FROM Avion WHERE capacidad = p_capacidad;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Modelos_De_Aviones_Unicos()
BEGIN
    SELECT DISTINCT modelo FROM Avion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Avion_Por_Rango_De_Capacidad(IN p_capacidad_min INT, IN p_capacidad_max INT)
BEGIN
    SELECT * FROM Avion WHERE capacidad BETWEEN p_capacidad_min AND p_capacidad_max;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Asiento
-- =========================================
DELIMITER //
CREATE PROCEDURE Buscar_Asiento_Por_Id(IN p_idasiento VARCHAR(50))
BEGIN
    SELECT * FROM Asiento WHERE IDAsiento = p_idasiento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Asientos_Por_Avion(IN p_avion_id VARCHAR(30))
BEGIN
    SELECT * FROM Asiento WHERE avion_id = p_avion_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Disponibilidad_Asientos_Por_Avion(IN p_avion_id VARCHAR(30))
BEGIN
    SELECT disponible FROM Asiento WHERE avion_id = p_avion_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Asientos()
BEGIN
    SELECT * FROM Asiento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Asientos_Por_Disponibilidad(IN p_disponible BOOLEAN)
BEGIN
    SELECT * FROM Asiento WHERE disponible = p_disponible;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Asiento(IN p_disponible BOOLEAN, IN p_idasiento VARCHAR(50))
BEGIN
    UPDATE Asiento SET disponible = p_disponible WHERE IDAsiento = p_idasiento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Ocupar_Asiento(IN p_idasiento VARCHAR(50))
BEGIN
    UPDATE Asiento SET disponible = 0 WHERE IDAsiento = p_idasiento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Liberar_Asiento(IN p_idasiento VARCHAR(50))
BEGIN
    UPDATE Asiento SET disponible = 1 WHERE IDAsiento = p_idasiento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Asientos_Por_Codigo(IN p_codigo varchar(5))
BEGIN
    SELECT * FROM Asiento WHERE codigo = p_codigo;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Asientos_Por_Tipo(IN p_tipo ENUM("Ventana", "Medio", "Pasillo"))
BEGIN
    SELECT * FROM Asiento WHERE tipo = p_tipo;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Departamento
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Departamento(IN p_nombre VARCHAR(100), IN p_tipo ENUM("Aéreo", "Terrestre"))
BEGIN
    INSERT INTO Departamento(nombre, tipo) VALUES(p_nombre, p_tipo);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Departamento(IN p_iddepartamento INT, IN p_nombre VARCHAR(100), IN p_tipo ENUM("Aéreo", "Terrestre"))
BEGIN
    UPDATE Departamento SET nombre = COALESCE(p_nombre, nombre), tipo = COALESCE(p_tipo, tipo) WHERE IDDepartamento = p_iddepartamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Departamento()
BEGIN
    SELECT * FROM Departamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Departamento(IN p_iddepartamento INT)
BEGIN
    SELECT * FROM Departamento WHERE IDDepartamento = p_iddepartamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Departamento(IN p_iddepartamento INT)
BEGIN
    DELETE FROM Departamento WHERE IDDepartamento = p_iddepartamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Departamento_Por_Nombre(IN p_nombre VARCHAR(100))
BEGIN
    SELECT * FROM Departamento WHERE nombre = p_nombre;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Departamento_Por_Tipo(IN p_tipo ENUM("Aéreo", "Terrestre"))
BEGIN
    SELECT * FROM Departamento WHERE tipo = p_tipo;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Extras_Departamentos()
BEGIN
    SELECT IDDepartamento, nombre FROM Departamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Departamentos_Ordenados_Por_Nombre()
BEGIN
    SELECT * FROM Departamento ORDER BY nombre ASC;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Departamentos_Ordenados_Por_Nombre_Para_Atras()
BEGIN
    SELECT * FROM Departamento ORDER BY nombre DESC;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Servicio
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Servicio(IN p_nombre_servicio VARCHAR(20), IN p_precio DECIMAL(10, 2), IN p_descripcion VARCHAR(120))
BEGIN
    INSERT INTO Servicio(nombre_servicio, precio, descripcion) VALUES(p_nombre_servicio, p_precio, p_descripcion);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Servicio(IN p_idservicio INT, IN p_nombre_servicio VARCHAR(20), IN p_precio DECIMAL(10, 2), IN p_descripcion VARCHAR(120))
BEGIN
    UPDATE Servicio SET nombre_servicio = COALESCE(p_nombre_servicio, nombre_servicio), precio = COALESCE(p_precio, precio), descripcion = COALESCE(p_descripcion, p_descripcion) WHERE IDServicio = p_idservicio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Servicio()
BEGIN
    SELECT * FROM Servicio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio(IN p_idservicio INT)
BEGIN
    SELECT * FROM Servicio WHERE IDServicio = p_idservicio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Servicio(IN p_idservicio INT)
BEGIN
    DELETE FROM Servicio WHERE IDServicio = p_idservicio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Nombre(IN p_nombre_servicio VARCHAR(20))
BEGIN
    SELECT * FROM Servicio WHERE nombre_servicio = p_nombre_servicio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Precio(IN p_precio DECIMAL(10, 2))
BEGIN
    SELECT * FROM Servicio WHERE precio = p_precio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Descripcion(IN p_descripcion VARCHAR(120))
BEGIN
    SELECT * FROM Servicio WHERE descripcion = p_descripcion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Precio_Mayor_A(IN p_precio DECIMAL(10, 2))
BEGIN
    SELECT * FROM Servicio WHERE precio > p_precio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Precio_Menor_A(IN p_precio DECIMAL(10, 2))
BEGIN
    SELECT * FROM Servicio WHERE precio < p_precio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Rango_De_Precio(IN p_precio_min DECIMAL(10, 2), IN p_precio_max DECIMAL(10, 2))
BEGIN
    SELECT * FROM Servicio WHERE precio BETWEEN p_precio_min AND p_precio_max;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Usuario
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Usuario(IN p_nombre_usuario VARCHAR(30), IN p_email VARCHAR(40), IN p_contraseña_usuario VARCHAR(30), IN p_privilegios_empleado BOOLEAN, IN p_pregunta_seguridad VARCHAR(100), IN p_respuesta_seguridad VARCHAR(100))
BEGIN
    INSERT INTO Usuario(nombre_usuario, email, contraseña_usuario, privilegios_empleado, pregunta_seguridad, respuesta_seguridad) VALUES(p_nombre_usuario, p_email, p_contraseña_usuario, p_privilegios_empleado, p_pregunta_seguridad, p_respuesta_seguridad);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Usuario(IN p_idusuario INT, IN p_nombre_usuario VARCHAR(30), IN p_email VARCHAR(40), IN p_contraseña_usuario VARCHAR(30), IN p_privilegios_empleado BOOLEAN, IN p_pregunta_seguridad VARCHAR(100), IN p_respuesta_seguridad VARCHAR(100))
BEGIN
    UPDATE Usuario SET nombre_usuario = COALESCE(p_nombre_usuario, nombre_usuario), email = COALESCE(p_email, email), contraseña_usuario = COALESCE(p_contraseña_usuario, contraseña_usuario), privilegios_empleado = COALESCE(p_privilegios_empleado, privilegios_empleado), pregunta_seguridad = COALESCE(p_pregunta_seguridad, pregunta_seguridad), respuesta_seguridad = COALESCE(p_respuesta_seguridad, respuesta_seguridad) WHERE IDUsuario = p_idusuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Usuario()
BEGIN
    SELECT * FROM Usuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Usuario(IN p_idusuario INT)
BEGIN
    SELECT * FROM Usuario WHERE IDUsuario = p_idusuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Usuario(IN p_idusuario INT)
BEGIN
    DELETE FROM Usuario WHERE IDUsuario = p_idusuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Usuario_Por_Nombre(IN p_nombre_usuario VARCHAR(30))
BEGIN
    SELECT * FROM Usuario WHERE nombre_usuario = p_nombre_usuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Usuarios_Sin_Permisos()
BEGIN
    SELECT * FROM Usuario WHERE privilegios_empleado = FALSE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Usuarios_Con_Permisos()
BEGIN
    SELECT * FROM Usuario WHERE privilegios_empleado = TRUE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Validar_Usuario_Unico(IN p_nombre_usuario VARCHAR(30))
BEGIN
    SELECT COUNT(*) FROM Usuario WHERE nombre_usuario = p_nombre_usuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Validar_Email_Unico(IN p_email VARCHAR(40))
BEGIN
    SELECT COUNT(*) FROM Usuario WHERE email = p_email;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Validar_Usuario_Editar(IN p_nombre_usuario VARCHAR(30), IN p_id INT)
BEGIN
    SELECT COUNT(*) FROM Usuario WHERE nombre_usuario = p_nombre_usuario AND IDUsuario != p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Validar_Email_Editar(IN p_email VARCHAR(40), IN p_id INT)
BEGIN
    SELECT COUNT(*) FROM Usuario WHERE email = p_email AND IDUsuario != p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Contraseña_Usuario(IN p_contraseña_usuario VARCHAR(30), IN p_id INT)
BEGIN
    UPDATE Usuario SET contraseña_usuario = p_contraseña_usuario WHERE IDUsuario = p_id;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Pago
-- =========================================
DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Estado(IN p_estado VARCHAR(20))
BEGIN
    SELECT * FROM Pago WHERE estado = p_estado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Agregar_Pago(IN p_pasajero_id INT, IN p_boleto_id INT, IN p_costo_servicios DECIMAL(10, 2), IN p_costo_total DECIMAL(10, 2), IN p_estado VARCHAR(20))
BEGIN
    INSERT INTO Pago (pasajero_id, boleto_id, costo_servicios, costo_total, estado) VALUES (p_pasajero_id, p_boleto_id, p_costo_servicios, p_costo_total, p_estado);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Pagos()
BEGIN
    SELECT * FROM Pago;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Id(IN p_id INT)
BEGIN
    SELECT * FROM Pago WHERE IDPago = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Pago(IN p_pasajero_id INT, IN p_boleto_id INT, IN p_costo_servicios DECIMAL(10, 2), IN p_costo_total DECIMAL(10, 2), IN p_estado VARCHAR(20), IN p_id INT)
BEGIN
    UPDATE Pago SET pasajero_id = p_pasajero_id, boleto_id = p_boleto_id, costo_servicios = p_costo_servicios, costo_total = p_costo_total, estado = p_estado WHERE IDPago = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Pago(IN p_id INT)
BEGIN
    DELETE FROM Pago WHERE IDPago = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Boleto(IN p_boleto_id INT)
BEGIN
    SELECT * FROM Pago WHERE boleto_id = p_boleto_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Pasajero(IN p_pasajero_id INT)
BEGIN
    SELECT * FROM Pago WHERE pasajero_id = p_pasajero_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Costo_Mayor_A(IN p_costo_total DECIMAL(10, 2))
BEGIN
    SELECT * FROM Pago WHERE costo_total > p_costo_total;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Costo_Menor_A(IN p_costo_total DECIMAL(10, 2))
BEGIN
    SELECT * FROM Pago WHERE costo_total < p_costo_total;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Vuelo
-- =========================================
DELIMITER //
CREATE PROCEDURE Buscar_Vuelo_Por_Id(IN p_idvuelo INT)
BEGIN
    SELECT * FROM Vuelo WHERE IDVuelo = p_idvuelo;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Vuelos_Programados()
BEGIN
    SELECT IDVuelo, avion_id, origen_id, destino_id FROM Vuelo WHERE estado = 'Programado';
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Agregar_Vuelo(IN p_avion_id VARCHAR(30), IN p_origen_id INT, IN p_destino_id INT, IN p_fecha_hora_salida DATETIME, IN p_fecha_hora_llegada DATETIME, IN p_estado VARCHAR(20))
BEGIN
    INSERT INTO Vuelo (avion_id, origen_id, destino_id, fecha_hora_salida, fecha_hora_llegada, estado) VALUES (p_avion_id, p_origen_id, p_destino_id, p_fecha_hora_salida, p_fecha_hora_llegada, p_estado);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Todos_Los_Vuelos()
BEGIN
    SELECT * FROM Vuelo;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Vuelo(IN p_avion_id VARCHAR(30), IN p_origen_id INT, IN p_destino_id INT, IN p_fecha_hora_salida DATETIME, IN p_fecha_hora_llegada DATETIME, IN p_estado VARCHAR(20), IN p_id INT)
BEGIN
    UPDATE Vuelo SET avion_id = p_avion_id, origen_id = p_origen_id, destino_id = p_destino_id, fecha_hora_salida = p_fecha_hora_salida, fecha_hora_llegada = p_fecha_hora_llegada, estado = p_estado WHERE IDVuelo = p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Vuelo(IN p_id INT)
BEGIN
    DELETE FROM Vuelo WHERE IDVuelo = p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Vuelo_Por_Avion(IN p_avion_id VARCHAR(30))
BEGIN
    SELECT * FROM Vuelo WHERE avion_id = p_avion_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Vuelo_Por_Destino(IN p_destino_id INT)
BEGIN
    SELECT * FROM Vuelo WHERE destino_id = p_destino_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Vuelo_Por_Estado(IN p_estado VARCHAR(20))
BEGIN
    SELECT * FROM Vuelo WHERE estado = p_estado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Vuelo_Por_Origen(IN p_origen_id INT)
BEGIN
    SELECT * FROM Vuelo WHERE origen_id = p_origen_id;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Pasajero
-- =========================================
DELIMITER //
CREATE PROCEDURE Mostrar_Extras_Pasajeros()
BEGIN
    SELECT IDPasajero, nombre_pasajero, apellido_pasajero FROM Pasajero;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Agregar_Pasajero(IN p_nombre VARCHAR(50), IN p_apellido VARCHAR(50), IN p_dni VARCHAR(15), IN p_telefono VARCHAR(20), IN p_fecha_nacimiento DATE, IN p_nro_pasaporte VARCHAR(20), IN p_pais_emision CHAR(3), IN p_vencimiento_pasaporte DATE, IN p_usuario_id INT)
BEGIN
    INSERT INTO Pasajero (nombre_pasajero, apellido_pasajero, dni_pasajero, telefono, fecha_nacimiento, nro_pasaporte, pais_emision, vencimiento_pasaporte, usuario_id) VALUES (p_nombre, p_apellido, p_dni, p_telefono, p_fecha_nacimiento, p_nro_pasaporte, p_pais_emision, p_vencimiento_pasaporte, p_usuario_id);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Pasajeros()
BEGIN
    SELECT * FROM Pasajero;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pasajero_Por_Id(IN p_id INT)
BEGIN
    SELECT * FROM Pasajero WHERE IDPasajero = p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Pasajero(IN p_nombre VARCHAR(50), IN p_apellido VARCHAR(50), IN p_dni VARCHAR(15), IN p_telefono VARCHAR(20), IN p_fecha_nacimiento DATE, IN p_nro_pasaporte VARCHAR(20), IN p_pais_emision CHAR(3), IN p_vencimiento_pasaporte DATE, IN p_usuario_id INT, IN p_id INT)
BEGIN
    UPDATE Pasajero SET nombre_pasajero = p_nombre, apellido_pasajero = p_apellido, dni_pasajero = p_dni, telefono = p_telefono, fecha_nacimiento = p_fecha_nacimiento, nro_pasaporte = p_nro_pasaporte, pais_emision = p_pais_emision, vencimiento_pasaporte = p_vencimiento_pasaporte, usuario_id = p_usuario_id WHERE IDPasajero = p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Pasajero(IN p_id INT)
BEGIN
    DELETE FROM Pasajero WHERE IDPasajero = p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pasajero_Por_Nombre(IN p_nombre VARCHAR(50))
BEGIN
    SELECT * FROM Pasajero WHERE nombre_pasajero = p_nombre;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pasajero_Por_Apellido(IN p_apellido VARCHAR(50))
BEGIN
    SELECT * FROM Pasajero WHERE apellido_pasajero = p_apellido;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pasajero_Por_Dni(IN p_dni VARCHAR(15))
BEGIN
    SELECT * FROM Pasajero WHERE dni_pasajero = p_dni;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pasajero_Por_Telefono(IN p_telefono VARCHAR(20))
BEGIN
    SELECT * FROM Pasajero WHERE telefono = p_telefono;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Boleto
-- =========================================
DELIMITER //
CREATE PROCEDURE Mostrar_Boletos_Para_Checkin()
BEGIN
    SELECT b.IDBoleto FROM Boleto b INNER JOIN Pago pa ON b.IDBoleto = pa.boleto_id LEFT JOIN CheckIn c ON b.IDBoleto = c.boleto_id WHERE pa.estado = 'Pagado' AND c.IDCheckin IS NULL;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Agregar_Boleto(IN p_pasajero_id INT, IN p_vuelo_id INT, IN p_asiento_id VARCHAR(50), IN p_fecha DATETIME, IN p_precio_base DECIMAL(10, 2), OUT p_id_generado INT)
BEGIN
    INSERT INTO Boleto (pasajero_id, vuelo_id, asiento_id, fecha, precio_base) VALUES (p_pasajero_id, p_vuelo_id, p_asiento_id, p_fecha, p_precio_base);
    SET p_id_generado = LAST_INSERT_ID();
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Boletos()
BEGIN
    SELECT * FROM Boleto;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Boleto_Por_Id(IN p_id INT)
BEGIN
    SELECT * FROM Boleto WHERE IDBoleto = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Boleto(IN p_id INT, IN p_pasajero_id INT, IN p_vuelo_id INT, IN p_asiento_id VARCHAR(50), IN p_fecha DATETIME, IN p_precio_base DECIMAL(10, 2))
BEGIN
    UPDATE Boleto SET pasajero_id = p_pasajero_id, vuelo_id = p_vuelo_id, asiento_id = p_asiento_id, fecha = p_fecha, precio_base = p_precio_base WHERE IDBoleto = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Boleto(IN p_id INT)
BEGIN
    DELETE FROM Boleto WHERE IDBoleto = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Boleto_Por_Pasajero(IN p_pasajero_id INT)
BEGIN
    SELECT * FROM Boleto WHERE pasajero_id = p_pasajero_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Boleto_Por_Vuelo(IN p_vuelo_id INT)
BEGIN
    SELECT * FROM Boleto WHERE vuelo_id = p_vuelo_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Boleto_Por_Fecha(IN p_fecha DATETIME)
BEGIN
    SELECT * FROM Boleto WHERE fecha = p_fecha;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Boleto_Por_Asiento(IN p_asiento_id VARCHAR(50))
BEGIN
    SELECT * FROM Boleto WHERE asiento_id = p_asiento_id;
END //
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Boleto_Servicio
-- =========================================
DELIMITER //
CREATE PROCEDURE Buscar_Servicios_Por_Boleto(IN p_boleto_id INT)
BEGIN
    SELECT s.IDServicio, s.nombre_servicio, s.precio, s.descripcion FROM Servicio s INNER JOIN Boleto_Servicio bs ON s.IDServicio = bs.servicio_id WHERE bs.boleto_id = p_boleto_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Insertar_Boleto_Servicio(IN p_boleto_id INT, IN p_servicio_id INT)
BEGIN
    INSERT INTO Boleto_Servicio (boleto_id, servicio_id) VALUES (p_boleto_id, p_servicio_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Servicios_De_Boleto(IN p_boleto_id INT)
BEGIN
    DELETE FROM Boleto_Servicio WHERE boleto_id = p_boleto_id;
END //
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE CheckIn
-- =========================================
DELIMITER //
CREATE PROCEDURE Agregar_CheckIn(IN p_pasajero_id INT, IN p_boleto_id INT, IN p_vuelo_id INT, IN p_pago_id INT, IN p_puerta_embarque CHAR(3))
BEGIN
    INSERT INTO CheckIn (pasajero_id, boleto_id, vuelo_id, pago_id, puerta_embarque) VALUES (p_pasajero_id, p_boleto_id, p_vuelo_id, p_pago_id, p_puerta_embarque);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_CheckIns()
BEGIN
    SELECT * FROM CheckIn;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_CheckIn_Por_Id(IN p_id INT)
BEGIN
    SELECT * FROM CheckIn WHERE IDCheckin = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_CheckIn(IN p_id INT, IN p_pasajero_id INT, IN p_boleto_id INT, IN p_vuelo_id INT, IN p_pago_id INT, IN p_puerta_embarque CHAR(3))
BEGIN
    UPDATE CheckIn SET pasajero_id = p_pasajero_id, boleto_id = p_boleto_id, vuelo_id = p_vuelo_id, pago_id = p_pago_id, puerta_embarque = p_puerta_embarque WHERE IDCheckin = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_CheckIn(IN p_id INT)
BEGIN
    DELETE FROM CheckIn WHERE IDCheckin = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_CheckIn_Por_pasajero(IN p_pasajero_id INT)
BEGIN
    SELECT * FROM CheckIn WHERE pasajero_id = p_pasajero_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_CheckIn_Por_Boleto(IN p_boleto_id INT)
BEGIN
    SELECT * FROM CheckIn WHERE boleto_id = p_boleto_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_CheckIn_Por_Puerta(IN p_puerta_embarque CHAR(3))
BEGIN
    SELECT * FROM CheckIn WHERE puerta_embarque = p_puerta_embarque;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_CheckIn_Por_Vuelo(IN p_vuelo_id INT)
BEGIN
    SELECT * FROM CheckIn WHERE vuelo_id = p_vuelo_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_CheckIn_Por_Pago(IN p_pago_id INT)
BEGIN
    SELECT * FROM CheckIn WHERE pago_id = p_pago_id;
END //
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Empleado
-- =========================================
DELIMITER //
CREATE PROCEDURE Agregar_Empleado(IN p_nombre VARCHAR(30), IN p_apellido VARCHAR(30), IN p_dni CHAR(8), IN p_telefono VARCHAR(20), IN p_sueldo DECIMAL(10, 2), IN p_departamento_id INT, IN p_aeropuerto_id INT, IN p_usuario_id INT)
BEGIN
    INSERT INTO Empleado (nombre_empleado, apellido_empleado, dni_empleado, telefono, sueldo, departamento_id, aeropuerto_id, usuario_id) VALUES (p_nombre, p_apellido, p_dni, p_telefono, p_sueldo, p_departamento_id, p_aeropuerto_id, p_usuario_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Empleados()
BEGIN
    SELECT * FROM Empleado;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Empleado_Por_Id(IN p_id INT)
BEGIN
    SELECT * FROM Empleado WHERE IDEmpleado = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Empleado(IN p_id INT, IN p_nombre VARCHAR(30), IN p_apellido VARCHAR(30), IN p_dni CHAR(8), IN p_telefono VARCHAR(20), IN p_sueldo DECIMAL(10, 2), IN p_departamento_id INT, IN p_aeropuerto_id INT, IN p_usuario_id INT)
BEGIN
    UPDATE Empleado SET nombre_empleado = p_nombre, apellido_empleado = p_apellido, dni_empleado = p_dni, telefono = p_telefono, sueldo = p_sueldo, departamento_id = p_departamento_id, aeropuerto_id = p_aeropuerto_id, usuario_id = p_usuario_id WHERE IDEmpleado = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Empleado(IN p_id INT)
BEGIN
    DELETE FROM Empleado WHERE IDEmpleado = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Empleado_Por_Nombre(IN p_nombre VARCHAR(30))
BEGIN
    SELECT * FROM Empleado WHERE nombre_empleado = p_nombre;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Empleado_Por_Apellido(IN p_apellido VARCHAR(30))
BEGIN
    SELECT * FROM Empleado WHERE apellido_empleado = p_apellido;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Empleado_Por_Dni(IN p_dni CHAR(8))
BEGIN
    SELECT * FROM Empleado WHERE dni_empleado = p_dni;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Empleado_Por_Departamanento(IN p_departamento_id INT)
BEGIN
    SELECT * FROM Empleado WHERE departamento_id = p_departamento_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Empleado_Por_Aeropuerto(IN p_aeropuerto_id INT)
BEGIN
    SELECT * FROM Empleado WHERE aeropuerto_id = p_aeropuerto_id;
END //
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Servidor HTML
-- =========================================

DELIMITER //
CREATE PROCEDURE Autenticar_Usuario (
    IN p_nombre_usuario VARCHAR(30),
    IN p_contrasenia_usuario VARCHAR(30)
)
BEGIN
    SELECT IDUsuario, privilegios_empleado
    FROM Usuario
    WHERE nombre_usuario = p_nombre_usuario
      AND contraseña_usuario = p_contrasenia_usuario;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Obtener_Email_Usuario (
    IN p_idusuario INT
)
BEGIN
    SELECT email
    FROM Usuario
    WHERE IDUsuario = p_idusuario;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_IDUsuario_Por_Nombre_O_Email (
    IN p_nombre_usuario VARCHAR(30),
    IN p_email VARCHAR(40)
)
BEGIN
    SELECT IDUsuario
    FROM Usuario
    WHERE nombre_usuario = p_nombre_usuario
       OR email = p_email
    LIMIT 1;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Contar_Vuelos_Activos_Avion (
    IN p_idvuelo INT,
    IN p_avion_id VARCHAR(30),
    IN p_fecha_llegada_nueva DATETIME,
    IN p_fecha_salida_nueva DATETIME
)
BEGIN
    SELECT COUNT(*)
    FROM Vuelo
    WHERE Vuelo.IDVuelo <> p_idvuelo
      AND Vuelo.avion_id = p_avion_id
      AND Vuelo.estado IN ('Volando', 'Programado', 'A Tiempo', 'Atrasado')
      AND Vuelo.fecha_hora_salida < p_fecha_llegada_nueva
      AND Vuelo.fecha_hora_llegada > p_fecha_salida_nueva;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Obtener_Horarios_Vuelos_Activos (
    IN p_idvuelo INT,
    IN p_fecha_llegada_nueva DATETIME,
    IN p_fecha_salida_nueva DATETIME
)
BEGIN
    SELECT Vuelo.fecha_hora_salida, Vuelo.fecha_hora_llegada
    FROM Vuelo
    WHERE Vuelo.IDVuelo <> p_idvuelo
      AND Vuelo.estado IN ('Volando', 'Programado', 'A Tiempo', 'Atrasado')
      AND Vuelo.fecha_hora_salida < p_fecha_llegada_nueva
      AND Vuelo.fecha_hora_llegada > p_fecha_salida_nueva;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Obtener_Detalle_Vuelos()
BEGIN
    SELECT V.IDVuelo, V.avion_id, A.modelo,
           V.origen_id, O.nombre AS origen, O.pais AS paisOrigen,
           V.destino_id, D.nombre AS destino, D.pais AS paisDestino,
           V.fecha_hora_salida, V.fecha_hora_llegada, V.estado
    FROM Vuelo V
    INNER JOIN Avion A ON V.avion_id = A.IDAvion
    INNER JOIN Aeropuerto O ON V.origen_id = O.IDAeropuerto
    INNER JOIN Aeropuerto D ON V.destino_id = D.IDAeropuerto;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Obtener_Datos_Vuelo_Para_Actualizar (
    IN p_idvuelo INT
)
BEGIN
    SELECT Vuelo.avion_id, Vuelo.fecha_hora_salida, Vuelo.estado
    FROM Vuelo
    WHERE Vuelo.IDVuelo = p_idvuelo
    FOR UPDATE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Obtener_IDAsiento_Para_Actualizar (
    IN p_codigo VARCHAR(5),
    IN p_avion_id VARCHAR(30)
)
BEGIN
    SELECT Asiento.IDAsiento
    FROM Asiento
    WHERE Asiento.codigo = p_codigo
      AND Asiento.avion_id = p_avion_id
      AND Asiento.disponible = TRUE
    FOR UPDATE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Obtener_Datos_Pasajero_Por_Usuario (
    IN p_idusuario INT
)
BEGIN
    SELECT P.IDPasajero, P.nombre_pasajero,
           P.apellido_pasajero, P.dni_pasajero, U.email
    FROM Pasajero P
    INNER JOIN Usuario U ON P.usuario_id = U.IDUsuario
    WHERE U.IDUsuario = p_idusuario;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Obtener_Asientos_Por_Vuelo (
    IN p_idvuelo INT
)
BEGIN
    SELECT A.codigo, A.disponible
    FROM Asiento A
    INNER JOIN Vuelo V ON A.avion_id = V.avion_id
    WHERE V.IDVuelo = p_idvuelo
    ORDER BY A.codigo;
END //
DELIMITER ;

-- =========================================================================
-- Triggers de Chorifly
-- =========================================================================

-- =========================================================================
-- TRIGGERS DE Usuario
-- =========================================================================

DELIMITER //
CREATE TRIGGER tg_usuario_insert_val_pass
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.contraseña_usuario) < 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_usuario_insert_val_pass): La contraseña debe tener al menos 8 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_val_email
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_usuario_insert_val_email): El correo electrónico no tiene un format válido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_val_resp_seg
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.respuesta_seguridad) < 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_usuario_insert_val_resp_seg): La respuesta de seguridad debe tener al menos 3 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_preg_vacia
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF TRIM(NEW.pregunta_seguridad) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_usuario_insert_preg_vacia): La pregunta de seguridad no puede estar vacía.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_insert_preg_resp_dist
BEFORE INSERT ON Usuario FOR EACH ROW
BEGIN
    IF LOWER(TRIM(NEW.pregunta_seguridad)) = LOWER(TRIM(NEW.respuesta_seguridad)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_usuario_insert_preg_resp_dist): La respuesta no puede ser idéntica a la pregunta.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_usuario_update_val_email): El correo electrónico modificado no es válido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_update_preg_resp_dist
BEFORE UPDATE ON Usuario FOR EACH ROW
BEGIN
    IF LOWER(TRIM(NEW.pregunta_seguridad)) = LOWER(TRIM(NEW.respuesta_seguridad)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_usuario_update_preg_resp_dist): La nueva respuesta modificada no puede coincidir con la pregunta.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_usuario_update_preg_vacia
BEFORE UPDATE ON Usuario FOR EACH ROW
BEGIN
    IF TRIM(NEW.pregunta_seguridad) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_usuario_update_preg_vacia): La nueva pregunta de seguridad no puede estar vacía.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_aeropuerto_insert_val_long_nombre): El nombre del aeropuerto debe tener al menos 5 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_update_val_nombre
BEFORE UPDATE ON Aeropuerto FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.nombre) < 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_aeropuerto_update_val_nombre): El nombre corregido del aeropuerto debe tener al menos 5 caracteres.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_aeropuerto_insert_val_vacio): Ningún campo de ubicación de aeropuerto puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aeropuerto_update_val_vacio
BEFORE UPDATE ON Aeropuerto FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre) = '' OR TRIM(NEW.ciudad) = '' OR TRIM(NEW.pais) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_aeropuerto_update_val_vacio): No se puede actualizar aeropuerto dejando campos vacíos.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_avion_insert_val_capacidad): La capacidad del avión debe ser un número positivo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_insert_capacidad_max
BEFORE INSERT ON Avion FOR EACH ROW
BEGIN
    IF NEW.capacidad > 500 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_avion_insert_capacidad_max): La capacidad del avión no puede superar los 500 asientos en LowCost.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_avion_update_val_capacidad): La capacidad modificada del avión debe ser un número positivo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_update_capacidad_max
BEFORE UPDATE ON Avion FOR EACH ROW
BEGIN
    IF NEW.capacidad > 500 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_avion_update_capacidad_max): La nueva capacidad modificada no puede superar los 500 asientos.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_avion_insert_modelo_vacio): El modelo de avión no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_avion_update_modelo_vacio
BEFORE UPDATE ON Avion FOR EACH ROW
BEGIN
    IF TRIM(NEW.modelo) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_avion_update_modelo_vacio): No se puede modificar un avión dejando el modelo vacío.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_departamento_insert_nombre_vacio): El nombre del departamento es obligatorio.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_update_nombre_vacio
BEFORE UPDATE ON Departamento FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_departamento_update_nombre_vacio): No se puede actualizar el departamento con un nombre vacío.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_departamento_insert_val_tipo): El tipo de departamento debe ser Aéreo o Terrestre.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_update_val_tipo
BEFORE UPDATE ON Departamento FOR EACH ROW
BEGIN
    IF NEW.tipo NOT IN ('Aéreo', 'Terrestre') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_departamento_update_val_tipo): El tipo de departamento modificado no es válido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_insert_val_longitud
BEFORE INSERT ON Departamento FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.nombre)) < 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_departamento_insert_val_longitud): El nombre del departamento debe tener al menos 3 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_departamento_update_val_longitud
BEFORE UPDATE ON Departamento FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.nombre)) < 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_departamento_update_val_longitud): El nombre modificado del departamento debe tener al menos 3 caracteres.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_departamento_delete_restrict_empleado): No se puede eliminar un departamento que tiene empleados asociados.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_servicio_insert_val_precio): El precio del servicio debe ser un valor positivo mayor a cero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_val_precio
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    IF NEW.precio <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_servicio_update_val_precio): El precio actualizado del servicio debe ser mayor a cero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_insert_val_desc_long
BEFORE INSERT ON Servicio FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.descripcion)) < 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_servicio_insert_val_desc_long): La descripción del servicio debe tener al menos 10 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_val_desc_long
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.descripcion)) < 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_servicio_update_val_desc_long): La nueva descripción modificada debe tener al menos 10 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_insert_precio_max
BEFORE INSERT ON Servicio FOR EACH ROW
BEGIN
    IF NEW.precio > 500000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_servicio_insert_precio_max): El precio de un servicio adicional no puede exceder los 500,000.00.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_precio_max
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    IF NEW.precio > 500000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_servicio_update_precio_max): El precio actualizado del servicio supera el límite permitido.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_servicio_insert_nombre_vacio): El nombre del servicio catálogo no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_servicio_update_nombre_vacio
BEFORE UPDATE ON Servicio FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre_servicio) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_servicio_update_nombre_vacio): No se puede modificar el nombre del servicio dejándolo vacío.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_insert_val_venc_pas): No se puede registrar un pasajero con el pasaporte vencido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_val_nacimiento
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF NEW.fecha_nacimiento > CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_insert_val_nacimiento): La fecha de nacimiento no puede ser futura.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_block_dni
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF OLD.dni_pasajero <> NEW.dni_pasajero THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_update_block_dni): No está permitido modificar el número de DNI de un pasajero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_block_pasaporte
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF OLD.nro_pasaporte <> NEW.nro_pasaporte THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_update_block_pasaporte): El número de pasaporte es inmutable y no se puede modificar.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_nombre_vacio
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre_pasajero) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_insert_nombre_vacio): El nombre del pasajero no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_apellido_vacio
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF TRIM(NEW.apellido_pasajero) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_insert_apellido_vacio): El apellido del pasajero es obligatorio.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_nombre_vacio
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF TRIM(NEW.nombre_pasajero) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_update_nombre_vacio): No se puede modificar el nombre del pasajero dejándolo en blanco.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_apellido_vacio
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF TRIM(NEW.apellido_pasajero) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_update_apellido_vacio): No se puede modificar el apellido del pasajero dejándolo en blanco.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_insert_val_tel_long
BEFORE INSERT ON Pasajero FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.telefono)) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_insert_val_tel_long): El teléfono del pasajero debe tener al menos 7 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pasajero_update_val_tel_long
BEFORE UPDATE ON Pasajero FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.telefono)) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pasajero_update_val_tel_long): El nuevo teléfono del pasajero no puede ser inferior a 7 caracteres.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_empleado_update_val_sueldo): El nuevo sueldo modificado debe ser mayor a cero.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_insert_val_dni_long
BEFORE INSERT ON Empleado FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.dni_empleado) <> 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_empleado_insert_val_dni_long): El DNI del empleado debe tener exactamente 8 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_update_val_dni_long
BEFORE UPDATE ON Empleado FOR EACH ROW
BEGIN
    IF OLD.dni_empleado <> NEW.dni_empleado AND CHAR_LENGTH(NEW.dni_empleado) <> 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_empleado_update_val_dni_long): El nuevo DNI corregido debe tener exactamente 8 caracteres.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error salarial (tg_empleado_insert_sueldo_min_terr): El sueldo para personal terrestre no puede ser inferior a 500.00.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error salarial (tg_empleado_update_sueldo_min_terr): El sueldo modificado para personal terrestre no puede ser menor a 500.00.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_insert_val_tel_long
BEFORE INSERT ON Empleado FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.telefono)) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_empleado_insert_val_tel_long): El teléfono del empleado debe tener al menos 7 caracteres.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_empleado_update_val_tel_long
BEFORE UPDATE ON Empleado FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(TRIM(NEW.telefono)) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_empleado_update_val_tel_long): El nuevo teléfono del empleado no puede ser inferior a 7 caracteres.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_empleado_insert_vacio): El nombre y apellido del empleado no pueden estar vacíos.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_asiento_insert_val_codigo): El código de asiento no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_insert_dispon_inicial
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    IF NEW.disponible = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_asiento_insert_dispon_inicial): Los asientos nuevos deben registrarse como disponibles.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_asiento_update_val_codigo): El código de asiento no puede modificarse quedando vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_insert_val_tipo
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    IF NEW.tipo NOT IN ('Ventana', 'Medio', 'Pasillo') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_asiento_insert_val_tipo): El tipo de asiento debe ser Ventana, Medio o Pasillo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_update_val_tipo
BEFORE UPDATE ON Asiento FOR EACH ROW
BEGIN
    IF NEW.tipo NOT IN ('Ventana', 'Medio', 'Pasillo') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_asiento_update_val_tipo): El tipo de asiento modificado no es válido.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_asiento_update_block_avion): No está permitido cambiar un asiento de avión.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_asiento_insert_val_long_id
BEFORE INSERT ON Asiento FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.IDAsiento) < 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_asiento_insert_val_long_id): El ID del asiento debe tener una longitud válida.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_vuelo_insert_val_destino): El aeropuerto de destino no puede ser igual al de origen.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_val_salida_futura
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_salida < CURRENT_TIMESTAMP() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_vuelo_insert_val_salida_futura): La fecha de salida del vuelo no puede ser en el pasado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_val_estado_ini
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.estado IN ('Completado', 'Volando', 'Cancelado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_vuelo_insert_val_estado_ini): Un nuevo vuelo no puede registrarse con ese estado inicial.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_update_val_fechas
BEFORE UPDATE ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_llegada <= NEW.fecha_hora_salida THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_vuelo_update_val_fechas): La nueva fecha de llegada debe ser posterior a la de salida.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_vuelo_insert_limite_un_anio): No se pueden programar vuelos con más de un año de anticipación.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_update_limite_un_anio
BEFORE UPDATE ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_salida > NOW() + INTERVAL 1 YEAR THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_vuelo_update_limite_un_anio): La reprogramación del vuelo no puede exceder el límite de un año futuro.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_update_val_salida_pasada
BEFORE UPDATE ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_salida < NOW() AND NEW.estado = 'Programado' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_vuelo_update_val_salida_pasada): La nueva reprogramación de salida del vuelo no puede ser en el pasado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_duracion_minima
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF NEW.fecha_hora_llegada <= NEW.fecha_hora_salida THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error operativo (tg_vuelo_insert_duracion_minima): La fecha de llegada debe ser posterior a la fecha de salida.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_vuelo_insert_duplicidad_avion
BEFORE INSERT ON Vuelo FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Vuelo WHERE avion_id = NEW.avion_id AND estado IN ('Programado', 'Volando')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_vuelo_insert_duplicidad_avion): El avión seleccionado ya se encuentra asignado a un vuelo activo.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_boleto_insert_val_precio_base): El precio base del boleto debe ser mayor a cero.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lógico (tg_boleto_insert_val_fecha_vuelo): La fecha de emisión del boleto no puede ser posterior al despegue del vuelo.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lógico (tg_boleto_update_val_fecha_vuelo): Al actualizar, la fecha del boleto no puede quedar posterior al vuelo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_boleto_update_val_aumento_abusivo
BEFORE UPDATE ON Boleto FOR EACH ROW
BEGIN
    IF NEW.precio_base > (OLD.precio_base * 3) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error comercial (tg_boleto_update_val_aumento_abusivo): El nuevo precio base no puede superar el triple del precio anterior.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_boleto_insert_val_sobreventa): El vuelo se encuentra totalmente completo. Capacidad máxima alcanzada.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pago_insert_val_costo_serv): El costo de los servicios adicionales no puede ser negativo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_insert_val_estado_ini
BEFORE INSERT ON Pago FOR EACH ROW
BEGIN
    IF NEW.estado IN ('Robado', 'Devuelto', 'Cancelado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pago_insert_val_estado_ini): El estado inicial del pago no es válido para un nuevo registro.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_update_proteger_pagado
BEFORE UPDATE ON Pago FOR EACH ROW
BEGIN
    IF OLD.estado = 'Pagado' AND NEW.estado = 'Pendiente' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pago_update_proteger_pagado): No se puede revertir un pago que ya ha sido completado.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_update_proteger_monto_liquidado
BEFORE UPDATE ON Pago FOR EACH ROW
BEGIN
    IF OLD.estado = 'Pagado' AND NEW.costo_total <> OLD.costo_total THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de auditoría (tg_pago_update_proteger_monto_liquidado): Está strictly prohibido alterar el costo total de un pago realizado.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pago_update_val_costo_serv): El costo de los servicios adicionales modificado no puede ser negativo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_insert_val_costo_total
BEFORE INSERT ON Pago FOR EACH ROW
BEGIN
    IF NEW.costo_total < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pago_insert_val_costo_total): El costo total del pago no puede ser un valor numérico negativo.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_pago_update_val_costo_total
BEFORE UPDATE ON Pago FOR EACH ROW
BEGIN
    IF NEW.costo_total < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_pago_update_val_costo_total): El costo total del pago modificado no puede ser negativo.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_checkin_insert_bloqueo_sin_pago): No se puede realizar Check-In si la factura no está en estado Pagado.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de seguridad (tg_checkin_insert_val_titular): El pasajero del Check-In no coincide con el dueño original del boleto.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_checkin_insert_val_vuelo_cancelado): No se puede realizar Check-In para un vuelo que se encuentra cancelado.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_checkin_insert_val_vuelo_comp): El vuelo ya finalizó. No se permiten nuevos registros de Check-In.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_checkin_insert_val_fecha_coherente): La fecha de Check-In no puede ser anterior a la de emisión del boleto.';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_checkin_insert_puerta_vacia): La puerta de embarque no puede estar vacía.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_update_puerta_vacia
BEFORE UPDATE ON CheckIn FOR EACH ROW
BEGIN
    IF TRIM(NEW.puerta_embarque) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_checkin_update_puerta_vacia): No se puede modificar Check-In dejando la puerta de embarque vacía.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_checkin_update_block_boleto
BEFORE UPDATE ON CheckIn FOR EACH ROW
BEGIN
    IF OLD.boleto_id <> NEW.boleto_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error (tg_checkin_update_block_boleto): El boleto asociado al Check-In es inmutable.';
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



-- ================================
-- VISTAS
-- ================================

CREATE VIEW v_info_pasajeros AS
SELECT 
    p.IDPasajero,
    p.nombre_pasajero,
    p.apellido_pasajero,
    p.dni_pasajero,
    p.telefono,
    p.nro_pasaporte,
    u.nombre_usuario,
    u.email
FROM Pasajero p
INNER JOIN Usuario u ON p.usuario_id = u.IDUsuario;


CREATE VIEW v_detalle_empleados AS
SELECT 
    e.IDEmpleado,
    e.nombre_empleado,
    e.apellido_empleado,
    e.sueldo,
    d.nombre AS departamento,
    d.tipo AS tipo_departamento,
    a.nombre AS aeropuerto_asignado,
    a.ciudad,
    a.pais
FROM Empleado e
INNER JOIN Departamento d ON e.departamento_id = d.IDDepartamento
INNER JOIN Aeropuerto a ON e.aeropuerto_id = a.IDAeropuerto;

CREATE VIEW v_detalle_vuelos AS
SELECT 
    v.IDVuelo,
    v.avion_id,
    v.fecha_hora_salida,
    v.fecha_hora_llegada,
    v.estado,
    a_origen.nombre AS aeropuerto_origen,
    a_origen.ciudad AS ciudad_origen,
    a_destino.nombre AS aeropuerto_destino,
    a_destino.ciudad AS ciudad_destino
FROM Vuelo v
INNER JOIN Aeropuerto a_origen ON v.origen_id = a_origen.IDAeropuerto
INNER JOIN Aeropuerto a_destino ON v.destino_id = a_destino.IDAeropuerto;


CREATE VIEW v_boletos_pasajeros AS
SELECT 
    b.IDBoleto,
    b.fecha AS fecha_compra,
    b.precio_base,
    p.nombre_pasajero,
    p.apellido_pasajero,
    p.dni_pasajero,
    b.vuelo_id,
    asnt.codigo AS codigo_asiento,
    asnt.tipo AS ubicacion_asiento
FROM Boleto b
INNER JOIN Pasajero p ON b.pasajero_id = p.IDPasajero
INNER JOIN Asiento asnt ON b.asiento_id = asnt.IDAsiento;


CREATE VIEW v_detalle_pagos AS
SELECT 
    pg.IDPago,
    pg.costo_servicios,
    pg.costo_total,
    pg.estado AS estado_pago,
    p.nombre_pasajero,
    p.apellido_pasajero,
    b.IDBoleto,
    b.precio_base
FROM Pago pg
INNER JOIN Pasajero p ON pg.pasajero_id = p.IDPasajero
INNER JOIN Boleto b ON pg.boleto_id = b.IDBoleto;


CREATE VIEW v_tarjetas_embarque AS
SELECT 
    c.IDCheckin,
    c.puerta_embarque,
    p.nombre_pasajero,
    p.apellido_pasajero,
    p.nro_pasaporte,
    b.IDBoleto,
    b.asiento_id,
    c.vuelo_id
FROM CheckIn c
INNER JOIN Pasajero p ON c.pasajero_id = p.IDPasajero
INNER JOIN Boleto b ON c.boleto_id = b.IDBoleto;


CREATE VIEW v_servicios_por_boleto AS
SELECT 
    bs.boleto_id,
    b.pasajero_id,
    s.IDServicio,
    s.nombre_servicio,
    s.precio AS precio_servicio
FROM Boleto_Servicio bs
INNER JOIN Boleto b ON bs.boleto_id = b.IDBoleto
INNER JOIN Servicio s ON bs.servicio_id = s.IDServicio;


CREATE VIEW v_manifiesto_vuelo AS
SELECT 
    v.IDVuelo,
    av.modelo AS modelo_avion,
    b.IDBoleto,
    p.nombre_pasajero,
    p.apellido_pasajero,
    p.dni_pasajero,
    a.codigo AS asiento_codigo
FROM Vuelo v
INNER JOIN Avion av ON v.avion_id = av.IDAvion
INNER JOIN Boleto b ON v.IDVuelo = b.vuelo_id
INNER JOIN Pasajero p ON b.pasajero_id = p.IDPasajero
INNER JOIN Asiento a ON b.asiento_id = a.IDAsiento;

CREATE VIEW v_estado_checkin_vuelos AS
SELECT 
    ch.IDCheckin,
    ch.puerta_embarque,
    v.IDVuelo,
    v.fecha_hora_salida,
    v.estado AS estado_vuelo,
    p.nombre_pasajero,
    p.apellido_pasajero,
    pg.estado AS estado_pago
FROM CheckIn ch
INNER JOIN Vuelo v ON ch.vuelo_id = v.IDVuelo
INNER JOIN Pasajero p ON ch.pasajero_id = p.IDPasajero
INNER JOIN Pago pg ON ch.pago_id = pg.IDPago;


CREATE VIEW v_ingresos_por_ruta AS
SELECT 
    pg.IDPago,
    pg.costo_total AS monto_pagado,
    a_origen.ciudad AS ciudad_origen,
    a_destino.ciudad AS ciudad_destino
FROM Pago pg
INNER JOIN Boleto b ON pg.boleto_id = b.IDBoleto
INNER JOIN Vuelo v ON b.vuelo_id = v.IDVuelo
INNER JOIN Aeropuerto a_origen ON v.origen_id = a_origen.IDAeropuerto
INNER JOIN Aeropuerto a_destino ON v.destino_id = a_destino.IDAeropuerto;
