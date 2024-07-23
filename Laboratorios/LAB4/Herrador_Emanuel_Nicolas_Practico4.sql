-- PRELIMINARES
# Usar la DB
USE world;

-- PARTE 1 - CONSULTAS

-- EJERCICIO 1

# Listar el nombre de la ciudad y el nombre del país de todas las ciudades que
# pertenezcan a países con una población menor a 10000 habitantes

SELECT ci.Name AS "City Name", co.Name AS "Country Name"
FROM city ci
INNER JOIN country co ON
	ci.CountryCode = co.Code
WHERE co.Population < 10000;

-- EJERCICIO 2

# Listar todas aquellas ciudades cuya población sea mayor que la población promedio
# entre todas las ciudades.

SELECT Name AS "City Name"  
FROM city ci
WHERE Population > (
	SELECT AVG(Population)
	FROM city ci2
)
ORDER BY Population ASC;

-- EJERCICIO 3

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

-- EJERCICIO 4

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

-- EJERCICIO 5

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

-- EJERCICIO 6

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

-- EJERCICIO 7

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

-- EJERCICIO 8

# Listar la cantidad de habitantes por continente ordenado en forma descendente.

SELECT Continent, SUM(Population)
FROM country co
GROUP BY Continent
ORDER BY Population DESC;

-- EJERCICIO 9

# Listar el promedio de esperanza de vida (LifeExpectancy) por continente con una
# esperanza de vida entre 40 y 70 años.

SELECT Continent, AVG(LifeExpectancy) AS `Life Expectancy Average`
FROM country
GROUP BY Continent
HAVING `Life Expectancy Average` BETWEEN 40 AND 70;

-- EJERCICIO 10

# Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente

SELECT
	Continent AS `Continent`,
	MAX(Population) AS `Max Population`,
	MIN(Population) AS `Min Population`,
	AVG(Population) AS `Population Average`,
	SUM(Population) AS `Population Sum`
FROM country
GROUP BY Continent; 

-- PARTE 2 - PREGUNTAS

-- EJERCICIO 1

# Si en la consulta 6 se quisiera devolver, además de las columnas ya solicitadas, el
# nombre de la ciudad más poblada. ¿Podría lograrse con agrupaciones? ¿y con una
# subquery escalar?
	# El ej6 era:
		# Listar el nombre de cada país con la cantidad de habitantes de su ciudad más
		# poblada. (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas
		# escalares o usando agrupaciones, encontrar ambas).

# CON CONSULTAS ESCALARES

WITH city_with_max_population_for_country AS (
	SELECT DISTINCT
		co.Code AS country_code,
		ci.Name AS city_with_max_population_name,
		ci.Population AS max_population
	FROM country co
	LEFT JOIN city ci ON
		co.Code = ci.CountryCode
	WHERE ci.Population = (
		SELECT MAX(Population)
		FROM city ci2
		WHERE co.Code = CountryCode
	)
)
SELECT
	co.Name AS "Country Name",
	(
		SELECT max_population
		FROM city_with_max_population_for_country city_mp
		WHERE co.Code = country_code
	) AS "Max City Population",
	(
		SELECT city_with_max_population_name
		FROM city_with_max_population_for_country city_mp
		WHERE co.Code = country_code
	) AS "City with max population"
FROM country co;


# CON AGRUPACIONES

# Dada la naturaleza de las agrupaciones, no se puede "destacar" un elemento en particular de uno de
# los grupos sin usar una subquery para buscarlo