# Usar la DB
USE world;

# Listar los 10 países con menor población del mundo, junto a sus ciudades capitales
# (Hint: puede que uno de estos países no tenga ciudad capital asignada, en este caso deberá mostrar "NULL")
SELECT country.Name, city.Name
FROM country LEFT JOIN city
	ON country.Capital = city.ID
ORDER BY country.Population ASC
LIMIT 10;