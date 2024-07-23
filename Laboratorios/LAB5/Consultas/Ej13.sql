# Usar la DB

USE sakila;

# Crear un rol `employee` que tenga acceso de inserción, eliminación y actualización a
# la tabla `rental`.

CREATE ROLE IF NOT EXISTS employee;

GRANT INSERT, DELETE, UPDATE
	ON sakila.rental 
	TO employee;
