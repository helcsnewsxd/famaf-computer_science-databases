# Usar la db
-- USE world;

# Query 1
-- SELECT Name, Region
-- FROM country
-- ORDER BY Name ASC;

# Query 2
-- SELECT Name, Population
-- FROM country
-- ORDER BY Population DESC
-- LIMIT 10;

# Query 3
-- SELECT Name, Region, SurfaceArea, GovernmentForm
-- FROM country
-- ORDER BY SurfaceArea ASC
-- LIMIT 10;

# Query 4
-- SELECT Name
-- FROM country
-- WHERE IndepYear IS NULL;

# Query 5
-- SELECT Language, Percentage
-- FROM countrylanguage
-- WHERE IsOfficial = 'T';

# Update 6
-- UPDATE countrylanguage 
-- SET Percentage = 100.00
-- WHERE CountryCode = 'AIA';

# Query 7
-- SELECT DISTINCT Name
-- FROM city
-- WHERE District = 'Córdoba'
-- ORDER BY Name;

# Update 8 para sacar Montería
-- DELETE
-- FROM city
-- WHERE District = 'Córdoba'
-- 	AND CountryCode != 'ARG';

# Query 9
-- SELECT Name
-- FROM country
-- WHERE HeadOfState LIKE '%John%';

# Query 10
-- SELECT Name, Population 
-- FROM country
-- WHERE 35e6 <= Population AND Population <= 45e6
-- ORDER BY Population DESC;