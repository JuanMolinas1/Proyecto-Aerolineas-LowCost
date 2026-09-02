-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-09-2026 a las 13:16:57
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `chorifly`
--
DROP DATABASE IF EXISTS `chorifly`;
CREATE DATABASE IF NOT EXISTS `chorifly` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `chorifly`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aeropuerto`
--

DROP TABLE IF EXISTS `aeropuerto`;
CREATE TABLE `aeropuerto` (
  `IDAeropuerto` int(11) NOT NULL,
  `nombre` varchar(120) DEFAULT NULL,
  `pais` varchar(30) DEFAULT NULL,
  `ciudad` varchar(80) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asiento`
--

DROP TABLE IF EXISTS `asiento`;
CREATE TABLE `asiento` (
  `IDAsiento` varchar(50) NOT NULL,
  `numero` int(11) DEFAULT NULL,
  `avion_id` varchar(30) DEFAULT NULL,
  `disponible` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `avion`
--

DROP TABLE IF EXISTS `avion`;
CREATE TABLE `avion` (
  `IDAvion` varchar(30) NOT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `boleto`
--

DROP TABLE IF EXISTS `boleto`;
CREATE TABLE `boleto` (
  `IDBoleto` int(11) NOT NULL,
  `pasajero_id` int(11) DEFAULT NULL,
  `vuelo_id` int(11) DEFAULT NULL,
  `asiento_id` varchar(50) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `precio_base` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `boleto_servicio`
--

DROP TABLE IF EXISTS `boleto_servicio`;
CREATE TABLE `boleto_servicio` (
  `boleto_id` int(11) NOT NULL,
  `servicio_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

DROP TABLE IF EXISTS `departamento`;
CREATE TABLE `departamento` (
  `IDDepartamento` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `tipo` enum('A?reo','Terrestre') DEFAULT 'Terrestre'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

DROP TABLE IF EXISTS `empleado`;
CREATE TABLE `empleado` (
  `IDEmpleado` int(11) NOT NULL,
  `nombre_empleado` varchar(30) DEFAULT NULL,
  `apellido_empleado` varchar(30) DEFAULT NULL,
  `dni_empleado` char(8) DEFAULT NULL,
  `sueldo` decimal(10,2) DEFAULT NULL,
  `departamento_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

DROP TABLE IF EXISTS `pago`;
CREATE TABLE `pago` (
  `IDPago` int(11) NOT NULL,
  `pasajero_id` int(11) DEFAULT NULL,
  `boleto_id` int(11) DEFAULT NULL,
  `costo_servicios` decimal(10,2) DEFAULT NULL,
  `costo_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pasajero`
--

DROP TABLE IF EXISTS `pasajero`;
CREATE TABLE `pasajero` (
  `IDPasajero` int(11) NOT NULL,
  `nombre_pasajero` varchar(30) DEFAULT NULL,
  `apellido_pasajero` varchar(30) DEFAULT NULL,
  `dni_pasajero` char(8) DEFAULT NULL,
  `telefono` char(10) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `fecha_nacimiento` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

DROP TABLE IF EXISTS `servicio`;
CREATE TABLE `servicio` (
  `IDServicio` int(11) NOT NULL,
  `nombre_servicio` varchar(20) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `descripcion` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vuelo`
--

DROP TABLE IF EXISTS `vuelo`;
CREATE TABLE `vuelo` (
  `IDVuelo` int(11) NOT NULL,
  `avion_id` varchar(30) DEFAULT NULL,
  `origen_id` int(11) DEFAULT NULL,
  `destino_id` int(11) DEFAULT NULL,
  `hora_salida` datetime DEFAULT NULL,
  `hora_llegada` datetime DEFAULT NULL,
  `estado` enum('Completado','Volando','A Tiempo','Atrasado','Cancelado','Choco','Exploto','Perdido') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aeropuerto`
--
ALTER TABLE `aeropuerto`
  ADD PRIMARY KEY (`IDAeropuerto`);

--
-- Indices de la tabla `asiento`
--
ALTER TABLE `asiento`
  ADD PRIMARY KEY (`IDAsiento`),
  ADD KEY `avion_id` (`avion_id`);

--
-- Indices de la tabla `avion`
--
ALTER TABLE `avion`
  ADD PRIMARY KEY (`IDAvion`);

--
-- Indices de la tabla `boleto`
--
ALTER TABLE `boleto`
  ADD PRIMARY KEY (`IDBoleto`),
  ADD KEY `pasajero_id` (`pasajero_id`),
  ADD KEY `vuelo_id` (`vuelo_id`),
  ADD KEY `asiento_id` (`asiento_id`);

--
-- Indices de la tabla `boleto_servicio`
--
ALTER TABLE `boleto_servicio`
  ADD PRIMARY KEY (`boleto_id`,`servicio_id`),
  ADD KEY `servicio_id` (`servicio_id`);

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`IDDepartamento`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`IDEmpleado`),
  ADD KEY `departamento_id` (`departamento_id`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`IDPago`),
  ADD KEY `pasajero_id` (`pasajero_id`),
  ADD KEY `boleto_id` (`boleto_id`);

--
-- Indices de la tabla `pasajero`
--
ALTER TABLE `pasajero`
  ADD PRIMARY KEY (`IDPasajero`);

--
-- Indices de la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`IDServicio`);

--
-- Indices de la tabla `vuelo`
--
ALTER TABLE `vuelo`
  ADD PRIMARY KEY (`IDVuelo`),
  ADD KEY `avion_id` (`avion_id`),
  ADD KEY `origen_id` (`origen_id`),
  ADD KEY `destino_id` (`destino_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `aeropuerto`
--
ALTER TABLE `aeropuerto`
  MODIFY `IDAeropuerto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `boleto`
--
ALTER TABLE `boleto`
  MODIFY `IDBoleto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `departamento`
--
ALTER TABLE `departamento`
  MODIFY `IDDepartamento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `IDEmpleado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pago`
--
ALTER TABLE `pago`
  MODIFY `IDPago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pasajero`
--
ALTER TABLE `pasajero`
  MODIFY `IDPasajero` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `servicio`
--
ALTER TABLE `servicio`
  MODIFY `IDServicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vuelo`
--
ALTER TABLE `vuelo`
  MODIFY `IDVuelo` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asiento`
--
ALTER TABLE `asiento`
  ADD CONSTRAINT `asiento_ibfk_1` FOREIGN KEY (`avion_id`) REFERENCES `avion` (`IDAvion`);

--
-- Filtros para la tabla `boleto`
--
ALTER TABLE `boleto`
  ADD CONSTRAINT `boleto_ibfk_1` FOREIGN KEY (`pasajero_id`) REFERENCES `pasajero` (`IDPasajero`),
  ADD CONSTRAINT `boleto_ibfk_2` FOREIGN KEY (`vuelo_id`) REFERENCES `vuelo` (`IDVuelo`),
  ADD CONSTRAINT `boleto_ibfk_3` FOREIGN KEY (`asiento_id`) REFERENCES `asiento` (`IDAsiento`);

--
-- Filtros para la tabla `boleto_servicio`
--
ALTER TABLE `boleto_servicio`
  ADD CONSTRAINT `boleto_servicio_ibfk_1` FOREIGN KEY (`boleto_id`) REFERENCES `boleto` (`IDBoleto`),
  ADD CONSTRAINT `boleto_servicio_ibfk_2` FOREIGN KEY (`servicio_id`) REFERENCES `servicio` (`IDServicio`);

--
-- Filtros para la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`departamento_id`) REFERENCES `departamento` (`IDDepartamento`);

--
-- Filtros para la tabla `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`pasajero_id`) REFERENCES `pasajero` (`IDPasajero`),
  ADD CONSTRAINT `pago_ibfk_2` FOREIGN KEY (`boleto_id`) REFERENCES `boleto` (`IDBoleto`);

--
-- Filtros para la tabla `vuelo`
--
ALTER TABLE `vuelo`
  ADD CONSTRAINT `vuelo_ibfk_1` FOREIGN KEY (`avion_id`) REFERENCES `avion` (`IDAvion`),
  ADD CONSTRAINT `vuelo_ibfk_2` FOREIGN KEY (`origen_id`) REFERENCES `aeropuerto` (`IDAeropuerto`),
  ADD CONSTRAINT `vuelo_ibfk_3` FOREIGN KEY (`destino_id`) REFERENCES `aeropuerto` (`IDAeropuerto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
