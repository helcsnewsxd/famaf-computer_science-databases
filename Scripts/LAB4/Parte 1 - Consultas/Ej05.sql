# Usar la DB
USE world;

# Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor
# a 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes.
# (Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas
# respuestas)

# CON SUBQUERY

SELECT DISTINCT Region AS "Region Name"
FROM country co
WHERE
	SurfaceArea < 1000 AND
	EXISTS (
		SELECT Population
		FROM city ci
		WHERE
			Population > 100000 AND
			CountryCode = co.Code
	);

# SIN SUBQUERY

SELECT DISTINCT co.Region AS "Region Name"
FROM country co
INNER JOIN city ci ON
	co.Code = ci.CountryCode AND
	ci.Population > 100000
WHERE co.SurfaceArea < 1000;