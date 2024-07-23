# Usar la DB
USE world;

# Listar todas aquellas ciudades cuya población sea mayor que la población promedio
# entre todas las ciudades.

SELECT Name AS "City Name"  
FROM city ci
WHERE Population > (
	SELECT AVG(Population)
	FROM city ci2
)
ORDER BY Population ASC;