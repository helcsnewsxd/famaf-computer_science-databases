# Usar DB
USE world;

# Listar las ciudades que pertenecen a Córdoba (District) dentro de Argentina.
SELECT Name
FROM city
WHERE CountryCode = 'ARG'
	AND District = 'Córdoba'
ORDER BY Name ASC;