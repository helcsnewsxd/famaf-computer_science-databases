# Usar DB
USE world;

# Listar aquellos países que tengan hablantes del Inglés pero no del Español en su población
(
	SELECT country.Name
	FROM country INNER JOIN countrylanguage
		ON country.Code = countrylanguage.CountryCode
	WHERE countrylanguage.`Language` = 'English'
)
EXCEPT
(
	SELECT country.Name
	FROM country INNER JOIN countrylanguage
		ON country.Code = countrylanguage.CountryCode
	WHERE countrylanguage.`Language` = 'Spanish'
);