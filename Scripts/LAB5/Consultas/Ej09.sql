# Usar la DB

USE sakila;

# Modifique la table `inventory_id` agregando una columna `stock` que sea un número
# entero y representa la cantidad de copias de una misma película que tiene
# determinada tienda. El número por defecto debería ser 5 copias.

ALTER TABLE sakila.inventory 
	ADD COLUMN IF NOT EXISTS stock INT UNSIGNED DEFAULT 5;