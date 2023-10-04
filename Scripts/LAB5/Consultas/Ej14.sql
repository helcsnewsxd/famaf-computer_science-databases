# Usar DB

USE sakila;

# Revocar el acceso de eliminación a `employee` y crear un rol `administrator` que
# tenga todos los privilegios sobre la BD `sakila`.

REVOKE DELETE
	ON sakila.rental 
	FROM employee;



CREATE ROLE IF NOT EXISTS administrator;

GRANT ALL PRIVILEGES
	ON sakila
	TO administrator;
