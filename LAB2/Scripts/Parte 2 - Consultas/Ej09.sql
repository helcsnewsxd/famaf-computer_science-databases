# Usar la DB
USE world;

# Listar los países cuyo Jefe de Estado se llame John.
SELECT DISTINCT Name
FROM country
WHERE HeadOfState LIKE '%John%'
ORDER BY Name ASC;