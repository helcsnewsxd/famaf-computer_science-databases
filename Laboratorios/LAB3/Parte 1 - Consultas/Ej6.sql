# Usar DB
USE world;

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