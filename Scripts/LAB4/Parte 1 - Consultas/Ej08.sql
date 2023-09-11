# Usar la DB
USE world;

# Listar la cantidad de habitantes por continente ordenado en forma descendente.

SELECT Continent, SUM(Population)
FROM country co
GROUP BY Continent
ORDER BY Population DESC;