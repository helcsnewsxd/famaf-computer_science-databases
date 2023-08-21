# En caso de tener anteriormente la DB, eliminar (para ejecutar los scripts desde el principio)
DROP DATABASE IF EXISTS `world`;

# Crear la DB y usarla
CREATE DATABASE `world`;
USE `world`;

# Crear las tablas y sus relaciones
# Tabla padre country
CREATE TABLE `country` (
	`Code` char(3) NOT NULL DEFAULT '',
	`Name` varchar(50) NOT NULL DEFAULT '',
	`Continent` enum('', 'South America', 'North America', 'Europe', 'Africa',
		'Asia', 'Oceania', 'Antarctica') NOT NULL DEFAULT '',
	`Region` varchar(50) DEFAULT NULL,
	`SurfaceArea` decimal(12, 2) DEFAULT NULL,
	`IndepYear` smallint DEFAULT NULL,
	`Population` int DEFAULT NULL,
	`LifeExpectancy` decimal(12, 2) DEFAULT NULL,
	`GNP` decimal(12, 2) DEFAULT NULL,
	`GNPOld` decimal(12, 2) DEFAULT NULL,
	`LocalName` varchar(50) DEFAULT NULL,
	`GovernmentForm` varchar(50) DEFAULT NULL,
	`HeadOfState` varchar(50) DEFAULT NULL,
	`Capital` int DEFAULT NULL,
	`Code2` char(2) DEFAULT NULL,
	
	PRIMARY KEY (`Code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# Tabla city hija de country --> relacionados por country(Code)
CREATE TABLE `city` (
	`ID` int NOT NULL AUTO_INCREMENT,
	`Name` varchar(50) NOT NULL DEFAULT '',
	`CountryCode` char(3) NOT NULL DEFAULT '',
	`District` varchar(50) DEFAULT NULL,
	`Population` int DEFAULT NULL,
	
	PRIMARY KEY (`ID`),
	CONSTRAINT `FK_city_1`
		FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# Tabla countrylanguage hija de country --> relaciondos por country(Code)
CREATE TABLE `countrylanguage` (
	`CountryCode` char(3) NOT NULL DEFAULT '',
	`Language` varchar(50) NOT NULL DEFAULT '',
	`IsOfficial` enum('X', 'T', 'F') NOT NULL DEFAULT 'X',
	`Percentage` decimal(12, 2) DEFAULT NULL,
	
	PRIMARY KEY (`CountryCode`, `Language`),
	CONSTRAINT `FK_countrylanguage_1`
		FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;