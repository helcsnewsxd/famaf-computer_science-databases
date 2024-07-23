# Usar la DB
USE `world`;

# Liste todos los países que no tienen independencia (hint: ver que define la independencia de un país en la BD).
SELECT DISTINCT `Name`
FROM `country`
WHERE `IndepYear` IS NULL;