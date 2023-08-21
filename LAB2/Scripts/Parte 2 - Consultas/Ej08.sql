# Usar DB
USE world;

# Eliminar todas las ciudades que pertenezcan a Córdoba fuera de Argentina.
DELETE 
FROM city
WHERE CountryCode != 'ARG'
	AND District = 'Córdoba';