# Usar la DB

USE sakila;

# Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a
# si el cliente es "premium" o no. Por defecto ningún cliente será premium.

ALTER TABLE sakila.customer
	ADD COLUMN IF NOT EXISTS premium_customer enum('T', 'F') NOT NULL DEFAULT 'F';