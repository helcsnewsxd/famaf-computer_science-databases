# Usar la DB
USE world;

# Listar el promedio de esperanza de vida (LifeExpectancy) por continente con una
# esperanza de vida entre 40 y 70 años.

SELECT Continent, AVG(LifeExpectancy) AS `Life Expectancy Average`
FROM country
GROUP BY Continent
HAVING `Life Expectancy Average` BETWEEN 40 AND 70;