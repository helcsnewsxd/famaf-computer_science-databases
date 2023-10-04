# Usar la DB

USE sakila;

# ¿Cuáles fueron la primera y última fecha donde hubo pagos?

SELECT MIN(p.payment_date) AS date_of_first_payment, MAX(p.payment_date) AS date_of_last_payment
FROM sakila.payment p ;
