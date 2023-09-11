# Usar la DB
USE world;

# Listar aquellos países junto a sus idiomas no oficiales, que superen en porcentaje de
# hablantes a cada uno de los idiomas oficiales del país

SELECT co.Name AS "Country Name", cl.`Language` AS "Country Non-Official Language"
FROM countrylanguage cl
INNER JOIN country co ON
	co.Code = cl.CountryCode 
WHERE
	cl.IsOfficial = 'F' AND
	cl.Percentage > ALL (                         # Porcentaje de los idiomas oficiales del país
		SELECT Percentage 
		FROM countrylanguage cl2
		WHERE
			IsOfficial = 'T' AND
			cl.CountryCode = cl2.CountryCode
	);