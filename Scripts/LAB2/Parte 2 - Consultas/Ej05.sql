# Usar la DB
USE `world`;

# Liste el nombre y el porcentaje de hablantes que tienen todos los idiomas declarados oficiales.
SELECT `Language`, `Percentage` 
FROM `countrylanguage`
WHERE `IsOfficial` = 'T'
ORDER BY `Language` ASC, `Percentage` ASC;