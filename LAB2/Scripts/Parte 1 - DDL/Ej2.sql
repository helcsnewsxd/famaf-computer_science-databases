# En caso de tener anteriormente la DB, eliminar (para ejecutar los scripts desde el principio)
DROP DATABASE IF EXISTS world;

# Crear la DB y usarla
CREATE DATABASE world;
USE world;

# Crear las tablas y sus relaciones
# Tabla padre country
CREATE TABLE country (
	Code CHAR(3) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Continent VARCHAR(50),
	Region VARCHAR(50),
	SurfaceArea DOUBLE,
	IndepYear INT,
	Population INT,
	LifeExpectancy DOUBLE,
	GNP DOUBLE,
	GNPOld DOUBLE,
	LocalName VARCHAR(50),
	GovernmentForm VARCHAR(50),
	HeadOfState VARCHAR(50),
	Capital INT,
	Code2 CHAR(2),
	
	PRIMARY KEY(Code)
);

# Tabla city hija de country --> relacionados por country(Code)
CREATE TABLE city (
	ID INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR(50) NOT NULL,
	CountryCode CHAR(3) NOT NULL,
	District VARCHAR(50),
	Population INT,
	
	PRIMARY KEY(ID),
	FOREIGN KEY(CountryCode) REFERENCES country(Code)
);

# Tabla countrylanguage hija de country --> relaciondos por country(Code)
CREATE TABLE countrylanguage (
	CountryCode CHAR(3) NOT NULL,
	`Language` VARCHAR(50) NOT NULL,
	IsOfficial CHAR(1),
	Percentage DOUBLE,
	
	PRIMARY KEY(CountryCode, `Language`),
	FOREIGN KEY(CountryCode) REFERENCES country(Code)
);