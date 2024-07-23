# Usar DB
USE world;

# Listar aquellos países cuyos lenguajes oficiales son el Inglés y el Francés
# (hint: no debería haber filas duplicadas).
(
	SELECT country.Name 
	FROM country INNER JOIN countrylanguage
		ON country.Code = countrylanguage.CountryCode
	WHERE countrylanguage.IsOfficial = 'T' AND
		countrylanguage.`Language` = 'English'
	ORDER BY country.Name
)
INTERSECT
(
	SELECT country.Name 
	FROM country INNER JOIN countrylanguage 
		ON country.Code = countrylanguage.CountryCode
	WHERE countrylanguage.IsOfficial = 'T' AND
		countrylanguage.`Language` = 'French'
	ORDER BY country.Name
);