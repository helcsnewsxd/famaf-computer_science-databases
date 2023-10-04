# Usar la DB

USE sakila;

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
