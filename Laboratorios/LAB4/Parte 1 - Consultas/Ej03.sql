# Usar la DB
USE world;

# Listar todas aquellas ciudades no asiáticas cuya población sea igual o mayor a la
# población total de algún país de Asia.

SELECT ci.Name AS "City Name" 
FROM city ci
INNER JOIN country co ON
	ci.CountryCode = co.Code AND
	co.Continent != 'Asia'                 # Ciudades no asiáticas
WHERE ci.Population >= SOME (              # Población >= a algún país de Asia
	SELECT Population
	FROM country co2
	WHERE co2.Continent = 'Asia'
)
ORDER BY ci.Population ASC;