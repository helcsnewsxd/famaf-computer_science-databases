# Usar la DB
USE `world`;

# Modificar la tabla country para que sea hija de Continent --> Relacionados por Continent(Name)
ALTER TABLE `country`
ADD CONSTRAINT `FK_Continent_1`
	FOREIGN KEY (`Continent`) REFERENCES `Continent` (`Name`);