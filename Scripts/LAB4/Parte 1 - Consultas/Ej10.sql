# Usar la DB
USE world;

# Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente

SELECT
	Continent AS `Continent`,
	MAX(Population) AS `Max Population`,
	MIN(Population) AS `Min Population`,
	AVG(Population) AS `Population Average`,
	SUM(Population) AS `Population Sum`
FROM country
GROUP BY Continent; 