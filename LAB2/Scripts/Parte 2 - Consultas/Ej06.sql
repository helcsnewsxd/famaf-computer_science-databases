# Usar DB
USE world;

# Actualizar el valor de porcentaje del idioma inglés en el país con código 'AIA' a 100.0
UPDATE countrylanguage
SET Percentage = 100.0
WHERE CountryCode = 'AIA';