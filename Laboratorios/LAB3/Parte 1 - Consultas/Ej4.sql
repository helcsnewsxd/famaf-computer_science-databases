# Usar la DB
USE world;

# Listar el nombre del país y nombre de capital, de los 20 países con mayor superficie del mundo.
SELECT country.Name, city.Name
FROM country LEFT JOIN city
	ON country.Capital = city.ID 
ORDER BY country.SurfaceArea DESC 
LIMIT 20;