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
-- PROCEDIMIENTOS DE Aeropuerto
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Aeropuerto(IN p_nombre VARCHAR(120), IN p_pais VARCHAR(30), IN p_ciudad VARCHAR(80))
BEGIN
    INSERT INTO Aeropuerto(nombre, pais, ciudad) VALUES(p_nombre, p_pais, p_ciudad);
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
CREATE PROCEDURE Crear_Avion(
    IN p_idavion VARCHAR(30),
    IN p_modelo VARCHAR(50),
    IN p_capacidad INT
)
BEGIN
    INSERT INTO Avion(IDAvion, modelo, capacidad) 
    VALUES(p_idavion, p_modelo, p_capacidad);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Avion(
    IN p_idavion VARCHAR(30),
    IN p_modelo VARCHAR(50),
    IN p_capacidad INT
)
BEGIN
    UPDATE Avion 
    SET modelo = COALESCE(p_modelo, modelo), 
        capacidad = COALESCE(p_capacidad, capacidad) 
    WHERE IDAvion = p_idavion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Avion()
BEGIN
    SELECT * FROM Avion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Avion(
    IN p_idavion VARCHAR(30)
)
BEGIN
    SELECT * FROM Avion WHERE IDAvion = p_idavion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Avion(
    IN p_idavion VARCHAR(30)
)
BEGIN
    DELETE FROM Avion WHERE IDAvion = p_idavion;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Avion_Por_Modelo(
    IN p_modelo VARCHAR(30)
)
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

-- =========================================
-- PROCEDIMIENTOS DE Asiento
-- =========================================
DELIMITER //
CREATE PROCEDURE Buscar_Asiento_Por_Id(
    IN p_idasiento VARCHAR(50)
)
BEGIN
    SELECT * FROM Asiento WHERE IDAsiento = p_idasiento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Asientos_Por_Avion(
    IN p_avion_id VARCHAR(30)
)
BEGIN
    SELECT * FROM Asiento WHERE avion_id = p_avion_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Disponibilidad_Asientos_Por_Avion(
    IN p_avion_id VARCHAR(30)
)
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
CREATE PROCEDURE Buscar_Asientos_Por_Disponibilidad(
    IN p_disponible BOOLEAN
)
BEGIN
    SELECT * FROM Asiento WHERE disponible = p_disponible;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Asiento(
    IN p_disponible BOOLEAN,
    IN p_idasiento VARCHAR(50)
)
BEGIN
    UPDATE Asiento SET disponible = p_disponible WHERE IDAsiento = p_idasiento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Ocupar_Asiento(
    IN p_idasiento VARCHAR(50)
)
BEGIN
    UPDATE Asiento SET disponible = 0 WHERE IDAsiento = p_idasiento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Liberar_Asiento(
    IN p_idasiento VARCHAR(50)
)
BEGIN
    UPDATE Asiento SET disponible = 1 WHERE IDAsiento = p_idasiento;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Departamento
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Departamento(
    IN p_nombre VARCHAR(100),
    IN p_tipo ENUM("Aéreo", "Terrestre")
)
BEGIN
    INSERT INTO Departamento(nombre, tipo) 
    VALUES(p_nombre, p_tipo);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Departamento(
    IN p_iddepartamento INT,
    IN p_nombre VARCHAR(100),
    IN p_tipo ENUM("Aéreo", "Terrestre")
)
BEGIN
    UPDATE Departamento 
    SET nombre = COALESCE(p_nombre, nombre), 
        tipo = COALESCE(p_tipo, tipo) 
    WHERE IDDepartamento = p_iddepartamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Departamento()
BEGIN
    SELECT * FROM Departamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Departamento(
    IN p_iddepartamento INT
)
BEGIN
    SELECT * FROM Departamento WHERE IDDepartamento = p_iddepartamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Departamento(
    IN p_iddepartamento INT
)
BEGIN
    DELETE FROM Departamento WHERE IDDepartamento = p_iddepartamento;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Departamento_Por_Nombre(
    IN p_nombre VARCHAR(100)
)
BEGIN
    SELECT * FROM Departamento WHERE nombre = p_nombre;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Departamento_Por_Tipo(
    IN p_tipo ENUM("Aéreo", "Terrestre")
)
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

-- =========================================
-- PROCEDIMIENTOS DE Servicio
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Servicio(
    IN p_nombre_servicio VARCHAR(20),
    IN p_precio DECIMAL(10, 2),
    IN p_descripcion VARCHAR(120)
)
BEGIN
    INSERT INTO Servicio(nombre_servicio, precio, descripcion) 
    VALUES(p_nombre_servicio, p_precio, p_descripcion);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Servicio(
    IN p_idservicio INT,
    IN p_nombre_servicio VARCHAR(20),
    IN p_precio DECIMAL(10, 2),
    IN p_descripcion VARCHAR(120)
)
BEGIN
    UPDATE Servicio 
    SET nombre_servicio = COALESCE(p_nombre_servicio, nombre_servicio), 
        precio = COALESCE(p_precio, precio), 
        descripcion = COALESCE(p_descripcion, p_descripcion) 
    WHERE IDServicio = p_idservicio;
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
    IN p_idservicio INT
)
BEGIN
    SELECT * FROM Servicio WHERE IDServicio = p_idservicio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Servicio(
    IN p_idservicio INT
)
BEGIN
    DELETE FROM Servicio WHERE IDServicio = p_idservicio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Nombre(
    IN p_nombre_servicio VARCHAR(20)
)
BEGIN
    SELECT * FROM Servicio WHERE nombre_servicio = p_nombre_servicio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Precio(
    IN p_precio DECIMAL(10, 2)
)
BEGIN
    SELECT * FROM Servicio WHERE precio = p_precio;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Servicio_Por_Descripcion(
    IN p_descripcion VARCHAR(120)
)
BEGIN
    SELECT * FROM Servicio WHERE descripcion = p_descripcion;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Usuario
-- =========================================
DELIMITER //
CREATE PROCEDURE Crear_Usuario(
    IN p_nombre_usuario VARCHAR(30),
    IN p_email VARCHAR(40),
    IN p_contraseña_usuario VARCHAR(30),
    IN p_privilegios_empleado BOOLEAN,
    IN p_pregunta_seguridad VARCHAR(100),
    IN p_respuesta_seguridad VARCHAR(100)
)
BEGIN
    INSERT INTO Usuario(nombre_usuario, email, contraseña_usuario, privilegios_empleado, pregunta_seguridad, respuesta_seguridad) 
    VALUES(p_nombre_usuario, p_email, p_contraseña_usuario, p_privilegios_empleado, p_pregunta_seguridad, p_respuesta_seguridad);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Usuario(
    IN p_idusuario INT,
    IN p_nombre_usuario VARCHAR(30),
    IN p_email VARCHAR(40),
    IN p_contraseña_usuario VARCHAR(30),
    IN p_privilegios_empleado BOOLEAN,
    IN p_pregunta_seguridad VARCHAR(100),
    IN p_respuesta_seguridad VARCHAR(100)
)
BEGIN
    UPDATE Usuario 
    SET nombre_usuario = COALESCE(p_nombre_usuario, nombre_usuario), 
        email = COALESCE(p_email, email), 
        contraseña_usuario = COALESCE(p_contraseña_usuario, contraseña_usuario), 
        privilegios_empleado = COALESCE(p_privilegios_empleado, privilegios_empleado), 
        pregunta_seguridad = COALESCE(p_pregunta_seguridad, pregunta_seguridad), 
        respuesta_seguridad = COALESCE(p_respuesta_seguridad, respuesta_seguridad) 
    WHERE IDUsuario = p_idusuario;
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
    IN p_idusuario INT
)
BEGIN
    SELECT * FROM Usuario WHERE IDUsuario = p_idusuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Usuario(
    IN p_idusuario INT
)
BEGIN
    DELETE FROM Usuario WHERE IDUsuario = p_idusuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Usuario_Por_Nombre(
    IN p_nombre_usuario VARCHAR(30)
)
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
CREATE PROCEDURE Validar_Usuario_Unico(
    IN p_nombre_usuario VARCHAR(30)
)
BEGIN
    SELECT COUNT(*) FROM Usuario WHERE nombre_usuario = p_nombre_usuario;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Validar_Email_Unico(
    IN p_email VARCHAR(40)
)
BEGIN
    SELECT COUNT(*) FROM Usuario WHERE email = p_email;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Validar_Usuario_Editar(
    IN p_nombre_usuario VARCHAR(30),
    IN p_id INT
)
BEGIN
    SELECT COUNT(*) FROM Usuario WHERE nombre_usuario = p_nombre_usuario AND IDUsuario != p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Validar_Email_Editar(
    IN p_email VARCHAR(40),
    IN p_id INT
)
BEGIN
    SELECT COUNT(*) FROM Usuario WHERE email = p_email AND IDUsuario != p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Contraseña_Usuario(
    IN p_contraseña_usuario VARCHAR(30),
    IN p_id INT
)
BEGIN
    UPDATE Usuario SET contraseña_usuario = p_contraseña_usuario WHERE IDUsuario = p_id;
END//
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Pago
-- =========================================
DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Boleto_Id(
    IN p_boleto_id INT
)
BEGIN
    SELECT * FROM Pago WHERE boleto_id = p_boleto_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Estado(
    IN p_estado VARCHAR(20)
)
BEGIN
    SELECT * FROM Pago WHERE estado = p_estado;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Agregar_Pago(
    IN p_pasajero_id INT,
    IN p_boleto_id INT,
    IN p_costo_servicios DECIMAL(10, 2),
    IN p_costo_total DECIMAL(10, 2),
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO Pago (pasajero_id, boleto_id, costo_servicios, costo_total, estado) 
    VALUES (p_pasajero_id, p_boleto_id, p_costo_servicios, p_costo_total, p_estado);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Pagos()
BEGIN
    SELECT * FROM Pago;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pago_Por_Id(
    IN p_id INT
)
BEGIN
    SELECT * FROM Pago WHERE IDPago = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Pago(
    IN p_pasajero_id INT,
    IN p_boleto_id INT,
    IN p_costo_servicios DECIMAL(10, 2),
    IN p_costo_total DECIMAL(10, 2),
    IN p_estado VARCHAR(20),
    IN p_id INT
)
BEGIN
    UPDATE Pago 
    SET pasajero_id = p_pasajero_id, 
        boleto_id = p_boleto_id, 
        costo_servicios = p_costo_servicios, 
        costo_total = p_costo_total, 
        estado = p_estado 
    WHERE IDPago = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Pago(
    IN p_id INT
)
BEGIN
    DELETE FROM Pago WHERE IDPago = p_id;
END //
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Vuelo
-- =========================================
DELIMITER //
CREATE PROCEDURE Buscar_Vuelo_Por_Id(
    IN p_idvuelo INT
)
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
CREATE PROCEDURE Agregar_Vuelo(
    IN p_avion_id VARCHAR(30),
    IN p_origen_id INT,
    IN p_destino_id INT,
    IN p_fecha_hora_salida DATETIME,
    IN p_fecha_hora_llegada DATETIME,
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO Vuelo (avion_id, origen_id, destino_id, fecha_hora_salida, fecha_hora_llegada, estado) 
    VALUES (p_avion_id, p_origen_id, p_destino_id, p_fecha_hora_salida, p_fecha_hora_llegada, p_estado);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Todos_Los_Vuelos()
BEGIN
    SELECT * FROM Vuelo;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Vuelo(
    IN p_avion_id VARCHAR(30),
    IN p_origen_id INT,
    IN p_destino_id INT,
    IN p_fecha_hora_salida DATETIME,
    IN p_fecha_hora_llegada DATETIME,
    IN p_estado VARCHAR(20),
    IN p_id INT
)
BEGIN
    UPDATE Vuelo 
    SET avion_id = p_avion_id, 
        origen_id = p_origen_id, 
        destino_id = p_destino_id, 
        fecha_hora_salida = p_fecha_hora_salida, 
        fecha_hora_llegada = p_fecha_hora_llegada, 
        estado = p_estado 
    WHERE IDVuelo = p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Vuelo(
    IN p_id INT
)
BEGIN
    DELETE FROM Vuelo WHERE IDVuelo = p_id;
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
CREATE PROCEDURE Agregar_Pasajero(
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_dni VARCHAR(15),
    IN p_telefono VARCHAR(20),
    IN p_fecha_nacimiento DATE,
    IN p_nro_pasaporte VARCHAR(20),
    IN p_pais_emision CHAR(3),
    IN p_vencimiento_pasaporte DATE,
    IN p_usuario_id INT
)
BEGIN
    INSERT INTO Pasajero (nombre_pasajero, apellido_pasajero, dni_pasajero, telefono, fecha_nacimiento, nro_pasaporte, pais_emision, vencimiento_pasaporte, usuario_id) 
    VALUES (p_nombre, p_apellido, p_dni, p_telefono, p_fecha_nacimiento, p_nro_pasaporte, p_pais_emision, p_vencimiento_pasaporte, p_usuario_id);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Pasajeros()
BEGIN
    SELECT * FROM Pasajero;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Pasajero_Por_Id(
    IN p_id INT
)
BEGIN
    SELECT * FROM Pasajero WHERE IDPasajero = p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Pasajero(
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_dni VARCHAR(15),
    IN p_telefono VARCHAR(20),
    IN p_fecha_nacimiento DATE,
    IN p_nro_pasaporte VARCHAR(20),
    IN p_pais_emision CHAR(3),
    IN p_vencimiento_pasaporte DATE,
    IN p_usuario_id INT,
    IN p_id INT
)
BEGIN
    UPDATE Pasajero 
    SET nombre_pasajero = p_nombre, 
        apellido_pasajero = p_apellido, 
        dni_pasajero = p_dni, 
        telefono = p_telefono, 
        fecha_nacimiento = p_fecha_nacimiento, 
        nro_pasaporte = p_nro_pasaporte, 
        pais_emision = p_pais_emision, 
        vencimiento_pasaporte = p_vencimiento_pasaporte, 
        usuario_id = p_usuario_id 
    WHERE IDPasajero = p_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Pasajero(
    IN p_id INT
)
BEGIN
    DELETE FROM Pasajero WHERE IDPasajero = p_id;
END//
DELIMITER ;


-- =========================================
-- PROCEDIMIENTOS DE Boleto
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

DELIMITER //
CREATE PROCEDURE Agregar_Boleto(
    IN p_pasajero_id INT,
    IN p_vuelo_id INT,
    IN p_asiento_id VARCHAR(50),
    IN p_fecha DATETIME,
    IN p_precio_base DECIMAL(10, 2),
    OUT p_id_generado INT
)
BEGIN
    INSERT INTO Boleto (pasajero_id, vuelo_id, asiento_id, fecha, precio_base) 
    VALUES (p_pasajero_id, p_vuelo_id, p_asiento_id, p_fecha, p_precio_base);
    
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
CREATE PROCEDURE Buscar_Boleto_Por_Id(
    IN p_id INT
)
BEGIN
    SELECT * FROM Boleto WHERE IDBoleto = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Boleto(
    IN p_id INT,
    IN p_pasajero_id INT,
    IN p_vuelo_id INT,
    IN p_asiento_id VARCHAR(50),
    IN p_fecha DATETIME,
    IN p_precio_base DECIMAL(10, 2)
)
BEGIN
    UPDATE Boleto 
    SET pasajero_id = p_pasajero_id, 
        vuelo_id = p_vuelo_id, 
        asiento_id = p_asiento_id, 
        fecha = p_fecha, 
        precio_base = p_precio_base 
    WHERE IDBoleto = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Boleto(
    IN p_id INT
)
BEGIN
    DELETE FROM Boleto WHERE IDBoleto = p_id;
END //
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Boleto_Servicio
-- =========================================
DELIMITER //
CREATE PROCEDURE Buscar_Servicios_Por_Boleto(
    IN p_boleto_id INT
)
BEGIN
    SELECT s.IDServicio, s.nombre_servicio, s.precio, s.descripcion 
    FROM Servicio s 
    INNER JOIN Boleto_Servicio bs ON s.IDServicio = bs.servicio_id 
    WHERE bs.boleto_id = p_boleto_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Insertar_Boleto_Servicio(
    IN p_boleto_id INT,
    IN p_servicio_id INT
)
BEGIN
    INSERT INTO Boleto_Servicio (boleto_id, servicio_id) VALUES (p_boleto_id, p_servicio_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Servicios_De_Boleto(
    IN p_boleto_id INT
)
BEGIN
    DELETE FROM Boleto_Servicio WHERE boleto_id = p_boleto_id;
END //
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE CheckIn
-- =========================================
DELIMITER //
CREATE PROCEDURE Agregar_CheckIn(
    IN p_pasajero_id INT,
    IN p_boleto_id INT,
    IN p_vuelo_id INT,
    IN p_pago_id INT,
    IN p_puerta_embarque CHAR(3)
)
BEGIN
    INSERT INTO CheckIn (pasajero_id, boleto_id, vuelo_id, pago_id, puerta_embarque) 
    VALUES (p_pasajero_id, p_boleto_id, p_vuelo_id, p_pago_id, p_puerta_embarque);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_CheckIns()
BEGIN
    SELECT * FROM CheckIn;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_CheckIn_Por_Id(
    IN p_id INT
)
BEGIN
    SELECT * FROM CheckIn WHERE IDCheckin = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_CheckIn(
    IN p_id INT,
    IN p_pasajero_id INT,
    IN p_boleto_id INT,
    IN p_vuelo_id INT,
    IN p_pago_id INT,
    IN p_puerta_embarque CHAR(3)
)
BEGIN
    UPDATE CheckIn 
    SET pasajero_id = p_pasajero_id, 
        boleto_id = p_boleto_id, 
        vuelo_id = p_vuelo_id, 
        pago_id = p_pago_id, 
        puerta_embarque = p_puerta_embarque 
    WHERE IDCheckin = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_CheckIn(
    IN p_id INT
)
BEGIN
    DELETE FROM CheckIn WHERE IDCheckin = p_id;
END //
DELIMITER ;

-- =========================================
-- PROCEDIMIENTOS DE Empleado
-- =========================================
DELIMITER //
CREATE PROCEDURE Agregar_Empleado(
    IN p_nombre VARCHAR(30),
    IN p_apellido VARCHAR(30),
    IN p_dni CHAR(8),
    IN p_telefono VARCHAR(20),
    IN p_sueldo DECIMAL(10, 2),
    IN p_departamento_id INT,
    IN p_aeropuerto_id INT,
    IN p_usuario_id INT
)
BEGIN
    INSERT INTO Empleado (nombre_empleado, apellido_empleado, dni_empleado, telefono, sueldo, departamento_id, aeropuerto_id, usuario_id) 
    VALUES (p_nombre, p_apellido, p_dni, p_telefono, p_sueldo, p_departamento_id, p_aeropuerto_id, p_usuario_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Mostrar_Empleados()
BEGIN
    SELECT * FROM Empleado;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Buscar_Empleado_Por_Id(
    IN p_id INT
)
BEGIN
    SELECT * FROM Empleado WHERE IDEmpleado = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Editar_Empleado(
    IN p_id INT,
    IN p_nombre VARCHAR(30),
    IN p_apellido VARCHAR(30),
    IN p_dni CHAR(8),
    IN p_telefono VARCHAR(20),
    IN p_sueldo DECIMAL(10, 2),
    IN p_departamento_id INT,
    IN p_aeropuerto_id INT,
    IN p_usuario_id INT
)
BEGIN
    UPDATE Empleado 
    SET nombre_empleado = p_nombre, 
        apellido_empleado = p_apellido, 
        dni_empleado = p_dni, 
        telefono = p_telefono, 
        sueldo = p_sueldo, 
        departamento_id = p_departamento_id, 
        aeropuerto_id = p_aeropuerto_id, 
        usuario_id = p_usuario_id 
    WHERE IDEmpleado = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Eliminar_Empleado(
    IN p_id INT
)
BEGIN
    DELETE FROM Empleado WHERE IDEmpleado = p_id;
END //
DELIMITER ;
