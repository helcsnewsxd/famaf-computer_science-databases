# Usar la DB
USE `world`;

# Listar los países cuya población esté entre 35 M y 45 M ordenados por población de forma descendente.
SELECT `Name`
FROM `country`
WHERE 35e6 <= `Population` 
	AND `Population` <= 45e6
ORDER BY `Population` DESC;