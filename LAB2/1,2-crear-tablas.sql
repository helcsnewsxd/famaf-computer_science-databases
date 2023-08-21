# En caso de tener la DB anteriormente, eliminar
DROP DATABASE IF EXISTS world;

# Creo y uso la db
CREATE DATABASE world;
USE world;

# Creo las tablas con sus relaciones
# Tabla padre de Country
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

# Tabla City hija de Country
CREATE TABLE city (
	ID INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR(50) NOT NULL,
	CountryCode CHAR(3) NOT NULL,
	District VARCHAR(50),
	Population INT,
	
	PRIMARY KEY(ID),
	FOREIGN KEY(CountryCode) REFERENCES country(Code)
);

# Tabla CountryLanguage hija de Country
CREATE TABLE countrylanguage (
	CountryCode CHAR(3) NOT NULL,
	Language VARCHAR(50) NOT NULL,
	IsOfficial CHAR(1),
	Percentage DOUBLE,
	
	PRIMARY KEY(CountryCode, Language),
	FOREIGN KEY(CountryCode) REFERENCES country(Code)
);