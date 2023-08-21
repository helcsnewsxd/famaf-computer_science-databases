# Usar la DB
USE `world`;

# Liste el nombre y la población de las 10 ciudades más pobladas del mundo.
SELECT DISTINCT `Name`, `Population`
FROM `country`
ORDER BY `Population` DESC
LIMIT 10;