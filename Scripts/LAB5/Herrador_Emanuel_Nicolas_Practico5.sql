# Usar la DB

USE sakila;

# =================== EJERCICIO 1
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

# =================== EJERCICIO 2
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

# =================== EJERCICIO 3
# Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a
# si el cliente es "premium" o no. Por defecto ningún cliente será premium.

ALTER TABLE sakila.customer
	ADD COLUMN IF NOT EXISTS premium_customer enum('T', 'F') NOT NULL DEFAULT 'F';

# =================== EJERCICIO 4
# Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` de
# los 10 clientes con mayor dinero gastado en la plataforma.

# Tabla de customer - sum of payments

CREATE TEMPORARY TABLE totalPaymentForCustomer AS (
	SELECT c.customer_id AS customer, SUM(p.amount) AS totalAmount
	FROM sakila.customer c
		LEFT JOIN sakila.payment p 
		ON p.customer_id = c.customer_id
	GROUP BY c.customer_id
);

# Tabla del top10

CREATE TEMPORARY TABLE customerTop10ForPayment AS (
	SELECT tc.customer AS customer
	FROM sakila.totalPaymentForCustomer tc
	ORDER BY tc.totalAmount
	LIMIT 10
);

# Marcar con T premium_customer para el TOP 10

UPDATE sakila.customer c
SET c.premium_customer = 'T'
WHERE c.customer_id IN (
    SELECT top10.customer
    FROM customerTop10ForPayment top10
);

# Eliminar tablas temporales

DROP TABLE sakila.totalPaymentForCustomer;
DROP TABLE sakila.customerTop10ForPayment;

# =================== EJERCICIO 5
# Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings
# de las películas existentes (Hint: rating se refiere en este caso a la clasificación
# según edad: G, PG, R, etc).

SELECT f.rating AS rating, COUNT(f.film_id) AS quantity
FROM sakila.film f 
GROUP BY f.rating 
ORDER BY quantity DESC ;

# =================== EJERCICIO 6
# ¿Cuáles fueron la primera y última fecha donde hubo pagos?

SELECT MIN(p.payment_date) AS date_of_first_payment, MAX(p.payment_date) AS date_of_last_payment
FROM sakila.payment p ;

# =================== EJERCICIO 7
# Calcule, por cada mes, el promedio de pagos (Hint: vea la manera de extraer el
# nombre del mes de una fecha).

SELECT MONTHNAME(p.payment_date) AS `Month`, AVG(p.amount) AS amount_average
FROM sakila.payment p 
GROUP BY `Month`;

# =================== EJERCICIO 8
# Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total
# de alquileres).

WITH rentalForDistrict AS (
	SELECT r.rental_id AS vrental, t2.vdistrict AS vdistrict # rental - inventory
	FROM ( # inventory - store
		SELECT i.inventory_id AS vintentory, t1.vdistrict AS vdistrict
		FROM ( # store - address
			SELECT s.store_id AS vstore, a.district AS vdistrict 
			FROM sakila.address a 
				INNER JOIN sakila.store s 
				ON s.address_id = a.address_id 
		) AS t1
			INNER JOIN sakila.inventory i 
			ON i.store_id = t1.vstore
	) AS t2
		INNER JOIN sakila.rental r 
		ON r.inventory_id = t2.vintentory
)
SELECT rfd.vdistrict AS district, COUNT(rfd.vrental) AS quantity
FROM rentalForDistrict rfd
GROUP BY district
ORDER BY quantity DESC
LIMIT 10;

# =================== EJERCICIO 9
# Modifique la table `inventory_id` agregando una columna `stock` que sea un número
# entero y representa la cantidad de copias de una misma película que tiene
# determinada tienda. El número por defecto debería ser 5 copias.

ALTER TABLE sakila.inventory 
	ADD COLUMN IF NOT EXISTS stock INT UNSIGNED DEFAULT 5;

# =================== EJERCICIO 10
# Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la
# tabla rental, haga un update en la tabla `inventory` restando una copia al stock de la
# película rentada (Hint: revisar que el rental no tiene información directa sobre la
# tienda, sino sobre el cliente, que está asociado a una tienda en particular).

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS update_stock AFTER INSERT ON sakila.rental 
	FOR EACH ROW
	BEGIN 
		UPDATE sakila.inventory
		SET stock = stock - 1
		WHERE inventory_id = NEW.inventory_id;
	END$$
DELIMITER ;

# =================== EJERCICIO 11
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

# =================== EJERCICIO 12
# Cree un procedimiento `check_date_and_fine` que revise la tabla `rental` y cree un
# registro en la tabla `fines` por cada `rental` cuya devolución (return_date) haya
# tardado más de 3 días (comparación con rental_date). El valor de la multa será el
# número de días de retraso multiplicado por 1.5.

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS check_date_and_fine()
BEGIN
	INSERT INTO sakila.fines (rental_id, amount)
		SELECT r.rental_id, DATEDIFF(r.return_date, r.rental_date) * 1.5
		FROM sakila.rental r 
		WHERE DATEDIFF(r.return_date, r.rental_date) > 3
			AND r.rental_id NOT IN (
				SELECT f.rental_id 
				FROM sakila.fines f 
			);
END //

DELIMITER ;

# =================== EJERCICIO 13
# Crear un rol `employee` que tenga acceso de inserción, eliminación y actualización a
# la tabla `rental`.

CREATE ROLE IF NOT EXISTS employee;

GRANT INSERT, DELETE, UPDATE
	ON sakila.rental 
	TO employee;

# =================== EJERCICIO 14
# Revocar el acceso de eliminación a `employee` y crear un rol `administrator` que
# tenga todos los privilegios sobre la BD `sakila`.

REVOKE DELETE
	ON sakila.rental 
	FROM employee;



CREATE ROLE IF NOT EXISTS administrator;

GRANT ALL PRIVILEGES
	ON sakila
	TO administrator;

# =================== EJERCICIO 15
# Crear dos roles de empleado. A uno asignarle los permisos de `employee` y al otro
# de `administrator`.

CREATE ROLE IF NOT EXISTS employee1;
CREATE ROLE IF NOT EXISTS employee2;

GRANT employee
	TO employee1;

GRANT administrator
	TO employee2;

# Para ver los roles que se les asignaron
SHOW GRANTS FOR employee;
SHOW GRANTS FOR administrator;
SHOW GRANTS FOR employee1;
SHOW GRANTS FOR employee2;