# Usar la DB
USE world;

# ¿Devuelven los mismos valores las siguientes consultas? ¿Por qué?
# ¿Y si en vez de INNER JOIN fuera un LEFT JOIN?
SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code AND country.Name =
'Argentina';

SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina';

# PRIMER CASO
# Devuelven lo mismo dado INNER JOIN da como resultado la interseccion entre city y country tal que
# cumpla las restricciones que se le coloquen. En este caso, solo devuelve las entradas que en ambas
# tablas cumplan la condición, por lo que si en el 2do caso pasó (al ser menos específica la 
# restricción de la intersección), la del WHERE la elimina

# SEGUNDO CASO (con LEFT JOIN)
# A diferencia del caso anterior, lo que sucede aquí es que LEFT JOIN pone sí o sí TODAS las entradas
# de la tabla izquierda y las que coincidan de la derecha (es decir, pone todas las de city y las que
# cumplan con la condición de country).
# Por ello, en la primer query vamos a tener ciudades con países en NULL excepto las que estén en
# Argentina, mientras que, en la segunda, vamos a tener, luego del LEFT JOIN TODAS las ciudades con sus
# correspondientes países, pero va a ser el WHERE quien saque los que no son de Argentina.
# Es decir, la principal diferencia es en cuándo se pone la restricción del país, quedando en uno solo
# las ciudades de Arg, mientras que en el otro están también las demás ciudades con valores de país en NULL