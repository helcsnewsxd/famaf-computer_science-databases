# Usar la DB
USE world;

# Crear la tabla Continent
CREATE TABLE Continent (
	Name VARCHAR(50) NOT NULL,
	Area DOUBLE,
	PercentTotalMass DOUBLE,
	MostPopulousCity VARCHAR(50),
	
	PRIMARY KEY(Name)
);