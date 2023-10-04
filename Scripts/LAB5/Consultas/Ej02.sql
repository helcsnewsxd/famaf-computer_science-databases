# Usar la DB

USE sakila;

# El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e.
# el mayor número de películas filmadas) son también directores de las películas en
# las que participaron. Basados en esta información, inserten, utilizando una subquery
# los valores correspondientes en la tabla `directors`.

INSERT INTO directors (first_name, last_name, cnt_films)

WITH top5_actors AS (
	SELECT a.first_name, a.last_name, COUNT(fa.actor_id) AS cnt_films
	FROM actor a
		LEFT JOIN film_actor fa ON
			a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	ORDER BY cnt_films DESC
	LIMIT 5
)
SELECT top5.first_name, top5.last_name, top5.cnt_films
FROM top5_actors top5;