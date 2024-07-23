# Usar la DB

USE sakila;

# Cree una tabla de `directors` con las columnas: Nombre, Apellido, Número de
# Películas

DROP TABLE IF EXISTS directors;

CREATE TABLE directors (
	directors_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(30) NOT NULL DEFAULT "",
	last_name VARCHAR(30) NOT NULL DEFAULT "",
	cnt_films INT UNSIGNED NOT NULL DEFAULT 0,
	
	last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	PRIMARY KEY (directors_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;