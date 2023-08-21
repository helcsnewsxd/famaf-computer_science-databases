# Usar la DB
USE `world`;

# Devuelva una lista de los nombres y las regiones a las que pertenece cada país ordenada alfabéticamente.
SELECT DISTINCT `Name`, `Region`
FROM `country`
ORDER BY `Name` ASC;