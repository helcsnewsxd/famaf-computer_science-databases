# Usar la DB
USE world;

# Lista el nombre de la ciudad, país, región y forma de gobierno de las 10 ciudades más pobladas del mundo
SELECT city.Name, country.Name, country.Region, country.GovernmentForm
FROM city LEFT JOIN country
	ON city.CountryCode  = country.Code 
ORDER BY city.Population DESC
LIMIT 10;