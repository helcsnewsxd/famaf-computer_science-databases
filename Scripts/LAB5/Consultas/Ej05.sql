# Usar la DB

USE sakila;

# Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings
# de las películas existentes (Hint: rating se refiere en este caso a la clasificación
# según edad: G, PG, R, etc).

SELECT f.rating AS rating, COUNT(f.film_id) AS quantity
FROM sakila.film f 
GROUP BY f.rating 
ORDER BY quantity DESC ;