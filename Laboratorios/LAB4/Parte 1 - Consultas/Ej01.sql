# Usar la DB
USE world;

# Listar el nombre de la ciudad y el nombre del país de todas las ciudades que
# pertenezcan a países con una población menor a 10000 habitantes

SELECT ci.Name AS "City Name", co.Name AS "Country Name"
FROM city ci
INNER JOIN country co ON
	ci.CountryCode = co.Code
WHERE co.Population < 10000;