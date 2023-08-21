# Usar la DB
USE `world`;

# Liste el nombre, región, superficie y forma de gobierno de los 10 países con menor superficie.
SELECT DISTINCT `Name`, `Region`, `SurfaceArea`, `GovernmentForm`
FROM `country`
ORDER BY `SurfaceArea` ASC 
LIMIT 10;