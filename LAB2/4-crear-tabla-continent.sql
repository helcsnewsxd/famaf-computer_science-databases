# Crear la tabla Continent
USE world;

CREATE TABLE Continent (
	Name VARCHAR(50) NOT NULL,
	Area DOUBLE,
	PercentTotalMass DOUBLE,
	MostPopulousCity VARCHAR(50),
	
	PRIMARY KEY(Name)
)