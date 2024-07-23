# Usar la DB
USE world;

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