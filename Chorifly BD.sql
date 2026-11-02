DROP DATABASE IF exists Chorifly;
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
    usuario_id INT NULL UNIQUE, -- Cambio a NULL
    FOREIGN KEY (usuario_id) REFERENCES Usuario (IDUsuario) ON DELETE SET NULL
);

CREATE TABLE Empleado (
    IDEmpleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empleado VARCHAR(30) NOT NULL,
    apellido_empleado VARCHAR(30) NOT NULL,
    dni_empleado CHAR(8) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    sueldo DECIMAL(10, 2) NOT NULL,
    departamento_id INT NULL, -- Cambio a NULL
    aeropuerto_id INT NULL,     -- Cambio a NULL
    usuario_id INT NULL UNIQUE, -- Cambio a NULL
    FOREIGN KEY (departamento_id) REFERENCES Departamento (IDDepartamento) ON DELETE SET NULL,
    FOREIGN KEY (aeropuerto_id) REFERENCES Aeropuerto (IDAeropuerto) ON DELETE SET NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario (IDUsuario) ON DELETE SET NULL
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
    pasajero_id INT NULL, -- Cambio a NULL
    vuelo_id INT NOT NULL,
    asiento_id VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL,
    precio_base DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pasajero_id) REFERENCES Pasajero (IDPasajero) ON DELETE SET NULL,
    FOREIGN KEY (vuelo_id) REFERENCES Vuelo (IDVuelo),
    FOREIGN KEY (asiento_id) REFERENCES Asiento (IDAsiento)
);

CREATE TABLE Boleto_Servicio (
    boleto_id INT NOT NULL,
    servicio_id INT NOT NULL,
    PRIMARY KEY (boleto_id, servicio_id),
    FOREIGN KEY (boleto_id) REFERENCES Boleto (IDBoleto) ON DELETE CASCADE,
    FOREIGN KEY (servicio_id) REFERENCES Servicio (IDServicio) ON DELETE CASCADE
);

CREATE TABLE Pago (
    IDPago INT AUTO_INCREMENT PRIMARY KEY,
    pasajero_id INT NULL,
    boleto_id INT NOT NULL UNIQUE,
    costo_servicios DECIMAL(10, 2) NOT NULL,
    costo_total DECIMAL(10, 2) NOT NULL,
    estado ENUM("Pagado", "Pendiente", "Cancelado", "Robado", "Fiado", "Reducido", "Detenido", "Devuelto") NOT NULL,
    FOREIGN KEY (pasajero_id) REFERENCES Pasajero (IDPasajero) ON DELETE SET NULL,
    FOREIGN KEY (boleto_id) REFERENCES Boleto (IDBoleto)
);

CREATE TABLE CheckIn (
    IDCheckin INT AUTO_INCREMENT PRIMARY KEY,
    pasajero_id INT NULL, -- Cambio a NULL
    boleto_id INT NOT NULL UNIQUE,
    vuelo_id INT NOT NULL,
    pago_id INT NOT NULL UNIQUE,
    puerta_embarque CHAR(3) NOT NULL,
    FOREIGN KEY (pasajero_id) REFERENCES Pasajero (IDPasajero) ON DELETE SET NULL,
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
('Menú Premium', 20000.00, 'Ofrece un menú con comidas y bebidas para consumir durante el viaje.'),
('Selección de Asiento', 15000, 'Permite elegir tu asiento y que no te sea seleccionado de forma aleatoria');

INSERT INTO Usuario (nombre_usuario, email, contraseña_usuario, privilegios_empleado, pregunta_seguridad, respuesta_seguridad) VALUES 
('Chorifly_Admin', 'admin@chorifly.com', 'Choriflyadmin1@!', True, 'Nombre de primera empresa laboral', 'Chorifly SRL'),
('la_cobra', 'lacobra@gmail.com', 'Cobra123!', True, 'Ciudad de nacimiento', 'Buenos Aires'),
('davo_xeneize', 'davoxeneize@gmail.com', 'Davo123!', True, 'Comida favorita', 'Milanesa'),
('goncho_batan', 'gonchobatan@gmail.com', 'Goncho123!', True, 'Nombre de mascota actual', 'Roco'),
('momo_gero', 'momogero@gmail.com', 'Momo123!', True, 'Ciudad de nacimiento', 'La Plata'),
('brunenger_ok', 'brunengerok@gmail.com', 'Brunenger123!', True, 'Comida favorita', 'Asado');

INSERT INTO Empleado (nombre_empleado, apellido_empleado, dni_empleado, telefono, sueldo, departamento_id, aeropuerto_id, usuario_id) VALUES
('CEOJuanMer', 'Jefe', '49112572', '1165929456', 670000.67, 1, 1, 1),
('Lautaro', 'del Campo', '40555444', '1123456789', 3500.00, 2, 5, 2),
('David', 'Quintanilla', '40222333', '1134567890', 4000.00, 1, 5, 3),
('Gonzalo', 'Banzas', '38444555', '1145678901', 1800.00, 2, 1, 4),
('Gerónimo', 'Benavides', '37555666', '1156789012', 1500.00, 1, 3, 5),
('Bruno', 'Kr Kr Kr', '41666777', '1167890123', 1500.00, 3, 3, 6);

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

-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Aeropuerto
-- =========================================
DELIMITER //

CREATE PROCEDURE Crear_Aeropuerto(
    IN nombre_aeropuerto_i VARCHAR(120),
    IN pais_aeropuerto_i VARCHAR(30),
    IN ciudad_aeropuerto_i VARCHAR(80)
)
BEGIN
    INSERT INTO Aeropuerto(nombre, pais, ciudad) 
    VALUES(nombre_aeropuerto_i, pais_aeropuerto_i, ciudad_aeropuerto_i);
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Editar_Aeropuerto(
    IN idaeropuerto_aeropuerto_i INT,
    IN nombre_aeropuerto_i VARCHAR(120),
    IN pais_aeropuerto_i VARCHAR(30),
    IN ciudad_aeropuerto_i VARCHAR(80)
)
BEGIN
    UPDATE Aeropuerto
    SET
        nombre = COALESCE(nombre_aeropuerto_i, nombre),
        pais = COALESCE(pais_aeropuerto_i, pais),
        ciudad = COALESCE(ciudad_aeropuerto_i, ciudad)
    WHERE IDAeropuerto = idaeropuerto_aeropuerto_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_Aeropuertos()
BEGIN
    SELECT * FROM Aeropuerto;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Aeropuerto(
    IN idaeropuerto_aeropuerto_i INT
)
BEGIN
    SELECT * FROM Aeropuerto
    WHERE IDAeropuerto = idaeropuerto_aeropuerto_i;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Eliminar_Aeropuerto(
	IN idaeropuerto_aeropuerto_i INT
)
BEGIN
	DELETE FROM Aeropuerto
    WHERE IDAeropuerto = idaeropuerto_aeropuerto_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Aeropuerto_Por_Pais(
	IN pais_aeropuerto_i VARCHAR(30) 
)
BEGIN
    SELECT * FROM Aeropuerto
    WHERE pais = pais_aeropuerto_i;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Aeropuerto_Por_Nombre(
	IN nombre_aeropuerto_i VARCHAR(120) 
)
BEGIN
    SELECT * FROM Aeropuerto
    WHERE nombre = nombre_aeropuerto_i;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Aeropuerto_Por_Ciudad(
	IN ciudad_aeropuerto_i VARCHAR(80) 
)
BEGIN
    SELECT * FROM Aeropuerto
    WHERE ciudad = ciudad_aeropuerto_i;
END //

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
-- ANOTACION: PROCEDIMIENTOS DE Avion
-- =========================================
DELIMITER //

CREATE PROCEDURE Crear_Avion(
    IN idavion_aereo_i VARCHAR(30),
    IN modelo_aereo_i VARCHAR(50),
    IN capacidad_aereo_i INT
)
BEGIN
    INSERT INTO Avion(IDAvion, modelo, capacidad) 
    VALUES(idavion_aereo_i, modelo_aereo_i, capacidad_aereo_i);
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Editar_Avion(
    IN idavion_aereo_i VARCHAR(30),
    IN modelo_aereo_i VARCHAR(50),
    IN capacidad_aereo_i INT
)
BEGIN
    UPDATE Avion
    SET
        modelo = COALESCE(modelo_aereo_i, modelo),
        capacidad = COALESCE(capacidad_aereo_i, capacidad)
    WHERE IDAvion = idavion_aereo_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_Avion()
BEGIN
    SELECT * FROM Avion;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Avion(
    IN idavion_aereo_i VARCHAR(30)
)
BEGIN
    SELECT * FROM Avion
    WHERE IDAvion = idavion_aereo_i;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Eliminar_Avion(
	IN idavion_aereo_i VARCHAR(30)
)
BEGIN
	DELETE FROM Avion
    WHERE IDAvion = idavion_aereo_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Avion_Por_Modelo(
    IN modelo_aereo_i VARCHAR(30)
)
BEGIN
    SELECT * FROM Avion
    WHERE modelo = modelo_aereo_i;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_ID_Aviones()
BEGIN
    SELECT IDAvion FROM Avion;
END//

DELIMITER ;


-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Asiento
-- =========================================
DELIMITER //

CREATE PROCEDURE Buscar_Asiento_Por_Id(
    IN id_asiento_i VARCHAR(50)
)
BEGIN
    SELECT * FROM Asiento
    WHERE IDAsiento = id_asiento_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Asientos_Por_Avion(
    IN id_avion_i VARCHAR(30)
)
BEGIN
    SELECT * FROM Asiento
    WHERE avion_id = id_avion_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_Disponibilidad_Asientos_Por_Avion(
    IN id_avion_i VARCHAR(30)
)
BEGIN
    SELECT disponible FROM Asiento WHERE avion_id = id_avion_i;
END//

DELIMITER ;


-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Departamento
-- =========================================
DELIMITER //

CREATE PROCEDURE Crear_Departamento(
    IN nombre_departamento_i VARCHAR(100),
    IN tipo_departamento_i ENUM("Aéreo", "Terrestre")
)
BEGIN
    INSERT INTO Departamento(nombre, tipo) 
    VALUES(nombre_departamento_i, tipo_departamento_i);
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Editar_Departamento(
    IN iddepartamento_departamento_i INT,
    IN nombre_departamento_i VARCHAR(100),
    IN tipo_departamento_i ENUM("Aéreo", "Terrestre")
)
BEGIN
    UPDATE Departamento
    SET
        nombre = COALESCE(nombre_departamento_i, nombre),
        tipo = COALESCE(tipo_departamento_i, tipo)
    WHERE IDDepartamento = iddepartamento_departamento_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_Departamento()
BEGIN
    SELECT * FROM Departamento;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Departamento(
    IN iddepartamento_departamento_i INT
)
BEGIN
    SELECT * FROM Departamento
    WHERE IDDepartamento = iddepartamento_departamento_i;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Eliminar_Departamento(
	IN iddepartamento_departamento_i INT
)
BEGIN
	DELETE FROM Departamento
    WHERE IDDepartamento = iddepartamento_departamento_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Departamento_Por_Nombre(
    IN nombre_departamento_i VARCHAR(100)
)
BEGIN
    SELECT * FROM Departamento
    WHERE nombre = nombre_departamento_i;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Departamento_Por_Tipo(
    IN tipo_departamento_i ENUM("Aéreo", "Terrestre")
)
BEGIN
    SELECT * FROM Departamento
    WHERE tipo = tipo_departamento_i;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_Extras_Departamentos()
BEGIN
    SELECT IDDepartamento, nombre FROM Departamento;
END//

DELIMITER ;


-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Servicio
-- =========================================
DELIMITER //

CREATE PROCEDURE Crear_Servicio(
    IN nombre_servicio_i VARCHAR(20),
    IN precio_servicio_i DECIMAL(10, 2),
    IN descripcion_servicio_i VARCHAR(120)
)
BEGIN
    INSERT INTO Servicio(nombre_servicio, precio, descripcion) 
    VALUES(nombre_servicio_i, precio_servicio_i, descripcion_servicio_i);
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Editar_Servicio(
	IN idservicio_servicio_i INT,
    IN nombre_servicio_in_i VARCHAR(20),
    IN precio_servicio_i DECIMAL(10, 2),
    IN descripcion_servicio_i VARCHAR(120)
)
BEGIN
    UPDATE Servicio
    SET
        nombre_servicio = COALESCE(nombre_servicio_in_i, nombre_servicio),
        precio = COALESCE(precio_servicio_i, precio),
        descripcion = COALESCE(descripcion_servicio_i, descripcion)
    WHERE IDServicio = idservicio_servicio_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_Servicio()
BEGIN
	SELECT * FROM Servicio;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Servicio(
	IN idservicio_servicio_i INT
)
BEGIN
	SELECT * FROM Servicio
    WHERE IDServicio = idservicio_servicio_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Eliminar_Servicio(
	IN idservicio_servicio_i INT
)
BEGIN
	DELETE FROM Servicio
    WHERE IDServicio = idservicio_servicio_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Servicio_Por_Nombre(
	IN nombre_servicio_buscar_i VARCHAR(20)
)
BEGIN
	SELECT * FROM Servicio
    WHERE nombre_servicio = nombre_servicio_buscar_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Servicio_Por_Precio(
	IN precio_servicio_i DECIMAL(10, 2)
)
BEGIN
	SELECT * FROM Servicio
    WHERE precio = precio_servicio_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Servicio_Por_Descripcion(
    IN descripcion_servicio_i VARCHAR(120)
)
BEGIN
	SELECT * FROM Servicio
    WHERE descripcion = descripcion_servicio_i;
END//

DELIMITER ;

-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Usuario
-- =========================================
DELIMITER //

CREATE PROCEDURE Crear_Usuario(
    IN nombre_usuario_i VARCHAR(30),
    IN email_usuario_i VARCHAR(40),
    IN contraseña_usuario_i VARCHAR(30),
    IN privilegios_usuario_i BOOLEAN,
    IN pregunta_usuario_i VARCHAR(100),
    IN respuesta_usuario_i VARCHAR(100)
)
BEGIN
    INSERT INTO Usuario(nombre_usuario, email, contraseña_usuario, privilegios_empleado, pregunta_seguridad, respuesta_seguridad) 
    VALUES(nombre_usuario_i, email_usuario_i, contraseña_usuario_i, privilegios_usuario_i, pregunta_usuario_i, respuesta_usuario_i);
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Editar_Usuario(
	IN idusuario_usuario_i INT,
    IN nombre_usuario_in_i VARCHAR(30),
    IN email_usuario_i VARCHAR(40),
    IN contraseña_usuario_in_i VARCHAR(30),
    IN privilegios_usuario_i BOOLEAN,
    IN pregunta_usuario_i VARCHAR(100),
    IN respuesta_usuario_i VARCHAR(100)
)
BEGIN
    UPDATE Usuario
    SET
		nombre_usuario = COALESCE(nombre_usuario_in_i, nombre_usuario),
		email = COALESCE(email_usuario_i, email),
		contraseña_usuario = COALESCE(contraseña_usuario_in_i, contraseña_usuario),
		privilegios_empleado = COALESCE(privilegios_usuario_i, privilegios_empleado),
		pregunta_seguridad = COALESCE(pregunta_usuario_i, pregunta_seguridad),
		respuesta_seguridad = COALESCE(respuesta_usuario_i, respuesta_seguridad)
    WHERE IDUsuario = idusuario_usuario_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_Usuario()
BEGIN
	SELECT * FROM Usuario;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Usuario(
    IN idusuario_usuario_i INT
)
BEGIN
	SELECT * FROM Usuario
    WHERE IDUsuario = idusuario_usuario_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Eliminar_Usuario(
	IN idusuario_usuario_i INT
)
BEGIN
	DELETE FROM Usuario
    WHERE IDUsuario = idusuario_usuario_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Usuario_Por_Nombre(
    IN nombre_usuario_in_i VARCHAR(30)
)
BEGIN
	SELECT * FROM Usuario
    WHERE nombre_usuario = nombre_usuario_in_i;
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


-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Pago
-- =========================================
DELIMITER //

CREATE PROCEDURE Buscar_Pago_Por_Boleto_Id(
    IN id_boleto_busqueda_i INT
)
BEGIN
    SELECT * FROM Pago
    WHERE boleto_id = id_boleto_busqueda_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Buscar_Pago_Por_Estado(
    IN estado_i VARCHAR(20)
)
BEGIN
    SELECT * FROM Pago
    WHERE estado = estado_i;
END//

DELIMITER ;

-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Vuelo
-- =========================================
DELIMITER //

CREATE PROCEDURE Buscar_Vuelo_Por_Id(
    IN id_vuelo_i INT
)
BEGIN
    SELECT * FROM Vuelo
    WHERE IDVuelo = id_vuelo_i;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Mostrar_Vuelos_Programados()
BEGIN
    SELECT IDVuelo, avion_id, origen_id, destino_id FROM Vuelo WHERE estado = 'Programado';
END//

DELIMITER ;

-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Pasajero
-- =========================================
DELIMITER //

CREATE PROCEDURE Mostrar_Extras_Pasajeros()
BEGIN
    SELECT IDPasajero, nombre_pasajero, apellido_pasajero FROM Pasajero;
END//

DELIMITER ;

-- =========================================
-- ANOTACION: PROCEDIMIENTOS DE Boleto
-- =========================================
DELIMITER //

CREATE PROCEDURE Mostrar_Boletos_Para_Checkin()
BEGIN
    SELECT b.IDBoleto FROM Boleto b
    INNER JOIN Pago pa ON b.IDBoleto = pa.boleto_id
    LEFT JOIN CheckIn c ON b.IDBoleto = c.boleto_id
    WHERE pa.estado = 'Pagado' AND c.IDCheckin IS NULL;
END//

DELIMITER ;
