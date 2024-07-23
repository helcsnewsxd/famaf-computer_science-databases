-- PRELIMINARES
# Usar DB
USE world;

-- PARTE 1 - CONSULTAS

-- EJERCICIO 1

# Lista el nombre de la ciudad, país, región y forma de gobierno de las 10 ciudades más pobladas del mundo
SELECT city.Name, country.Name, country.Region, country.GovernmentForm
FROM city LEFT JOIN country
	ON city.CountryCode  = country.Code 
ORDER BY city.Population DESC
LIMIT 10;

-- EJERCICIO 2

# Listar los 10 países con menor población del mundo, junto a sus ciudades capitales
# (Hint: puede que uno de estos países no tenga ciudad capital asignada, en este caso deberá mostrar "NULL")
SELECT country.Name, city.Name
FROM country LEFT JOIN city
	ON country.Capital = city.ID
ORDER BY country.Population ASC
LIMIT 10;

-- EJERCICIO 3

# Listar el nombre, continente y todos los lenguajes oficiales de cada país.
# (Hint: habrá más de una fila por país si tiene varios idiomas oficiales).
SELECT country.Name, country.Continent, countrylanguage.`Language` 
FROM country INNER JOIN countrylanguage 
	ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T'
ORDER BY country.Name ASC;

-- EJERCICIO 4

# Listar el nombre del país y nombre de capital, de los 20 países con mayor superficie del mundo.
SELECT country.Name, city.Name
FROM country LEFT JOIN city
	ON country.Capital = city.ID 
ORDER BY country.SurfaceArea DESC 
LIMIT 20;

-- EJERCICIO 5

# Listar las ciudades junto a sus idiomas oficiales (ordenado por la población de la ciudad)
# y el porcentaje de hablantes del idioma.
SELECT city.Name, countrylanguage.`Language`, countrylanguage.Percentage
FROM city INNER JOIN countrylanguage
	ON city.CountryCode = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T'
ORDER BY city.Population DESC;

-- EJERCICIO 6

# Listar los 10 países con mayor población y los 10 países con menor población
# (que tengan al menos 100 habitantes) en la misma consulta.
(
	SELECT Name 
	FROM country
	ORDER BY Population DESC
	LIMIT 10
)
UNION
(
	SELECT Name 
	FROM country
	WHERE Population >= 100
	ORDER BY Population ASC
	LIMIT 10
);

-- EJERCICIO 7

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

-- EJERCICIO 8

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

-- PARTE 2 - PREGUNTAS

# ¿Devuelven los mismos valores las siguientes consultas? ¿Por qué?
# ¿Y si en vez de INNER JOIN fuera un LEFT JOIN?
SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code AND country.Name =
'Argentina';

SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina';

# PRIMER CASO
# Devuelven lo mismo dado INNER JOIN da como resultado la interseccion entre city y country tal que
# cumpla las restricciones que se le coloquen. En este caso, solo devuelve las entradas que en ambas
# tablas cumplan la condición, por lo que si en el 2do caso pasó (al ser menos específica la 
# restricción de la intersección), la del WHERE la elimina

# SEGUNDO CASO (con LEFT JOIN)
# A diferencia del caso anterior, lo que sucede aquí es que LEFT JOIN pone sí o sí TODAS las entradas
# de la tabla izquierda y las que coincidan de la derecha (es decir, pone todas las de city y las que
# cumplan con la condición de country).
# Por ello, en la primer query vamos a tener ciudades con países en NULL excepto las que estén en
# Argentina, mientras que, en la segunda, vamos a tener, luego del LEFT JOIN TODAS las ciudades con sus
# correspondientes países, pero va a ser el WHERE quien saque los que no son de Argentina.
# Es decir, la principal diferencia es en cuándo se pone la restricción del país, quedando en uno solo
# las ciudades de Arg, mientras que en el otro están también las demás ciudades con valores de país en NULL