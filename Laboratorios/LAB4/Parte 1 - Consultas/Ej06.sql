# Usar la DB
USE world;

# Listar el nombre de cada país con la cantidad de habitantes de su ciudad más
# poblada. (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas
# escalares o usando agrupaciones, encontrar ambas).

# CON CONSULTAS ESCALARES

SELECT
	co.Name AS "Country Name",
	(
		SELECT MAX(Population)
		FROM city ci
		WHERE CountryCode = co.Code 
	) AS "Max City Population"
FROM country co;

# CON AGRUPACIONES

SELECT co.Name AS "Country Name", MAX(ci.Population) AS "Max City Population"
FROM country co
LEFT JOIN city ci ON
	co.Code = ci.CountryCode
GROUP BY co.Name;