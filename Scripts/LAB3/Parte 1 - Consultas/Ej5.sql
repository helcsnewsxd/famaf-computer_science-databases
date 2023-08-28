# Usar DB
USE world;

# Listar las ciudades junto a sus idiomas oficiales (ordenado por la población de la ciudad)
# y el porcentaje de hablantes del idioma.
SELECT city.Name, countrylanguage.`Language`, countrylanguage.Percentage
FROM city INNER JOIN countrylanguage
	ON city.CountryCode = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T'
ORDER BY city.Population DESC;