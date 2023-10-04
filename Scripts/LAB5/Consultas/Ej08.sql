# Usar la DB

USE sakila;

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