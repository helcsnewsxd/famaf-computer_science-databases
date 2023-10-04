# Usar la DB

USE sakila;

# Cree una tabla `fines` que tenga dos campos: `rental_id` y `amount`. El primero es
# una clave foránea a la tabla rental y el segundo es un valor numérico con dos
# decimales.

DROP TABLE IF EXISTS sakila.fines;

CREATE TABLE fines (
	rental_id INTEGER NOT NULL,
	amount DECIMAL(15, 2) NOT NULL,
	
	PRIMARY KEY (rental_id),
	CONSTRAINT FK_rental_id
		FOREIGN KEY (rental_id) REFERENCES sakila.rental (rental_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;