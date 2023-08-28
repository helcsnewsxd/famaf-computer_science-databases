# Usar la DB
USE world;

# Listar el nombre, continente y todos los lenguajes oficiales de cada país.
# (Hint: habrá más de una fila por país si tiene varios idiomas oficiales).
SELECT country.Name, country.Continent, countrylanguage.`Language` 
FROM country INNER JOIN countrylanguage 
	ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T'
ORDER BY country.Name ASC;