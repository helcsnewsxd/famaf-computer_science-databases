# Usar la DB
USE world;

# Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea
# mayor al promedio de hablantes de los lenguajes oficiales.

SELECT co.Name AS "Country Name", cl.`Language` AS "Non-Official Language" 
FROM country co
INNER JOIN countrylanguage cl ON
	co.Code = cl.CountryCode AND
	cl.IsOfficial = 'F' AND 
	cl.Percentage > (
		SELECT AVG(Percentage)
		FROM countrylanguage cl2
		WHERE cl2.IsOfficial = 'T'
	);