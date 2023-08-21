# Usar la DB
USE `world`;

# Crear la tabla Continent
CREATE TABLE `Continent` (
	`Name` enum('', 'South America', 'North America', 'Europe', 'Africa',
		'Asia', 'Oceania', 'Antarctica') NOT NULL DEFAULT '',
	`Area` decimal(12, 2) DEFAULT NULL,
	`PercentTotalMass` decimal(12, 2) DEFAULT NULL,
	`MostPopulousCity` varchar(50) DEFAULT NULL,
	
	PRIMARY KEY (`Name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;